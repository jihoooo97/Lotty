import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createModule(
    name: "QRFeature",
    targets: [.staticFramework, .unitTest, .demo],
    internalDependencies: [
        .Features.base.project
    ],
)
