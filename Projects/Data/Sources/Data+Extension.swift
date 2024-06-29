//
//  Data+Extension.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/20.
//

import Foundation

public extension Data {
    
    var prettyPrintedJSONString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(
                withJSONObject: object,
                options: [.prettyPrinted]
              ),
              let prettyPrintedString = NSString(
                data: data,
                encoding: String.Encoding.utf8.rawValue
              ) else { return nil }
        
        return prettyPrintedString as String
    }
    
}
