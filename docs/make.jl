using ARMLive
using Documenter

DocMeta.setdocmeta!(ARMLive, :DocTestSetup, :(using ARMLive); recursive=true)

makedocs(;
    modules=[ARMLive],
    authors="Nathanael Wong <natgeo.wong@outlook.com>",
    sitename="ARMLive.jl",
    format=Documenter.HTML(;
        canonical="https://natgeo-wong.github.io/ARMLive.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/natgeo-wong/ARMLive.jl",
    devbranch="main",
)
