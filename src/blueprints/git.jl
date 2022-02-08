@option "github" struct GitHubRepo
    type::Reflect
    user::String # user may not be the same as user.name
    repo::Maybe{String} # if nothing use pkg name
end

# @option "gitlab" struct GitLabRepo
#     type::Reflect
#     user::String
#     repo::String
# end

@option struct Git
    name::Maybe{String}
    email::Maybe{String}
    branch::Maybe{String}
    ssh::Bool = false
    jl::Bool = true
    manifest::Bool = false
    gpgsign::Bool = false
    repo::Maybe{GitHubRepo}
end

# setup git repo
function preprocess(bp::Git, ctx::Context)
end

# create .gitignore
function compile(bp::Git, ctx::Context)
    ignore_list = get(ctx.state, :gitignore, String[])
end

# commit changes
function postprocess(bp::Git, ctx::Context)
end
