import Foundation

protocol AroundNetworkGateway {

    func newAround(
        x: Double,
        y: Double,
        success: ((_ count: Int, _ entities: StoreInfo?) -> Void)?,
        failure: ((ErrorEntitiy) -> Void)?
    )
    
    func searchAround(
        query: String,
        success: ((_ entities: StoreInfo?) -> Void)?,
        failure: ((ErrorEntitiy) -> Void)?
    )
}
