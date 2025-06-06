//
//  Project+Schemes.swift
//  ProjectDescriptionHelpers
//
//  Created by 유지호 on 6/5/25.
//

import ProjectDescription

public extension Scheme {
    
    static func makeScheme(configs: ConfigurationName, name: String) -> Scheme {
        return .scheme(
            name: name,
            shared: true,
            buildAction: .buildAction(targets: ["\(name)"]),
            testAction: .targets(
                ["\(name)Tests"],
                configuration: configs,
                options: .options(coverage: true, codeCoverageTargets: ["\(name)"])
            ),
            runAction: .runAction(configuration: configs),
            archiveAction: .archiveAction(configuration: configs),
            profileAction: .profileAction(configuration: configs),
            analyzeAction: .analyzeAction(configuration: configs)
        )
    }
    
    static func makeDemoScheme(configs: ConfigurationName, name: String) -> Scheme {
        return .scheme(
            name: "\(name)Demo",
            shared: true,
            buildAction: .buildAction(targets: ["\(name)Demo"]),
            testAction: .targets(
                ["\(name)Tests"],
                configuration: configs,
                options: .options(coverage: true, codeCoverageTargets: ["\(name)Demo"])
            ),
            runAction: .runAction(configuration: configs),
            archiveAction: .archiveAction(configuration: configs),
            profileAction: .profileAction(configuration: configs),
            analyzeAction: .analyzeAction(configuration: configs))
    }
    
    static func makeDemoAppTestScheme() -> Scheme {
        let targetName = "\(Project.workspaceName)-Demo"
        return .scheme(
            name: "\(targetName)-Test",
            shared: true,
            buildAction: .buildAction(targets: ["\(targetName)"]),
            testAction: .targets(
                ["\(targetName)Tests"],
                configuration: "Test",
                options: .options(coverage: true, codeCoverageTargets: ["\(targetName)"])
            ),
            runAction: .runAction(configuration: "Test"),
            archiveAction: .archiveAction(configuration: "Test"),
            profileAction: .profileAction(configuration: "Test"),
            analyzeAction: .analyzeAction(configuration: "Test")
        )
    }
    
}


public extension Project {
    
    static let appSchemes: [Scheme] = [
        // PROD API, debug scheme
        .scheme(
            name: "\(Self.workspaceName)-DEVELOP",
            shared: true,
            buildAction: .buildAction(targets: ["\(Self.workspaceName)"]),
            testAction: .targets(
                ["\(Self.workspaceName)Tests"],
                configuration: "Development",
                options: .options(coverage: true, codeCoverageTargets: ["\(Self.workspaceName)"])
            ),
            runAction: .runAction(configuration: "Development"),
            archiveAction: .archiveAction(configuration: "Development"),
            profileAction: .profileAction(configuration: "Development"),
            analyzeAction: .analyzeAction(configuration: "Development")
        ),
        // Test API, debug scheme
        .scheme(
            name: "\(Self.workspaceName)-Test",
            shared: true,
            buildAction: .buildAction(targets: ["\(Self.workspaceName)"]),
            testAction: .targets(
                ["\(Self.workspaceName)Tests"],
                configuration: "Test",
                options: .options(coverage: true, codeCoverageTargets: ["\(Self.workspaceName)"])
            ),
            runAction: .runAction(configuration: "Test"),
            archiveAction: .archiveAction(configuration: "Test"),
            profileAction: .profileAction(configuration: "Test"),
            analyzeAction: .analyzeAction(configuration: "Test")
        ),
        // PROD API, release scheme
        .scheme(
            name: "\(Self.workspaceName)-RELEASE",
            shared: true,
            buildAction: .buildAction(targets: ["\(Self.workspaceName)"]),
            runAction: .runAction(configuration: "RELEASE"),
            archiveAction: .archiveAction(configuration: "RELEASE"),
            profileAction: .profileAction(configuration: "RELEASE"),
            analyzeAction: .analyzeAction(configuration: "RELEASE")
        ),
        // Test API, debug scheme, Demo App Target
        .makeDemoAppTestScheme()
    ]
    
}
