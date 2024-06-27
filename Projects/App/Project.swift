import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Lotty",
    product: .app,
    infoPlist: .extendingDefault(
        with: [
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
        .external(name: "Swinject")
    ]
)
