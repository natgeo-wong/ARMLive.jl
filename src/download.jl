"""
    query(ads :: ARMDataset)

Retrieve a list of available files for an ARM data stream.

Arguments
=========
- `ads`: An ARMDataset type.
"""
function query(ads::ARMDataset)

    # prefix = datastream(ads)
    token  = armtoken()
    return query(ads,token)

end

function query(ads :: ARMDataset, token :: Dict)

    @info "$(modulelog()) - Retrieving list of files for the $(ads.stream) Data Stream from $(ads.start) to $(ads.stop) ..."
    a = download("https://adc.arm.gov/armlive/query?user=$(token["user"]):$(token["token"])&ds=$(ads.stream)&start=$(ads.start)&end=$(ads.stop)&wt=json")
    b = JSON3.read(a)
    fIDvec = b.files
    return fIDvec

end

"""
    download(
        ads :: ARMDataset;
        overwrite   :: Bool = false,
        interactive :: Bool = true
    ) -> nothing

Download ARM data files for a specified data stream and time period.

Arguments
=========
- `ads` : An ARMDataset type

Keyword Arguments
=================
- `overwrite` : If `true`, overwrite existing files. If `false`, skip files that already exist. Defaults to `false`.
- `interactive` : If `true`, display a progress bar during download. If `false`, log download messages instead. Defaults to `true`.
"""
function download(
    ads :: ARMDataset;
    overwrite   :: Bool = false,
    interactive :: Bool = true
)

    token  = armtoken()
    fIDvec = query(ads,token); nfID = length(fIDvec)
    dtstr  = fID2dtstr(fIDvec)
    if interactive
        p = Progress(nfID;dt=0,desc="Downloading:",barglyphs=BarGlyphs("[=> ]"))
    end
    for iID = 1 : nfID
        fol = joinpath(ads.path,dtstr[iID][1:4],dtstr[iID][5:6])
        if !isdir(fol); mkpath(fol) end
        if !isfile(joinpath(fol,"$(dtstr[iID]).nc")) || overwrite
            download(
                "https://adc.arm.gov/armlive/saveData?user=$(token["user"]):$(token["token"])&file=$(fIDvec[iID])",
                joinpath(fol,"$(dtstr[iID]).nc")
            )
        end
        if interactive; next!(p)
        else
            @info "$(modulelog()) - Downloading $(fIDvec[iID]) from the ARMLive servers to the path $(joinpath(fol,"$(dtstr[iID]).nc"))"
        end
    end
    if interactive; finish!(p) end

end

"""
    download(
        ads :: ARMDataset,
        variables   :: Vector{<:AbstractString};
        overwrite   :: Bool = false,
        interactive :: Bool = true
    ) -> nothing

Download ARM data files for a specified data stream and time period and extract variables of interest if they exist into separate files/folders. This will help to save space when there are too many variables around.

Arguments
=========
- `ads` : An ARMDataset type
- `variables` : A vector of variable names (in String format)

Keyword Arguments
=================
- `overwrite` : If `true`, overwrite existing files. If `false`, skip files that already exist. Defaults to `false`.
- `interactive` : If `true`, display a progress bar during download. If `false`, log download messages instead. Defaults to `true`.
"""
function download(
    ads :: ARMDataset,
    variables   :: Vector{<:AbstractString};
    overwrite   :: Bool = false,
    interactive :: Bool = true
)

    token  = armtoken()
    fIDvec = query(ads,token); nfID = length(fIDvec)
    dtstr  = fID2dtstr(fIDvec)
    if interactive
        p = Progress(nfID;dt=0,desc="Downloading:",barglyphs=BarGlyphs("[=> ]"))
    end
    for iID = 1 : nfID
        fol = joinpath(ads.path,dtstr[iID][1:4],dtstr[iID][5:6])
        if !isdir(fol); mkpath(fol) end
        nvar = length(variables); isnc = zeros(Bool,nvar)
        for ivar in 1 : nvar
            isnc[ivar] = !isfile(joinpath(fol,"$(dtstr[iID])-$(variables[ivar]).nc"))
        end
        if !iszero(sum(isnc)) || overwrite
            download(
                "https://adc.arm.gov/armlive/saveData?user=$(token["user"]):$(token["token"])&file=$(fIDvec[iID])",
                joinpath(ads.path,"$(dtstr[iID]).nc")
            )
            
            tds = NCDataset(joinpath(ads.path,"$(dtstr[iID]).nc"))
            for ivariable in variables

                fID = joinpath(fol,"$(dtstr[iID])-$(ivariable).nc")
                if isfile(fID) && overwrite; rm(fID,force=true) end
                if !isfile(fID) && haskey(tds,ivariable)
                    ds = NCDataset(fID,"c",attrib=Dict(tds.attrib))
                    for dimname in keys(tds.dim)
                        defDim(ds,dimname,tds.dim[dimname])
                    end
                    for dimname in keys(tds.dim)
                        if haskey(tds,dimname); extract(ds,tds,dimname) end
                    end
                    extract(ds,tds,ivariable)
                    close(ds)
                end
                
            end
            close(tds)

            rm(joinpath(ads.path,"$(dtstr[iID]).nc"),force=true)
        end
        if interactive; next!(p)
        else
            @info "$(modulelog()) - Downloading $(fIDvec[iID]) and extracting Variables $(variables) from the ARMLive servers to the path $(fol)"
        end
    end
    if interactive; finish!(p) end

end

function extract(
    ds  :: NCDataset,
    tds :: NCDataset,
    varname :: AbstractString
)

    v = variable(tds,varname)
    defVar(ds,varname,eltype(v),dimnames(v),attrib=Dict(v.attrib))
    ds[varname].var[:] = tds[varname].var[:]

end

function fID2dtstr(fIDvec::JSON3.Array)

    nID = length(fIDvec)
    dtstr = Vector(undef,nID)

    for iID = 1 : nID
        
        ifID = fIDvec[iID]
        strsplit = split(ifID,".")
        dtstr[iID] = strsplit[3] * strsplit[4]

    end

    return dtstr

end