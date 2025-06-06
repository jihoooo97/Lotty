//
//  Domain.swift
//  BaseFeatureManifests
//
//  Created by 유지호 on 6/5/25.
//

import ProjectDescription

let domainPath = "Projects/Modules/Domain"

let template = Template(
    description: "Domain Template",
    items: [
        .file(
            path: domainPath + "/Project.swift",
            templatePath: "Project.stencil"
        ),
        .file(
            path: domainPath + "/Tests/Sources/DomainTests.swift",
            templatePath: "Tests.stencil"
        ),
        .file(
            path: domainPath + "/Sources/Empty.swift",
            templatePath: .relativeToRoot("Tuist/Templates/Empty.stencil")
        ),
    ]
)
