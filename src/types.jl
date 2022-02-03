@option struct Blueprint
    name::String # name of this blueprint
    config_file::Maybe{String} # can be nothing if no config file
    meta::Dict{String, Any} = Dict{String, Any}()
    blueprints::Vector{Any} = []
end

Base.show(io::IO, ::MIME"text/plain", x::Blueprint) = GarishPrint.pprint_struct(io, x)

struct Context{N, Args <: Tuple, Kwargs <: NamedTuple}
    # global inputs that is
    # not from config meta
    args::Args
    kwargs::Kwargs

    # blueprint stack
    stack::NTuple{N, Blueprint}
end

Context(stack::NTuple{N, Blueprint}) where N = Context((), NamedTuple(), stack)

function Base.getindex(ctx::Blueprint, name::String)
    haskey(ctx, name) || error("expect $name in $(ctx.config_file)")
    return ctx.meta[name]
end

compile(bp::Blueprint, args...; kwargs...) = compile(bp, Context(args, NamedTuple(kwargs), (bp, )))

function compile(bp::Blueprint, ctx::Context)
    new_ctx = Context(ctx.args, ctx.kwargs, (bp, ctx.stack...))
    for bp in bp.blueprints
        compile(bp, new_ctx)
    end
    return
end

default_template(paths::String...) = pkgdir(Blueprints, "templates", paths...)


abstract type MustacheBlueprint end
function blueprint_view(::MustacheBlueprint, ctx::Context)
    return Dict{String, Any}()
end

src_file(bp::MustacheBlueprint, ::Context) = error("expect src_file defined for $(typeof(bp))")
dst_file(bp::MustacheBlueprint, ::Context) = error("expect dst_file defined for $(typeof(bp))")

function compile(bp::MustacheBlueprint, ctx::Context)
    file = src_file(bp, ctx)
    text = render_from_file(file, blueprint_view(bp, ctx))
    dst = dst_file(bp, ctx)
    mkpath(dirname(dst))
    write(dst, text)
    return
end
