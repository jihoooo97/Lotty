import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Lotty",
    product: .app,
    infoPlist: .extendingDefault(
        with: [
            "UIApplicationSceneManifest": [
                "UIApplicationSupportsMultipleScenes": false,
                "UISceneConfigurations": [
                    "UIWindowSceneSessionRoleApplication": [
                        "Item 0 (Default Configuration)": [
                            "UISceneConfigurationName": "Default Configuration",
                            "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                        ]
                    ]
                ]
            ],
            "UILaunchScreen": [
                "UIColorName": "",
                "UIImageName": "",
            ],
        ]
    ),
    resources: ["Resources/**"],
    dependencies: [
        .project(
            target: "Data",
            path: .relativeToRoot("Projects/Data")
        ),
        .project(
            target: "Domain",
            path: .relativeToRoot("Projects/Domain")
        ),
        .project(
            target: "Presentation",
            path: .relativeToRoot("Projects/Presentation")
        ),
        .external(name: "Swinject"),
        .external(name: "RealmSwift")
    ]
)
