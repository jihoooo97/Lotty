//
//  Project.swift
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createModule(
    name: Project.workspaceName,
    targets: [.app],
    internalDependencies: [
        .Modules.networks.project,
        .Features.root.project
    ],
)
