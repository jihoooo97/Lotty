import Foundation

class GatewayBuilder: NSObject {

    // MARK: Network
    
    static func arroundNetworkGateway() -> AroundNetworkGateway {
        return AroundNetwork()
    }
    
    static func lotteryNetworkGateway() -> LotteryNetworkGateway {
        return LotteryNetwork()
    }
    
    
    // MARK: Database
    
}
