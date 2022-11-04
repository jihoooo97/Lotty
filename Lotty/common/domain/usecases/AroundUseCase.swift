import Foundation

final class AroundUseCase: NSObject {

    let network = GatewayBuilder.arroundNetworkGateway()
    
    func newAround(
        x: Double,
        y: Double,
        success: ((_ count: Int, _ entities: StoreInfo?) -> Void)?,
        failure: ((ErrorEntitiy) -> Void)?
    ) {
        network.newAround(x: x, y: y, success: success, failure: failure)
    }
    
    func searchAround(
        query: String,
        success: ((_ entities: StoreInfo?) -> Void)?,
        failure: ((ErrorEntitiy) -> Void)?
    ) {
        network.searchAround(query: query, success: success, failure: failure)
    }
    
}
