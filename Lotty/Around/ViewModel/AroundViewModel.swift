import Foundation
import CoreLocation
import RxSwift
import RxRelay

final class AroundViewModel: BaseViewModel {
    
    // MARK: UseCase
    private let usecase: StoreUsecaseProtocol
    
    // MARK: Input
    let coordinateRelay = PublishRelay<CLLocationCoordinate2D>()
    
    // MARK: Output
    let storeListRelay = BehaviorRelay<[Store]>(value: [])
    let searchResultRelay = PublishRelay<Store>()
    let noResultRelay = PublishRelay<Void>()
    
    
    init(usecase: StoreUsecaseProtocol) {
        self.usecase = usecase
        super.init()
        
        coordinateRelay
            .throttle(.seconds(1), latest: true, scheduler: ConcurrentDispatchQueueScheduler(queue: .global()))
            .withUnretained(self).map { $0 }
            .bind { vm, coordinate in
                vm.getAround(x: coordinate.longitude, y: coordinate.latitude)
            }
            .disposed(by: disposeBag)
    }
    
    
    func updateCoordinate(x: Double, y: Double) {
        let coordinate = CLLocationCoordinate2D(latitude: y, longitude: x)
        coordinateRelay.accept(coordinate)
    }
    
    private func getAround(x: Double, y: Double) {
        usecase.getStoreList(x: x, y: y) { [weak self] result in
            switch result {
            case .success(let storeList):
                self?.storeListRelay.accept(storeList)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func searchAround(keyword: String) {
        usecase.searchStore(keyword: keyword) { [weak self] result in
            switch result {
            case .success(let store):
                guard let store else {
                    self?.noResultRelay.accept(())
                    return
                }
                self?.searchResultRelay.accept(store)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
