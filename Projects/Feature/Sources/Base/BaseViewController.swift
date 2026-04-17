import UIComponent

import UIKit
import RxSwift
import RxCocoa
import SnapKit

open class BaseViewController: UIViewController {
    
    public lazy var safeArea = view.safeAreaLayoutGuide
    
    public var bag = DisposeBag()
    
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        bag = .init()
    }
    
    @available(*, unavailable, message: "removed required init")
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setUIProperty()
        setLayout()
        logFirstScreenView()
    }
    
    
    open func setUIProperty() { }
    open func setLayout() { }
    
    private func logFirstScreenView() {
        let screenName = String(describing: type(of: self))
        print("First screen view logged: \(screenName)")
    }
    
}
