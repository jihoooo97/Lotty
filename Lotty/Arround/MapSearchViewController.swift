import UIKit

class MapSearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UIView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var historyTableView: UITableView!
    
    weak var delegate: SearchDelegate?
    
    var historyList: [String] = []
    
    // [!] placeholder 색상 변경 #999999
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.delegate = self
        historyTableView.backgroundColor = .white
        configureNavi()
        
        historyList = Storage.retrive("", from: .documents, as: [String].self) ?? []
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
    }

    func configureNavi() {
        searchBar.layer.cornerRadius = 8
        searchField.textColor = .G900
    }
    
    @IBAction func clearHistory(_ sender: Any) {
        historyList = []
        Storage.remove("", from: .documents)
        historyTableView.reloadData()
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
        self.historyList.append(textField.text!)
        self.dismiss(animated: false, completion: nil)
        return true
    }
}
