//
//  LottyAPIEventLogger.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/20.
//

import Alamofire

class LottyAPIEventLogger: EventMonitor {
    
    let queue = DispatchQueue(label: "LottyNetworkLogger")
    
    func requestDidFinish(_ request: Request) {
        guard let httpRequest = request.request else {
            print("⚠️ Invalid Request")
            return
        }
        
        var log = ""
        let url = httpRequest.description
        let method = httpRequest.httpMethod ?? "unknown method"
        
        log.append("------------------------------------------------------------\n")
        log.append("🛰️ Request [\(method)]\n")
        log.append("------------------------------------------------------------\n")
        log.append("\(url)\n")
        
        if let body = httpRequest.httpBody,
           let bodyString = String(bytes: body, encoding: .utf8) {
            log.append("\(bodyString)\n\n")
        }
        
        log.append("🛰️ Request End\n")
        log.append("------------------------------------------------------------\n")
        print(log)
    }
    
    func request<Value>(
        _ request: DataRequest,
        didParseResponse response: DataResponse<Value, AFError>
    ) {
        switch response.result {
        case .success(_):
            var log = ""
            let request = response.request
            let url = request?.url?.absoluteString ?? "nil"
            let statusCode = response.response?.statusCode ?? -1
            
            log.append("------------------------------------------------------------\n")
            log.append("✅ Response [\(statusCode)]\n")
            log.append("------------------------------------------------------------\n")
            log.append("\(url)\n")
            
            response.response?.allHeaderFields.forEach {
                log.append("\($0): \($1)\n")
            }
            
            log.append("------------------------------------------------------------\n")
            log.append("\(response.data?.prettyPrintedJSONString ?? "nil")\n")
            log.append("✅ Response End (\(response.data?.count ?? 0)-byte body)\n")
            log.append("------------------------------------------------------------\n")
            print(log)
            
        case .failure(let error):
            var log = ""
            
            if let responseCode = error.responseCode {
                print(responseCode)
            }
            
            log.append("------------------------------------------------------------\n")
            log.append("⚠️ Error Code [\(error.failureReason ?? "unknown")]\n")
            log.append("------------------------------------------------------------\n")
            log.append("\(error.failureReason ?? error.errorDescription ?? "unknown error")\n")
            log.append("⚠️ Error End\n")
            log.append("------------------------------------------------------------\n")
            print(log)
        }
    }

}
