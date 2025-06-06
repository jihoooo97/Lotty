import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createModule(
    name: "RandomFeature",
    targets: [.staticFramework, .unitTest, .demo],
    internalDependencies: [
        .Features.base.project
    ],
)
