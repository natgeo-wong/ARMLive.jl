function read(
    ads :: ARMDataset,
    dt  :: TimeType;
    throw :: Bool = true
)

    fol = joinpath(ads.path,Dates.format(dt,dateformat"yyyy/mm"))
    fncvec = glob("$(dt2fstr(dt))*.nc",fol)

    if isone(length(fncvec))
        return NCDataset(fncvec[1])
    elseif length(fncvec) > 1
        return NCDataset(fncvec,aggdim = "time")
    else
        if throw
            error("$(modulelog()) - No data exists for $(ads.stream) in $(ads.path) for the DateTime $(dt)")
        else
            @warn "$(modulelog()) - No data exists for $(ads.stream) in $(ads.path) for the DateTime $(dt)"
            return nothing
        end
    end

end

function dt2fstr(dt :: Date)

    return Dates.format(dt,dateformat"yyyymmdd")

end

function dt2fstr(dt :: DateTime)

    return Dates.format(dt,dateformat"yyyymmddHH")

end