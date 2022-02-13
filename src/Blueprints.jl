module Blueprints

using Pkg
using TOML
using Dates
using UUIDs
using LibGit2
using Mustache
using GarishPrint
using Configurations

export Blueprint

include("types.jl")

include("blueprints/git.jl")
include("blueprints/project_file.jl")

end
