import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var pullDownView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mapButton: UIView!
    @IBOutlet weak var searchButton: UIView!
    @IBOutlet weak var qrButton: UIView!
    @IBOutlet weak var randomButton: UIView!
    
    var refreshView: RefreshView!
    var beforeDistance: CGFloat = 0
    var eventNumber = Int.random(in: 1...45)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.refreshControl = UIRefreshControl()
        refreshView = RefreshView()
        refreshView.center.x = (scrollView.refreshControl?.frame.width)! / 2
        
        scrollView.refreshControl?.tintColor = .clear
        scrollView.refreshControl?.backgroundColor = .B500
        scrollView.refreshControl?.addSubview(refreshView)
        
        setContentView()
        self.refreshView.randomNumber.isHidden = true
        refreshView.refreshImage.isHidden = !refreshView.randomNumber.isHidden
    }
    
    func setContentView() {
        let mapButtonTap = UITapGestureRecognizer(target: self, action: #selector(moveToMap))
        let searchButtonTap = UITapGestureRecognizer(target: self, action: #selector(moveToSearch))
        let qrButtonTap = UITapGestureRecognizer(target: self, action: #selector(moveToQR))
        let randomButtonTap = UITapGestureRecognizer(target: self, action: #selector(moveToRandom))
        
        mapButton.addGestureRecognizer(mapButtonTap)
        searchButton.addGestureRecognizer(searchButtonTap)
        qrButton.addGestureRecognizer(qrButtonTap)
        randomButton.addGestureRecognizer(randomButtonTap)
        
        mapButton.layer.borderWidth = 1
        mapButton.layer.borderColor = UIColor.B600.cgColor
        mapButton.layer.cornerRadius = 8
        mapButton.layer.masksToBounds = false
        mapButton.layer.shadowColor = UIColor.black.cgColor
        mapButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        mapButton.layer.shadowOpacity = 0.2
        
        searchButton.layer.borderWidth = 1
        searchButton.layer.borderColor = UIColor.white.cgColor
        searchButton.layer.cornerRadius = 8
        searchButton.layer.masksToBounds = false
        searchButton.layer.shadowColor = UIColor.black.cgColor
        searchButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        searchButton.layer.shadowOpacity = 0.2
        
        qrButton.layer.borderWidth = 1
        qrButton.layer.borderColor = UIColor.white.cgColor
        qrButton.layer.cornerRadius = 8
        qrButton.layer.masksToBounds = false
        qrButton.layer.shadowColor = UIColor.black.cgColor
        qrButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        qrButton.layer.shadowOpacity = 0.2
        
        randomButton.layer.borderWidth = 1
        randomButton.layer.borderColor = UIColor.white.cgColor
        randomButton.layer.cornerRadius = 8
        randomButton.layer.masksToBounds = false
        randomButton.layer.shadowColor = UIColor.black.cgColor
        randomButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        randomButton.layer.shadowOpacity = 0.2
    }
    
    @objc func moveToMap() {
        self.tabBarController?.selectedIndex = 1
    }
    
    @objc func moveToSearch() {
        self.tabBarController?.selectedIndex = 2
    }
    
    @objc func moveToQR() {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "qrScanView") as? QrScanViewController else { return }
        vc.modalPresentationStyle = .popover
        //vc.navigationItem
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func moveToRandom() {
        self.tabBarController?.selectedIndex = 3
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let distance = max(0.0, -(scrollView.refreshControl?.frame.origin.y)!)
        var direction = true
        refreshView.center.y = distance / 2
        
        if Int(distance) % 40 == 0 && distance >= 20 {
            if distance > self.beforeDistance { direction = true }
            else { direction = false }
            self.refreshView.imgCATransition(self.refreshView.refreshImage, down: direction)
        }
        beforeDistance = distance
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        refreshView.randomNumber.isHidden = false
        refreshView.refreshImage.isHidden = !refreshView.randomNumber.isHidden
        
        eventNumber = Int.random(in: 1...45)
        refreshView.configure(with: eventNumber)
        refreshView.animate()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            scrollView.refreshControl?.endRefreshing()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.refreshView.refreshImage.isHidden = false
                self.refreshView.randomNumber.isHidden = !self.refreshView.refreshImage.isHidden
            }
        }
        
    }
}
