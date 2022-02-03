module Blueprints

using Pkg
using TOML
using Dates
using UUIDs
using Mustache
using GarishPrint
using Configurations

export Blueprint

include("types.jl")

include("blueprints/git.jl")
include("blueprints/project_file.jl")
include("blueprints/src_dir.jl")
include("blueprints/tests.jl")
include("blueprints/readme.jl")
include("blueprints/license.jl")
include("blueprints/documenter.jl")

end
