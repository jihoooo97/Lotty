import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Domain",
    product: .staticFramework,
    dependencies: [
        .external(name: "RxSwift")
    ]
)
