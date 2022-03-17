import UIKit

class MapSearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UIView!
    @IBOutlet weak var searchField: UITextField!
    
    weak var delegate: SearchDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.delegate = self
        configureNavi()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
    }

    func configureNavi() {
        searchBar.layer.cornerRadius = 8
        searchField.textColor = .G900
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func tapView(_ sender: Any) {
        searchBar.resignFirstResponder()
    }
}

extension MapSearchViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    // 자음, 모음만 검색하는것 처리
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.delegate?.mapSearch(query: textField.text!)
        self.dismiss(animated: false, completion: nil)
        return true
    }
}
