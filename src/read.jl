"""
    read(
        ads :: ARMDataset,
        dt  :: TimeType;
        throw :: Bool = true
    ) -> ds :: NCDataset

Read ARM data from NetCDF files for a specified date or datetime.

Arguments
=========
- `ads`   : An ARMDataset object specifying the data stream and storage path.
- `dt`    : A Date or DateTime object specifying which data to read.
- `throw` : If `true`, throw an error when no data is found. If `false`, log a warning and return `nothing`. Defaults to `true`.

Returns
=======
- An NCDataset object containing the data. If multiple files match the datetime, they are automatically aggregated along the time dimension.
- Returns `nothing` if no data is found and `throw=false`.
"""
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

function read(
    ads :: ARMDataset,
    var :: AbstractString,
    dt  :: TimeType;
    throw :: Bool = true
)

    fol = joinpath(ads.path,Dates.format(dt,dateformat"yyyy/mm"))
    fncvec = glob("$(dt2fstr(dt))*-$(var).nc",fol)

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