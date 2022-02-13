using Test
using Blueprints

bp = Blueprint(
    name="test",
    blueprints=[
        Blueprints.JuliaProject(),
        Blueprints.GitRepo(;name="ABC", email="email@abc.com"),
        Blueprints.GitIgnoreFile(patterns=["Manifest.toml"]),
        Blueprints.GitCommitFiles(msg="Test File Generated"),
        # Blueprints.SrcDir(),
        # Blueprints.ProjectTest(),
        # Blueprints.License(),
    ]
)

Blueprints.compile(bp;
    name="TestPackage", path=pkgdir(Blueprints, "test", "TestPackage"), force=true,
    authors=["rogerluo"],
)

test_files(xs...) = pkgdir(Blueprints, "test", "TestPackage", xs...)

@testset "check generated files" begin
    @test isfile(test_files(".gitignore"))
    @test isfile(test_files("Project.toml"))
    @test isdir(test_files(".git"))
end