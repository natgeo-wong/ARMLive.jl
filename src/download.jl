"""
    query(ads::ARMDataset)

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