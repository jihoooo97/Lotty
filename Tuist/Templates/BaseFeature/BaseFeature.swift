import ProjectDescription

let baseFeaturePath = "Projects/Features/BaseFeature"

let template = Template(
    description: "BaseFeature Template",
    items: [
        .file(
            path: baseFeaturePath + "/Project.swift",
            templatePath: "BaseProject.stencil"
        ),
        .file(
            path: baseFeaturePath + "/Sources/BaseViewController.swift",
            templatePath: "BaseViewController.stencil"
        ),
        .file(
            path: baseFeaturePath + "/Sources/Empty.swift",
            templatePath: .relativeToRoot("Tuist/Templates/Empty.stencil")
        ),
    ]
)
