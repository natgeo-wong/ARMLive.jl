function setup(;
    user  :: String,
    token :: String,
    path  :: AbstractString = homedir(),
    overwrite :: Bool = false
)

    fID = joinpath(path,".armliverc")
    if !isfile(fID) || overwrite

        @info "$(modulelog()) - Adding user token to $fID ..."
        open(fID,"w") do f

            write(f,"user: $user\ntoken: $token")

        end

    else

        @info "$(modulelog()) - Existing .armliverc file detected at $fID, since overwrite options is not selected, no changes will be made"

    end

end

function armtoken(path :: AbstractString = homedir())

    akeys = Dict(); armliverc = joinpath(path,".armliverc")

    @info "$(modulelog()) - Loading CDSAPI credentials from $(armliverc) ..."
    open(armliverc) do f
        for line in readlines(f)
            key,val = strip.(split(line,':',limit=2))
            akeys[key] = val
        end
    end

    return akeys

end