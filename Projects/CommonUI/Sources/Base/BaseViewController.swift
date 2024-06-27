import UIKit

open class BaseViewController: UIViewController {
    
    public init() {
        super.init(nibName: nil, bundle: nil)
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
    }
    
    
    open func setUIProperty() { }
    open func setLayout() { }
    
}
