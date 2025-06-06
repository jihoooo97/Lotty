//
//  Project+Dependency.swift
//  ProjectDescriptionHelpers
//
//  Created by 유지호 on 5/16/25.
//

import ProjectDescription

public extension TargetDependency {
    
    enum Modules {
        case core
        case domain
        case networks
        case uiComponent
        
        public var group: String {
            switch self {
            case .core: "Core"
            case .domain: "Domain"
            case .networks: "Networks"
            case .uiComponent: "UIComponent"
            }
        }
        
        public var project: TargetDependency {
            .project(target: self.group, path: .relativeToRoot("Projects/Modules/\(group)"))
        }
    }
    
    enum Features {
        case base
        case root
        
        case map
        case search
        case qr
        case random
        
        public var group: String {
            switch self {
            case .base: "BaseFeature"
            case .root: "RootFeature"
                
            case .map: "MapFeature"
            case .search: "SearchFeature"
            case .qr: "QRFeature"
            case .random: "RandomFeature"
            }
        }
        
        public var project: TargetDependency {
            .project(target: self.group, path: .relativeToRoot("Projects/Features/\(group)"))
        }
    }

}
