import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createModule(
    name: "UIComponent",
    targets: [.dynamicFramework],
    internalDependencies: [
        .Modules.core.project
    ],
    hasResources: true
)
