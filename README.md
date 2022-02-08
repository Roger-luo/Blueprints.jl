# Blueprints

Abstractions for template/static file rendering.

This package is inspired by the plugin system in [PkgTemplates](https://github.com/invenia/PkgTemplates.jl),
and I realize this system is not only useful for creating packages,
but can also be used for general project setup and rendering such
as static sites, example project generation etc.

This package tweaks the idea in [PkgTemplates](https://github.com/invenia/PkgTemplates.jl) with a few other tools
I wrote based on the originally PR under [PkgTemplates/#254](https://github.com/invenia/PkgTemplates.jl/pull/254):

- composable: means one blueprints can be component of the other
- serializable: support interface defined by `Configurations`, means you can serialize them to a config file like TOML/JSON/etc.
- extensible: blueprint object does not subtype from a supertype, they only need to define at least the `compile` method, and is checked via traits.

This package only defines a few common components among static files, and by default supports
`git` and `project_file`. For more other components for package creation see [Ion](https://github.com/Roger-luo/Ion.jl). For static site generator, see *not yet public*.

# License

MIT License
