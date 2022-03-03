import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    private var refreshControl = UIRefreshControl()
    var loadingImg: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height).isActive = true
        print(contentView.frame.height)
        print(contentView.heightAnchor)
        scrollView.refreshControl = refreshControl
        scrollView.refreshControl?.attributedTitle = NSAttributedString(string: "땡겨요")
        scrollView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        
        self.loadingImg = UILabel()
    }

    @objc func pullToRefresh() {
        scrollView.refreshControl?.endRefreshing()
    }
}
