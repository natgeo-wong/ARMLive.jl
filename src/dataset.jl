"""
    ARMDataset{ST<:AbstractString, DT<:TimeType}

Specifies an ARM (Atmospheric Radiation Measurement) dataset with the following fields:
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

Keyword Arguments
=================
* `stream` - The ARM datastream name (e.g., `"sgpmetE13.b1"`).
* `start` - The start date for the data query.
* `stop` - The end date for the data query.
* `path` - The root directory for storing data, default is `homedir()`.

Returns
=======
* An `ARMRaw` or `ARMProcessed` dataset specification.
"""
function ARMDataset(;
    stream :: ST,
    start  :: DT,
    stop   :: DT,
    path   :: ST = armpath(homedir())
) where {ST <: AbstractString, DT<:TimeType}

    path = joinpath(armpath(path),stream)
    if !isdir(path); mkpath(path) end

    return ARMDataset{ST,DT}(stream, start, stop, path)

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