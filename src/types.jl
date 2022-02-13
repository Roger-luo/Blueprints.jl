"""
    @option struct Blueprint

The general type `Blueprint` contains a list of other blueprints.

# Fields

- `name::String`: the name of this blueprint
- `config_file::Maybe{String}`: the corresponding config file name of this blueprint.
- `meta:Dict{String, Any}`: meta info from config file or other places.
- `blueprints::Vector{Any}`: list of blueprint objects to compile.
"""
@option struct Blueprint
    name::String # name of this blueprint
    config_file::Maybe{String} # can be nothing if no config file
    meta::Dict{String, Any} = Dict{String, Any}()
    blueprints::Vector{Any} = []

    function Blueprint(
        name::String, config_file::Maybe{String},
        meta::Dict{String, Any}, blueprints::Vector{Any}
    )
        new(name, config_file, meta, sort(blueprints, by=priority))
    end
end

Base.show(io::IO, ::MIME"text/plain", x::Blueprint) = GarishPrint.pprint_struct(io, x)

"""
    priority(blueprint)

Return the priority of `blueprint`. Default is `1000`.
"""
priority(blueprint) = 1000 # defaul priority

"""
    @option struct Context

Type for storing the compile context.
    
# Fields

- `args::Tuple`: the input arguments.
- `kwargs::NamedTuple`: the input keyword arguments.
- `stack::NTuple{N, Blueprint}`: [`Blueprint`](@ref) stack, topmost is the current blueprint under compile.
- `state::Dict{Symbol, Any}`: compile states that each blueprint can pass in.
"""
@option struct Context{N, Args <: Tuple, Kwargs <: NamedTuple}
    # global inputs that is
    # not from config meta
    args::Args = ()
    kwargs::Kwargs = NamedTuple()

    # blueprint stack
    stack::NTuple{N, Blueprint} = ()
    # state
    state::Dict{Symbol, Any} = Dict{Symbol, Any}()
end

function Base.getindex(ctx::Blueprint, name::String)
    haskey(ctx, name) || error("expect $name in $(ctx.config_file)")
    return ctx.meta[name]
end

compile(bp::Blueprint, args...; kwargs...) =
    compile(bp, Context(args, NamedTuple(kwargs), (bp, ), Dict{Symbol, Any}()))

function compile(bp::Blueprint, ctx::Context)
    new_ctx = Context(ctx.args, ctx.kwargs, (bp, ctx.stack...), ctx.state)
    for bp in bp.blueprints
        compile(bp, new_ctx)
    end
    return
end

function has_blueprint(ctx::Context, ::Type{T}) where T
    for bp in ctx.stack, each in bp.blueprints
        each isa T && return true
    end
    return false
end

function get_blueprint(ctx::Context, ::Type{T}) where T
    for bp in ctx.stack, each in bp.blueprints
        each isa T && return each
    end
    return
end

abstract type MustacheBlueprint end
function blueprint_view(::MustacheBlueprint, ctx::Context)
    return Dict{String, Any}()
end

function src_file(bp::MustacheBlueprint, ::Context)
    return joinpath(bp.template.root, bp.template.path, bp.template.file)
end

function dst_file(bp::MustacheBlueprint, ctx::Context)
    return joinpath(ctx.kwargs.path, bp.template.path, bp.template.file)
end

function compile(bp::MustacheBlueprint, ctx::Context)
    file = src_file(bp, ctx)::String
    text = render_from_file(file, blueprint_view(bp, ctx))
    dst = dst_file(bp, ctx)::String
    mkpath(dirname(dst))
    write(dst, text)
    return
end
