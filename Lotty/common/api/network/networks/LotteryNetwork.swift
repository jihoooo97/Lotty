import Alamofire

class LotteryNetwork: BaseNetwork, LotteryNetworkGateway {
    
    func getLottery(
        drwNo: Int,
        success: ((LotteryInfo?) -> Void)?,
        failure: ((ErrorEntitiy) -> Void)?
    ) {
        let param = LotteryRequest()
        param.drwNo = drwNo
        
        request(
            api: ApiLottery(),
            param: param,
            encoding: URLEncoding.queryString,
            responseType: LotteryResponse.self,
            success: { response in
                success?(response?.toViewEntity(LotteryInfo.self))
            },
            failure: { error in
                print("network - \(error)")
                let errorEntity = ErrorEntitiy()
                errorEntity.code = error.code
                errorEntity.message = error.message
                errorEntity.detail = error.detail
                failure?(errorEntity)
            })
    }
    
}
