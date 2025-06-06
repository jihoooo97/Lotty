import ProjectDescription

public extension Project {
    
    static func createModule(
        name: String,
        targets: Set<TargetModule> = [.staticFramework, .unitTest, .demo],
        packages: [Package] = [],
        internalDependencies: [TargetDependency] = [], // 모듈 의존성
        externalDependencies: [TargetDependency] = [], // 외부 라이브러리 의존성
        hasResources: Bool = false
    ) -> Project {
        let configurationName: ConfigurationName = "Develop"
        let hasDynamicFramework = targets.contains(.dynamicFramework)
        let baseSettings: SettingsDictionary = .baseSettings.setCodeSignManual()
        
        var projectTargets: [Target] = []
        var schemes: [Scheme] = []
        
        
        
        // MARK: App
        
        if targets.contains(.app) {
            let settings = baseSettings.setProvisioning()
            
            let target = Target.target(
                name: name,
                destinations: .iOS,
                product: .app,
                bundleId: Self.bundlePrefix + "Release",
                deploymentTargets: Self.deploymentTarget,
                infoPlist: .extendingDefault(with: Project.defaultInfoPlist),
                sources: ["Sources/**"],
                resources: [.glob(pattern: "Resources/**")],
//                entitlements: "\(name).entitlements",
                dependencies: [
                    internalDependencies,
                    externalDependencies
                ].flatMap { $0 },
                settings: .settings(base: settings)
            )
            
            projectTargets.append(target)
        }
        
        
        
        // MARK: Framework
        
        if targets.contains(where: { $0.hasFramework }) {
            let settings = baseSettings
            
            let target = Target.target(
                name: name,
                destinations: .iOS,
                product: hasDynamicFramework ? .framework : .staticFramework,
                bundleId: Self.bundlePrefix + name,
                deploymentTargets: Self.deploymentTarget,
                infoPlist: .default,
                sources: ["Sources/**"],
                resources: hasResources ? [.glob(pattern: "Resources/**")] : [],
                dependencies: internalDependencies + externalDependencies,
                settings: .settings(base: settings)
            )
            
            projectTargets.append(target)
        }
        
        
        
        // MARK: DemoApp
        
        if targets.contains(.demo) {
            let deps: [TargetDependency] = [.target(name: name)]
            
            let target = Target.target(
                name: "\(name)Demo",
                destinations: .iOS,
                product: .app,
                bundleId: Self.bundlePrefix + name + "Demo",
                deploymentTargets: Self.deploymentTarget,
                infoPlist: .extendingDefault(with: Project.demoInfoPlist(name)),
                sources: ["Demo/Sources/**"],
                resources: [.glob(pattern: "Demo/Resources/**", excluding: ["Demo/Resources/dummy.txt"])],
                dependencies: deps,
                settings: .settings(base: baseSettings)
            )
            
            projectTargets.append(target)
        }
        
        
        
        // MARK: Tests
        
        if targets.contains(.unitTest) {
            let deps: [TargetDependency] = [.target(name: name)]
            
            let target = Target.target(
                name: "\(name)Tests",
                destinations: .iOS,
                product: .unitTests,
                bundleId: Self.bundlePrefix + name + "Tests",
                deploymentTargets: Self.deploymentTarget,
                infoPlist: .default,
                sources: ["Tests/Sources/**"],
                dependencies: deps,
                settings: .settings(base: SettingsDictionary().setCodeSignManual())
            )
            
            projectTargets.append(target)
        }
        
        
        
        // MARK: Scheme
        
        let additionalSchemes = targets.contains(.demo)
        ? [Scheme.makeScheme(configs: configurationName, name: name),
           Scheme.makeDemoScheme(configs: configurationName, name: name)]
        : [Scheme.makeScheme(configs: configurationName, name: name)]
        schemes += additionalSchemes
        
        var scheme = targets.contains(.app)
        ? appSchemes
        : schemes
        
        return Project(
            name: name,
            organizationName: Self.workspaceName,
            packages: packages,
            settings: .settings(),
            targets: projectTargets
//            schemes: scheme
        )
    }
    
}
