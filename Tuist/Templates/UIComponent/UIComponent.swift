import ProjectDescription

let uiComponentPath = "Projects/Modules/UIComponent"

let template = Template(
    description: "UIComponent Template",
    items: [
        .file(
            path: uiComponentPath + "/Project.swift",
            templatePath: "Project.stencil"
        ),
        .file(
            path: uiComponentPath + "/Sources/Empty.swift",
            templatePath: .relativeToRoot("Tuist/Templates/Empty.stencil")
        ),
        .directory(
            path: uiComponentPath + "/Resources",
            sourcePath: "Assets.xcassets"
        )
    ]
)
