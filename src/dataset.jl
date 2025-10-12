abstract type ARMDataset end

"""
    ARMProcessed <: ARMDataset

Specifies that the dataset to be analyzed contains hourly data.  All fields are the same as that specified in the `ERA5Dataset` docstring.
"""
struct ARMProcessed{ST<:AbstractString, DT<:TimeType} <: ARMDataset
    stream :: ST
    start  :: DT
    stop   :: DT
    path   :: ST
end

"""
    ARMRaw <: ARMDataset

Specifies that the dataset to be analyzed contains hourly data.  All fields are the same as that specified in the `ERA5Dataset` docstring.
"""
struct ARMRaw{ST<:AbstractString, DT<:TimeType} <: ARMDataset
    stream :: ST
    start  :: DT
    stop   :: DT
    path   :: ST
end

function ARMDataset(;
    stream :: ST,
    start  :: DT,
    stop   :: DT,
    path   :: ST = armpath(homedir()),
    raw    :: Bool = true
) where {ST <: AbstractString, DT<:TimeType}

    path = armpath(path)

    if raw
        return ARMRaw{ST,DT}(stream, start, stop, path)
    else
        return ARMProcessed{ST,DT}(stream, start, stop, path)
    end

end

# function datastream(ads :: ARMProcessed)

#     return ads.facility * ads.timestep * ads.instrument * ads.qualifier * ads.station *
#            "." * ads.leveltype

# end

# function datastream(ads :: ARMLive)
    
#     return ads.facility * ads.instrument * ads.station *
#            "." * ads.leveltype

# end

function show(
    io  :: IO,
    ads :: ARMDataset
)

    print(io,
		"The ARM Dataset has the following properties:\n",
		"    Datastream       (stream) : ", ads.IDstream, '\n',
		"    Data Directory     (path) : ", ads.path, '\n',
		"    Date Begin        (start) : ", ads.start, '\n',
		"    Date End           (stop) : ", ads.stop , '\n',
	)
    
end