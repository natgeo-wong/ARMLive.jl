"""
    ARMDataset{ST<:AbstractString, DT<:TimeType}

Specifies an ARM (Atmospheric Radiation Measurement) dataset for querying, downloading, and reading data from the ARM Live Data Webservice.

## Type Parameters
* `ST` - String type for the datastream name and path.
* `DT` - TimeType for the start and stop dates.

## Fields
* `stream` - The ARM datastream name (e.g., `"sgpmetE13.b1"`).
* `start` - The start date for the data query.
* `stop` - The end date for the data query.
* `path` - The local directory path where data will be stored.
"""
struct ARMDataset{ST<:AbstractString, DT<:TimeType}
    stream :: ST
    start  :: DT
    stop   :: DT
    path   :: ST
end

"""
    ARMDataset(; stream, start, stop, path=armpath(homedir()), raw=true)

Create an `ARMDataset` specification for querying and downloading ARM data.

## Keyword Arguments
* `stream` - The ARM datastream name (e.g., `"sgpmetE13.b1"`).
* `start` - The start date for the data query (any `TimeType`).
* `stop` - The end date for the data query (any `TimeType`).
* `path` - The root directory for storing data (default: `~/ARM`).
* `raw` - If `true`, returns `ARMRaw`; if `false`, returns `ARMProcessed` (default: `true`).

## Returns
* An `ARMRaw` or `ARMProcessed` dataset specification.

## Example
```julia
ads = ARMDataset(
    stream = "sgpmetE13.b1",
    start  = Date(2020,1,1),
    stop   = Date(2020,1,31)
)
```
"""
function ARMDataset(;
    stream :: ST,
    start  :: DT,
    stop   :: DT,
    path   :: ST = armpath(homedir()),
    raw    :: Bool = true
) where {ST <: AbstractString, DT<:TimeType}

    path = joinpath(armpath(path),stream)
    if !isdir(path); mkpath(path) end

    if raw
        return ARMRaw{ST,DT}(stream, start, stop, path)
    else
        return ARMProcessed{ST,DT}(stream, start, stop, path)
    end

end

function show(
    io  :: IO,
    ads :: ARMDataset
)

    print(io,
		"The ARM Dataset has the following properties:\n",
		"    Datastream       (stream) : ", ads.stream, '\n',
		"    Data Directory     (path) : ", ads.path, '\n',
		"    Date Begin        (start) : ", ads.start, '\n',
		"    Date End           (stop) : ", ads.stop , '\n',
	)

end