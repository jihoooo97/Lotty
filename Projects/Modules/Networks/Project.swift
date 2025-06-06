import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createModule(
    name: "Networks",
    targets: [.staticFramework, .unitTest],
    internalDependencies: [
        .Modules.core.project,
        .Modules.domain.project
    ],
)
