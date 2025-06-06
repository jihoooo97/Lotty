import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createModule(
    name: "MapFeature",
    targets: [.staticFramework, .unitTest, .demo],
    internalDependencies: [
        .Features.base.project
    ],
)
