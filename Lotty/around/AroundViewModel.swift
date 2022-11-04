import Foundation
import CoreLocation
import RxSwift
import RxRelay

final class AroundViewModel: BaseViewModel {

    // MARK: UseCase
    let aroundUseCase = AroundUseCase()
    
    // MARK: Input
    let coordinateRelay = PublishRelay<CLLocationCoordinate2D>()
    
    // MARK: Output
    let storeInfoRelay = BehaviorRelay<[Documents]>(value: [])
    let searchResultRelay = BehaviorRelay<[Documents]>(value: [])
    
    override init() {
        super.init()
        
        coordinateRelay
            .throttle(.seconds(1), latest: true,
                      scheduler: ConcurrentDispatchQueueScheduler(queue: .global()))
            .withUnretained(self).map { $0 }
            .map { ($0, $1) }
            .bind(onNext: { (vm, coordinate) in
                vm.getAround(x: coordinate.longitude, y: coordinate.latitude)
            }
            ).disposed(by: disposeBag)
    }
    
    func updateCoordinate(x: Double, y: Double) {
        let coordinate = CLLocationCoordinate2D(latitude: y,
                                                longitude: x)
        coordinateRelay.accept(coordinate)
    }
    
    private func getAround(x: Double, y: Double) {
        aroundUseCase.newAround(
            x: x, y: y,
            success: { (count, response) in
                guard let result = response?.documents else { return }
                self.storeInfoRelay.accept(result)
            }, failure: { error in
                print(error)
            })
    }
    
    func searchAround(query: String) {
        aroundUseCase.searchAround(
            query: query,
            success: { [weak self] response in
                guard let result = response?.documents else { return }
                self?.searchResultRelay.accept(result)
            }, failure: { error in
                print(error)
            })
    }
    
}
