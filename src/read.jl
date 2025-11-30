function read(
    ads :: ARMDataset,
    dt  :: TimeType
)

    fol = joinpath(ads.path,Dates.format(dt,dateformat"yyyy/mm"))
    fncvec = glob("$(dt2fstr(dt))*.nc",fol)

    if isone(length(fncvec))
        return NCDataset(fncvec[1])
    else
        return NCDataset(fncvec,aggdim = "time")
    end

end

function dt2fstr(dt :: Date)

    return Dates.format(dt,dateformat"yyyymmdd")

end

function dt2fstr(dt :: DateTime)

    return Dates.format(dt,dateformat"yyyymmddHH")

end