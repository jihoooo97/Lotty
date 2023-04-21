//
//  LotteryDataStore.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/15.
//

import Alamofire

class API {
    static let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        let apiLogger = LottyAPIEventLogger()
        return Session(configuration: configuration, eventMonitors: [apiLogger])
    }()
}

class LotteryDataStore {
    
    init() { }
    
    func getLottery(
        turn: Int,
        completion: @escaping(Result<LotteryDTO, Error>) -> Void
    ) {
        API.session.request(
            LotteryAPI.getLottery(turn: turn),
            interceptor: LottyRequestInterceptor()
        )
        .responseDecodable(of: LotteryDTO.self
        ) { response in
            switch response.result {
            case .success(let lottery):
                
                completion(.success(lottery))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        
    }
    
}
