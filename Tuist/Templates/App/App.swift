import ProjectDescription

let appPath = "Projects/App"

let template = Template(
    description: "App Template",
    items: [
        .file(
            path: appPath + "/Project.swift",
            templatePath: "Project.stencil"
        ),
        .file(
            path: appPath + "/Sources/AppDelegate.swift",
            templatePath: "AppDelegate.stencil"
        ),
        .file(
            path: appPath + "/Sources/SceneDelegate.swift",
            templatePath: "SceneDelegate.stencil"
        ),
        .directory(
            path: appPath + "/Resources",
            sourcePath: "Assets.xcassets"
        ),
    ]
)
