//
//  Project.swift
//  AppManifests
//
//  Created by jiho9 on 4/17/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createModule(
    name: "Feature",
    targets: [.staticFramework, .unitTest],
    internalDependencies: [
        .Modules.domain.project,
        .Modules.uiComponent.project
    ],
)
