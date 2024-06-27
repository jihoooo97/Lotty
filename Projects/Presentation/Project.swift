import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Presentation",
    product: .staticFramework,
    dependencies: [
        .project(
            target: "Domain",
            path: .relativeToRoot("Projects/Domain")
        ),
        .project(
            target: "Common",
            path: .relativeToRoot("Projects/Common")
        ),
        .project(
            target: "CommonUI",
            path: .relativeToRoot("Projects/CommonUI")
        )
    ]
)
