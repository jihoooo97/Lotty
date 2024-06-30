import ProjectDescription

let domainPath = "Projects/Domain"

let template = Template(
    description: "Domain Template",
    attributes: [],
    items: [
        .file(
            path: domainPath + "/Project.swift",
            templatePath: "Project.stencil"
        ),
        .file(
            path: domainPath + "/Sources/Repository/Repository.swift",
            templatePath: "Repository.stencil"
        ),
        .file(
            path: domainPath + "/Sources/UseCase/UseCase.swift",
            templatePath: "UseCase.stencil"
        ),
        .file(
            path: domainPath + "/Tests/DomainTests.swift",
            templatePath: "DomainTests.stencil"
        )
    ]
)
