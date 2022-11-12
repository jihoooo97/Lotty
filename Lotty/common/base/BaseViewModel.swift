import Foundation
import Alamofire
import RxSwift

class BaseViewModel: NSObject {
    
    var disposeBag = DisposeBag()
    
    override init() {
        super.init()
        
    }
    
    deinit {
        disposeBag = DisposeBag()
    }
    
}
