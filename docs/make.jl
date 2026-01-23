using Documenter
using DocumenterVitepress
using ARMLive

DocMeta.setdocmeta!(ARMLive, :DocTestSetup, :(using ARMLive); recursive=true)

makedocs(;
    modules  = [ARMLive],
    authors  = "Nathanael Wong <natgeo.wong@outlook.com>",
    sitename = "ARMLive.jl",
    doctest  = false,
    warnonly = true,
    format   = DocumenterVitepress.MarkdownVitepress(
        repo = "https://github.com/natgeo-wong/ARMLive.jl",
    ),
    pages    = [
        "Home"     => "index.md",
        "API List" => "api.md",
    ],
)

DocumenterVitepress.deploydocs(;
    repo      = "github.com/natgeo-wong/ARMLive.jl.git",
    target    = "build",
    devbranch = "main",
    branch    = "gh-pages",
)
