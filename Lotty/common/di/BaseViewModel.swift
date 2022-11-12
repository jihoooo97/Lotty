import Foundation
import Alamofire
import RxSwift

class BaseViewModel: ViewModel {
    
    var disposeBag = DisposeBag()
    
    init() {
        
    }
    
    deinit {
        disposeBag = DisposeBag()
    }
    
}
