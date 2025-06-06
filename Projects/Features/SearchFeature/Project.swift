import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createModule(
    name: "SearchFeature",
    targets: [.staticFramework, .unitTest, .demo],
    internalDependencies: [
        .Features.base.project
    ],
)
