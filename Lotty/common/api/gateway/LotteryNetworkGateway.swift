import Foundation

protocol LotteryNetworkGateway {
    
    func getLottery(
        drwNo: Int,
        success: ((_ entities: LotteryInfo?) -> Void)?,
        failure: ((ErrorEntitiy) -> Void)?
    )
    
}
