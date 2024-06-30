import UIKit
import RxSwift

open class BaseViewController: UIViewController {
    
    public var injector: Injector?
    public let disposeBag = DisposeBag()
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "removed required init")
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public lazy var safeArea = view.safeAreaLayoutGuide
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setUIProperty()
        setLayout()
    }
    
    
    open func setUIProperty() { }
    open func setLayout() { }
    
}
