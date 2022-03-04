import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    private var refreshControl = UIRefreshControl()
    var refreshView: RefreshView!
    private var canRefresh = true
    var beforeDistance: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.refreshControl = refreshControl
        scrollView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        
        refreshView = RefreshView()
        refreshView.center.x = (scrollView.refreshControl?.frame.width)! / 2
        
        scrollView.refreshControl?.tintColor = .clear
        scrollView.refreshControl?.backgroundColor = .B500
        scrollView.refreshControl?.addSubview(refreshView)
    }
    
    @objc func pullToRefresh() {
        canRefresh = true
        // number roulett event
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let distance = max(0.0, -(scrollView.refreshControl?.frame.origin.y)!)
        refreshView.center.y = distance / 2
        if Int(distance) % 20 == 0 && distance > 0 && canRefresh {
            if distance >= beforeDistance {
                refreshView.imgCATransition(refreshView.refreshImage, down: true)
            } else {
                refreshView.imgCATransition(refreshView.refreshImage, down: false)
            }
        }
        beforeDistance = distance
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.canRefresh = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            scrollView.refreshControl?.endRefreshing()
        }
    }
}
