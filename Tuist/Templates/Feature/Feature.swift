import ProjectDescription

let nameAttribute: Template.Attribute = .required("name")

let template = Template(
    description: "Feature Template",
    attributes: [
        nameAttribute
    ],
    items: ModuleTemplate.allCases.flatMap { $0.item }
)


enum ModuleTemplate: CaseIterable {
    case project, sources, derived, tests, demo

    var basePath: String {
        "Projects/Features/\(nameAttribute)Feature"
    }
    
    var path: String {
        switch self {
        case .project:
            basePath
        case .sources:
            basePath + "/Sources"
        case .derived:
            basePath + "/Derived"
        case .tests:
            basePath + "/Tests"
        case .demo:
            basePath + "/Demo"
        }
    }
    
    var item: [Template.Item] {
        switch self {
        case .project:
            [.file(path: path + "/Project.swift", templatePath: "Project.stencil")]
        case .sources:
            [.file(path: path + "/\(nameAttribute)ViewController.swift", templatePath: "ViewController.stencil")]
        case .derived:
            [.file(path: path + "/Sources/Empty.swift", templatePath: .relativeToRoot("Tuist/Templates/Empty.stencil")),
             .file(path: path + "/InfoPlists/Info.plist", templatePath: "Info.plist")]
        case .tests:
            [.file(path: path + "/Sources/\(nameAttribute)Tests.swift", templatePath: "Tests.stencil"),
             .file(path: path + "/Resources/Empty.swift", templatePath: .relativeToRoot("Tuist/Templates/Empty.stencil"))]
        case .demo:
            [.file(
                path: path + "/Sources/AppDelegate.swift",
                templatePath: .relativeToRoot("Tuist/Templates/App/AppDelegate.stencil")
            ),
             .file(
                path: path + "/Sources/SceneDelegate.swift",
                templatePath: .relativeToRoot("Tuist/Templates/App/SceneDelegate.stencil")
             ),
             .directory(path: path + "/Resources/Assets.xcassets", sourcePath: "Assets.xcassets"),
             .file(path: path + "/Sources/Empty.swift", templatePath: .relativeToRoot("Tuist/Templates/Empty.stencil"))]
        }
    }
}
