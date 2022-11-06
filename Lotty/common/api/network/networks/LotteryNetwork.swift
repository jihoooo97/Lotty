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
                failure?(ErrorEntitiy())
            })
    }
    
}
