"""
    setup(;
        user  :: String,
        token :: String,
        path  :: AbstractString = homedir(),
        overwrite :: Bool = false
    ) -> nothing

Create an ARM credentials configuration file (.armliverc) in the specified directory.

Keyword Arguments
=================
- `user`  : The ARM user identifier for authentication.
- `token` : The ARM authentication token.
- `path`  : The directory where the .armliverc file will be saved. Defaults to the user's home directory `homedir()`.
- `overwrite` : If `true`, overwrite an existing .armliverc file. If `false`, skip creation if the file already exists. Defaults to `false`.
"""
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

    @info "$(modulelog()) - Retrieving ARM credentials from $(armliverc) ..."
    open(armliverc) do f
        for line in readlines(f)
            key,val = strip.(split(line,':',limit=2))
            akeys[key] = val
        end
    end

    return akeys

end