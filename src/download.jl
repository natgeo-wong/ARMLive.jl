function query(ads::ARMDataset)

    # prefix = datastream(ads)
    token  = armtoken()
    return query(ads,token)

end

function query(ads :: ARMDataset, token::Dict)

    a = download("https://adc.arm.gov/armlive/query?user=$(token[user]):$(token[token])&ds=$(ads.stream)&start=$(ads.start)&end=$(ads.stop)&wt=json")
    b = JSON3.read(a)
    fIDvec = b.files
    return fIDvec

end

function download(ads::ARMDataset)

    token  = armtoken()
    fIDvec = query(ads,token)
    dtstr  = fID2dtstr(fIDvec)
    for iID = 1 : length(fIDvec)
        download(
            "https://adc.arm.gov/armlive/saveData?user=$(token["user"]):$(token["token"])&file=$(fIDvec[iID])",
            joinpath(ads.path,ads.stream,"$(dtstr[iID]).nc")
        )
    end

end

function fID2dtstr(fIDvec::Vector{AbstractString})

    nID = length(fIDvec)
    dtstr = Vector(undef,nID)

    for iID = 1 : nID
        
        ifID = fIDvec[iID]
        strsplit = split(ifID,".")
        dtstr[iID] = strsplit[3] * strsplit[4]

    end

end