//
//  TargetModule.swift
//  ProjectDescriptionHelpers
//
//  Created by 유지호 on 5/15/25.
//

import Foundation
import ProjectDescription

public enum TargetModule {
    case app
    case dynamicFramework
    case staticFramework
    case unitTest
    case demo
    
    public var hasFramework: Bool {
        switch self {
        case .dynamicFramework, .staticFramework:
            return true
        default:
            return false
        }
    }
    
    public var hasDynamicFramework: Bool {
        self == .dynamicFramework
    }
}
