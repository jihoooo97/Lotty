import Foundation
import Alamofire
import RxSwift

class BaseViewModel {
    
    var disposeBag = DisposeBag()
    
    init() {
        
    }
    
    deinit {
        disposeBag = DisposeBag()
    }
    
}
