import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    private var refreshControl = UIRefreshControl()
    var refreshView: RefreshView!
    private var canRefresh = true
    var beforeDistance: CGFloat = 0
    
    let randomNumber = CountLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.refreshControl = refreshControl
        
        refreshView = RefreshView()
        refreshView.center.x = (scrollView.refreshControl?.frame.width)! / 2
        
        scrollView.refreshControl?.tintColor = .clear
        scrollView.refreshControl?.backgroundColor = .B500
        scrollView.refreshControl?.addSubview(refreshView)
        
        setEndNumber()
    }
    
    func setEndNumber() {
        randomNumber.translatesAutoresizingMaskIntoConstraints = false
        randomNumber.frame = CGRect(x: 200, y: 200, width: 50, height: 50)
        randomNumber.sizeToFit()
        randomNumber.text = "\(Int.random(in: 1...45))"
        randomNumber.textColor = .G900
        
        contentView.addSubview(randomNumber)
        randomNumber.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        randomNumber.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let distance = max(0.0, -(scrollView.refreshControl?.frame.origin.y)!)
        var direction = true
        refreshView.center.y = distance / 2
        
        //   && (scrollView.refreshControl?.isRefreshing)!
        if Int(distance) % 20 == 0 && distance >= 20 {
            if distance > self.beforeDistance { direction = true }
            else { direction = false }
            self.refreshView.imgCATransition(self.refreshView.refreshImage, down: direction)
        }
        beforeDistance = distance
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            scrollView.refreshControl?.endRefreshing()
        }
    }
}
