import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "CommonUI",
    product: .staticFramework,
    dependencies: [
        .project(
            target: "Domain",
            path: .relativeToRoot("Projects/Domain")
        ),
        .external(name: "RxCocoa"),
        .external(name: "SnapKit"),
        .external(name: "Kingfisher"),
        .external(name: "Swinject")
    ]
)

