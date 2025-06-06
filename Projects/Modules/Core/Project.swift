import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createModule(
    name: "Core",
    targets: [.dynamicFramework, .unitTest],
    internalDependencies: [],
    externalDependencies: [
        .external(name: "Kingfisher"),
        .external(name: "RxCocoa"),
        .external(name: "RxSwift"),
        .external(name: "SnapKit"),
        .package(product: "NMapsMap")
    ]
)
