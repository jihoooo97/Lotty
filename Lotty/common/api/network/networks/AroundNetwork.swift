import Foundation
import Alamofire

class AroundNetwork: BaseNetwork, AroundNetworkGateway {

    func newAround(
        x: Double,
        y: Double,
        success: ((_ count: Int, _ entities: StoreInfo?) -> Void)?,
        failure: ((ErrorEntitiy) -> Void)?
    ) {
        let param = AroundRequest()
        param.x = x
        param.y = y
        param.size = 15
        
        request(
            api: ApiAround(),
            param: param,
            encoding: URLEncoding.queryString,
            responseType: AroundResponse.self,
            success: { response in
                success?(
                    response?.documents.count ?? 0,
                    response?.toViewEntity(StoreInfo.self)
                )
            },
            failure: { error in
                print("network - \(error)")
                let errorEntity = ErrorEntitiy()
                errorEntity.code = error.code
                errorEntity.message = error.message
                errorEntity.detail = error.detail
                failure?(errorEntity)
            }
        )
    }
    
    func searchAround(
        query: String,
        success: ((StoreInfo?) -> Void)?,
        failure: ((ErrorEntitiy) -> Void)?
    ) {
        let param = AroundRequest()
        param.query = query
        param.size = 1
        
        request(
            api: ApiAround(),
            param: param,
            encoding: URLEncoding.queryString,
            responseType: AroundResponse.self,
            success: { response in
                success?(
                    response?.toViewEntity(StoreInfo.self)
                )
            },
            failure: { error in
                print("network - \(error)")
                let errorEntity = ErrorEntitiy()
                errorEntity.code = error.code
                errorEntity.message = error.message
                errorEntity.detail = error.detail
                failure?(errorEntity)
            }
        )
    }
    
}
