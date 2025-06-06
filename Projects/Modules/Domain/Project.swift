import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createModule(
    name: "Domain",
    targets: [.dynamicFramework, .unitTest],
    internalDependencies: [
        .Modules.core.project
    ],
)
