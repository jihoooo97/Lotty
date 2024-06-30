import ProjectDescription

let dataPath = "Projects/Data"

let template = Template(
    description: "Data Template",
    attributes: [],
    items: [
        .file(
            path: dataPath + "/Project.swift",
            templatePath: "Project.stencil"
        ),
        .file(
            path: dataPath + "/Sources/RepositoryImpl/RepositoryImpl.swift",
            templatePath: "RepositoryImpl.stencil"
        ),
        .file(
            path: dataPath + "/Tests/DataTests.swift",
            templatePath: "DataTests.stencil"
        )
    ]
)
