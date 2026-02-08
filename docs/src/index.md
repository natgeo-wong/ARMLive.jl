```@raw html
---
layout: home

hero:
  name: "ARMLive.jl"
  text: "Accessing ARM Data using Julia"
  tagline: Query, download, and read data from ARMLive.
  image:
    src: /logo.png
    alt: ARMLive Logo
  actions:
    - theme: brand
      text: API
      link: /api
    - theme: alt
      text: View on Github
      link: https://github.com/natgeo-wong/ARMLive.jl

features:
  - title: Query ARM Data
    details: Search for available files in any ARM datastream within a specified date range.
  - title: Automated Downloads
    details: Download ARM data files with progress tracking and organized directory structure.
  - title: NCDatasets Integration
    details: Read downloaded ARM NetCDF files directly using NCDatasets.jl.
---
```

## Introduction

ARMLive.jl is a lightweight Julia package that provides programmatic access to the [ARM Live Data Webservice](https://adc.arm.gov/armlive/). It allows you to query, download, and read data from the Atmospheric Radiation Measurement (ARM) program.

## Installation Instructions

The latest version of ARMLive can be installed using the Julia package manager (accessed by pressing `]` in the Julia command prompt)
```julia-repl
julia> ]
(@v1.12) pkg> add ARMLive
```

You can update `ARMLive.jl` to the latest version using
```julia-repl
(@v1.12) pkg> update ARMLive
```

And if you want to get the latest release without waiting for me to update the Julia Registry (although this generally isn't necessary since I make a point to release patch versions as soon as I find bugs or add new working features), you may fix the version to the `main` branch of the GitHub repository:
```julia-repl
(@v1.12) pkg> add ARMLive#main
```

## Required Setup

Before using ARMLive.jl, you need to:
1. Register for an account at the [ARM Data Discovery](https://adc.arm.gov/) portal
2. Obtain your access token from the [ARM Live Data Webservice](https://adc.arm.gov/armlive/)
3. Run the `setup()` function to store your credentials:

```julia
using ARMLive
setup(user="your_username", token="your_token")
```

## Quick Example

```julia
using ARMLive

# Create a dataset type
ads = ARMDataset(
    stream = "sgpmetE13.b1",
    start  = Date(2020,1,1),
    stop   = Date(2020,1,31),
    path   = <path-to-data-directory>
)

# Query available files
files = query(ads)

# Download the data
download(ads)

# Read data for a specific date
ds = read(ads, Date(2020,1,15))
```

## Getting help
If you are interested in using `ARMLive.jl` or are trying to figure out how to use it, please feel free to ask me questions and get in touch! Please feel free to [open an issue](https://github.com/natgeo-wong/ARMLive.jl/issues/new) if you have any questions, comments, suggestions, etc!
