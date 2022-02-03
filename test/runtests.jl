using Blueprints

bp = Blueprint(
    name="test",
    blueprints=[
        Blueprints.JuliaProject(),
        Blueprints.SrcDir(),
        Blueprints.ProjectTest(),
        Blueprints.License(),
    ]
)

Blueprints.compile(bp;
    name="TestPackage", path="test/TestPackage", force=true,
    authors=["rogerluo"],
)