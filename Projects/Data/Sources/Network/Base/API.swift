//
//  API.swift
//  Data
//
//  Created by 유지호 on 6/27/24.
//  Copyright © 2024 jiho. All rights reserved.
//

import Foundation
import Alamofire

class API {
    
    static let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        let apiLogger = LottyAPIEventLogger()
        return Session(configuration: configuration, eventMonitors: [apiLogger])
    }()
    
}
