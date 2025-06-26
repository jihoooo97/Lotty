import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createModule(
    name: "Core",
    targets: [.dynamicFramework, .unitTest],
    internalDependencies: [],
    externalDependencies: [
        .external(name: "RxCocoa"),
        .external(name: "RxSwift"),
        .external(name: "SnapKit"),
        .external(name: "Moya"),
        .external(name: "NMapsMap"),
        .external(name: "GoogleMobileAds")
    ]
)
