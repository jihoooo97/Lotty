import ProjectDescription

let commonPath = "Projects/Common"

let template = Template(
    description: "Common Template",
    attributes: [],
    items: [
        .file(
            path: commonPath + "/Project.swift",
            templatePath: "Project.stencil"
        ),
        .file(
            path: commonPath + "/Sources/Common.swift",
            templatePath: "Common.stencil"
        )
    ]
)

