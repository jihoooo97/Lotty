import UIKit

class MapSearchViewController: UIViewController {
    @IBOutlet weak var naviView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    weak var delegate: SearchDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        configureNavi()
        naviView.layer.borderWidth = 1
        naviView.layer.borderColor = UIColor.lightGray.cgColor
        naviView.layer.cornerRadius = 4
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
    }

    func configureNavi() {
        naviView.layer.borderColor = UIColor.lightGray.cgColor
        searchBar.showsScopeBar = false
        searchBar.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
        searchBar.searchTextField.backgroundColor = UIColor.clear
        searchBar.searchTextField.textColor = .G900
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func tapView(_ sender: Any) {
        searchBar.resignFirstResponder()
    }
}

extension MapSearchViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.delegate?.mapSearch(query: searchBar.text!)
        self.dismiss(animated: false, completion: nil)
    }
}
