import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Data",
    product: .staticFramework,
    dependencies: [
        .project(
            target: "Domain",
            path: .relativeToRoot("Projects/Domain")
        ),
        .external(name: "Moya"),
        .external(name: "RealmSwift")
    ]
)
