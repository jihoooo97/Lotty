import Foundation

class LotteryUseCase: LotteryNetworkGateway {

    let network = GatewayBuilder.lotteryNetworkGateway()

    func getLottery(
        drwNo: Int,
        success: ((LotteryInfo?) -> Void)?,
        failure: ((ErrorEntitiy) -> Void)?
    ) {
        network.getLottery(drwNo: drwNo, success: success, failure: failure)
    }

}
