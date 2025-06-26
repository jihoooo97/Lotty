import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createModule(
    name: "RootFeature",
    targets: [.staticFramework],
    internalDependencies: [
        .Features.map.project,
        .Features.search.project,
        .Features.random.project
    ],
)
