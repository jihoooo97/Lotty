import ProjectDescription

public extension Project {
    
    static func makeModule(
        name: String,
        destinations: Destinations = [.iPhone],
        product: Product,
        organizationName: String = "jiho",
        deploymentTarget: DeploymentTargets? = .iOS("15.0"),
        infoPlist: InfoPlist = .default,
        sources: SourceFilesList = ["Sources/**"],
        resources: ResourceFileElements? = nil,
        dependencies: [TargetDependency] = [],
        packages: [Package] = []
    ) -> Project {
        let settings: Settings = .settings(
            base: [:],
            configurations: [
                .debug(name: .debug),
                .release(name: .release)
            ],
            defaultSettings: .recommended
        )
        
        let appTarget: Target = .target(
            name: name,
            destinations: destinations,
            product: product,
            bundleId: "com.\(organizationName).\(name)",
            deploymentTargets: deploymentTarget,
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
            dependencies: dependencies
        )

        let testTarget: Target = .target(
            name: "\(name)Tests",
            destinations: destinations,
            product: .unitTests,
            bundleId: "com.\(organizationName).\(name)Tests",
            deploymentTargets: deploymentTarget,
            infoPlist: nil,
            sources: ["Tests/**"],
            dependencies: []
        )
        
        let schemes: [Scheme] = [.makeScheme(name: name, target: .debug)]
        let targets: [Target] = [appTarget]
        
        return Project(
            name: name,
            organizationName: organizationName,
            packages: packages,
            settings: settings,
            targets: targets,
            schemes: schemes,
            resourceSynthesizers: []
        )
    }
    
}


extension Scheme {
    
    static func makeScheme(
        name: String,
        target: ConfigurationName
    ) -> Scheme {
        return .scheme(
            name: name,
            shared: true,
            buildAction: .buildAction(targets: ["\(name)"]),
            testAction: .targets(
                ["\(name)Tests"],
                configuration: target,
                options: .options(coverage: true, codeCoverageTargets: ["\(name)"])
            ),
            runAction: .runAction(configuration: target),
            archiveAction: .archiveAction(configuration: target),
            profileAction: .profileAction(configuration: target),
            analyzeAction: .analyzeAction(configuration: target)
        )
    }
    
}
