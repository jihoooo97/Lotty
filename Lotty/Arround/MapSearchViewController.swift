import UIKit

class MapSearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UIView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var clearView: UIView!
    @IBOutlet weak var historyTableView: UITableView!

    weak var delegate: SearchDelegate?
    
    private var historyList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTableView.dataSource = self
        historyTableView.delegate = self
        searchField.delegate = self
        historyTableView.backgroundColor = .white
        configureNavi()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        historyList = Storage.retrive("location_history.json", from: .documents, as: [String].self) ?? []
        searchField.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Storage.store(self.historyList, to: .documents, as: "location_history.json")
    }
    
    func configureNavi() {
        searchBar.layer.cornerRadius = 8
        searchField.textColor = .G900
        searchField.attributedPlaceholder = NSAttributedString(
            string: "지역 이름으로 검색하세요",
            attributes: [.foregroundColor: UIColor.Placeholder]
        )
        
        let clearTap = UITapGestureRecognizer(target: self, action: #selector(clearHistory))
        clearView.addGestureRecognizer(clearTap)
    }
    
    @objc func clearHistory() {
        let alert = UIAlertController(title: "알림", message: "최근 조회 목록을 모두 삭제하시겠습니까?", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default) { action in
            self.historyList = []
            Storage.remove("location_history.json", from: .documents)
            self.historyTableView.reloadData()
        }
        let cancel = UIAlertAction(title: "취소", style: .default)
        alert.addAction(confirm)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func tapView(_ sender: Any) {
        searchField.resignFirstResponder()
    }
}

extension MapSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if historyList.count > 0 {
            return historyList.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if historyList.count > 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "locationHistoryCell", for: indexPath) as? LocationHistoryCell else { return UITableViewCell() }
            cell.locationLabel.text = historyList[indexPath.row]
            cell.clickButtonHandler = {
                self.searchField.resignFirstResponder()
                self.historyList.remove(at: indexPath.row)
                self.historyList.insert(cell.locationLabel.text!, at: 0)
                self.delegate?.mapSearch(query: cell.locationLabel.text!)
                self.dismiss(animated: false)
            }
            cell.deleteButtonHandler = {
                self.historyList.remove(at: indexPath.row)
                self.historyTableView.reloadData()
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "locationEmptyCell", for: indexPath) as? LocationEmptyCell else { return UITableViewCell() }
            cell.explainLabel.text = "최근 검색어가 없어요"
            return cell
        }
    }
}

extension MapSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if historyList.count > 0 {
            return 50
        } else {
            return 150
        }
    }
}

extension MapSearchViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    // [!] 자음, 모음만 검색하는것 처리
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.historyList.append(textField.text!)
        self.delegate?.mapSearch(query: textField.text!)
        self.dismiss(animated: false)
        return true
    }
}
