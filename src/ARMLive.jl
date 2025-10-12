module ARMLive

## Base Modules Used
using DelimitedFiles
using Logging
using Printf
using Statistics

import Base: show, read, download

## Modules Used
using JSON3
using PrettyTables

## Reexporting exported functions within these modules
using Reexport
@reexport using Dates
@reexport using NCDatasets

## Exporting the following functions:
export
        ARMDataset, ARMRaw, ARMProcessed,
        
        setup, query, download, read

## ARMLive.jl setup and logging preface

modulelog() = "$(now()) - ARMLive.jl"
eradir = joinpath(@__DIR__,".files")
armpath(path) = splitpath(path)[end] !== "ARM" ? joinpath(path,"ARM") : path

function __init__()

    frc = joinpath(homedir(),".armliverc")
    if !isfile(frc)
        @warn "$(modulelog()) - No .armliverc file exists in the homedir(), please use the setup() function to create this file so downloads can be easily automated ..."
    end

end

## Including Relevant Files

include("dataset.jl")
include("download.jl")
include("armliverc.jl")

end
