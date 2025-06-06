import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createModule(
    name: "BaseFeature",
    targets: [.dynamicFramework],
    internalDependencies: [
        .Modules.core.project,
        .Modules.domain.project,
        .Modules.uiComponent.project
    ],
)
