@option struct SrcDir <: MustacheBlueprint
    template::String = default_template("src", "module.jl")
end

blueprint_view(::SrcDir, ctx::Context) = Dict(
    "PKG" => ctx.kwargs.name,
)

src_file(bp::SrcDir, ::Context) = bp.template

function dst_file(::SrcDir, ctx::Context)
    joinpath(ctx.kwargs.path, "src", ctx.kwargs.name * ".jl")
end

function write_project_toml(filepath::String, d::Dict{String, Any})
    open(filepath, "w+") do f # following whatever Pkg does
        TOML.print(f, d; sorted=true, by=key -> (Pkg.Types.project_key_order(key), key))
    end
end
