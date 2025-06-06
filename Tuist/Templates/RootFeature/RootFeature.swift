import ProjectDescription

let rootFeaturePath = "Projects/Features/RootFeature"

let template = Template(
    description: "RootFeature Template",
    items: [
        .file(
            path: rootFeaturePath + "/Project.swift",
            templatePath: "RootProject.stencil"
        ),
        .file(
            path: rootFeaturePath + "/Sources/Empty.swift",
            templatePath: .relativeToRoot("Tuist/Templates/Empty.stencil")
        ),
    ]
)
