# **<div align="center">ARMLive.jl</div>**

<p align="center">
  <a href="https://www.repostatus.org/#active">
    <img alt="Repo Status" src="https://www.repostatus.org/badges/latest/active.svg?style=flat-square" />
  </a>
  <a href="https://github.com/natgeo-wong/ARMLive.jl/actions/workflows/CI.yml">
    <img alt="GitHub Actions" src="https://github.com/natgeo-wong/ARMLive.jl/actions/workflows/CI.yml/badge.svg?branch=main&style=flat-square">
  </a>
  <br>
  <a href="https://mit-license.org">
    <img alt="MIT License" src="https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square">
  </a>
  <img alt="Release Version" src="https://img.shields.io/github/v/release/natgeo-wong/ARMLive.jl.svg?style=flat-square">
  <a href="https://natgeo-wong.github.io/ARMLive.jl/stable/">
    <img alt="Stable Documentation" src="https://img.shields.io/badge/docs-stable-blue.svg?style=flat-square">
  </a>
  <a href="https://natgeo-wong.github.io/ARMLive.jl/dev/">
    <img alt="Latest Documentation" src="https://img.shields.io/badge/docs-latest-blue.svg?style=flat-square">
  </a>
</p>

**Created By:** Nathanael Wong (nathanaelwong@fas.harvard.edu)

## **Introduction**

`ARMLive.jl` is a Julia package that aims to streamline the following processes:
* Querying and downloading data from the [ARM Live Data Webservice](https://adc.arm.gov/armlive/)
* Organizing downloaded ARM data into a structured directory format
* Reading ARM NetCDF data files using NCDatasets.jl

## **Installation**

The latest version of ARMLive can be installed using the Julia package manager (accessed by pressing `]` in the Julia command prompt)
```julia
julia> ]
(@v1.12) pkg> add ARMLive
```

You can update `ARMLive.jl` to the latest version using
```julia
(@v1.12) pkg> update ARMLive
```

And if you want to get the latest release without waiting for me to update the Julia Registry, you may fix the version to the `main` branch of the GitHub repository:
```julia
(@v1.12) pkg> add ARMLive#main
```

## **Required Setup**

In order to use this package, you need to:
* Register for an account at the [ARM Data Discovery](https://adc.arm.gov/) portal
* Obtain your access token from the [ARM Live Data Webservice](https://adc.arm.gov/armlive/)
* Run the `setup()` function to store your credentials:

```julia
using ARMLive
setup(user="your_username", token="your_token")
```

This creates a `.armliverc` file in your home directory containing your credentials.

## **Usage**

Please refer to the [documentation](https://natgeo-wong.github.io/ARMLive.jl/dev/) for instructions and examples.

```julia
using ARMLive

# Create a dataset specification
ads = ARMDataset(
    stream = "sgpmetE13.b1",
    start  = Date(2020,1,1),
    stop   = Date(2020,1,31)
)

# Query available files
files = query(ads)

# Download the data
download(ads)

# Read data for a specific date
ds = read(ads, Date(2020,1,15))
```

## **Supported Datasets**

ARMLive.jl supports downloading any datastream available through the ARM Live Data Webservice. Common datastreams include:
* Surface meteorology (e.g., `sgpmetE13.b1`)
* Radiosonde data (e.g., `sgpsondewnpnC1.b1`)
* Radiation measurements (e.g., `sgpradflux1longC1.c1`)

See the [ARM Data Discovery](https://adc.arm.gov/) portal for a full list of available datastreams.

## **Getting Help**

If you are interested in using `ARMLive.jl` or are trying to figure out how to use it, please feel free to ask me questions and get in touch! Please feel free to [open an issue](https://github.com/natgeo-wong/ARMLive.jl/issues/new) if you have any questions, comments, suggestions, etc!
