import ProjectDescription

let corePath = "Projects/Modules/Core"

let template = Template(
    description: "Core Template",
    items: [
        .file(
            path: corePath + "/Project.swift",
            templatePath: "Project.stencil"
        ),
        .file(
            path: corePath + "/Sources/Core.swift",
            templatePath: .relativeToRoot("Tuist/Templates/Empty.stencil")
        ),
        .file(
            path: corePath + "/Tests/Sources/CoreTests.swift",
            templatePath: "Tests.stencil"
        )
    ]
)

