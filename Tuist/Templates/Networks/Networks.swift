import ProjectDescription

let networkPath = "Projects/Modules/Networks"

let template = Template(
    description: "Networks Template",
    items: [
        .file(
            path: networkPath + "/Project.swift",
            templatePath: "Project.stencil"
        ),
        .file(
            path: networkPath + "/Tests/Sources/NetworkTests.swift",
            templatePath: "Tests.stencil"
        ),
        .file(
            path: networkPath + "/Sources/Empty.swift",
            templatePath: .relativeToRoot("Tuist/Templates/Empty.stencil")
        ),
    ]
)
