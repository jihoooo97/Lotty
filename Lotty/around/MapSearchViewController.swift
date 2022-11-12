import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then

protocol SearchDelegate: NSObjectProtocol {
    func mapSearch(query: String)
}

final class MapSearchViewController: UIViewController {
    
    var backButton = UIButton()
    var searchTextField = UITextField()
    
    var topView = UIView()
    var historyLabel = UILabel()
    var clearButton = UIButton()
    
    var historyTableView = UITableView()
    
    var safeArea = UILayoutGuide()
    
    let viewModel = AroundSearchViewModel()
    var disposeBag = DisposeBag()
    
    weak var delegate: SearchDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initAttributes()
        initUI()
        inputBind()
        outputBind()
        
        historyTableView.delegate = self
        searchTextField.delegate = self
        historyTableView.backgroundColor = .white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        viewModel.getHistoryList()
        searchTextField.becomeFirstResponder()
    }
    
    func inputBind() {
        backButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withUnretained(self).map { $0.0 }
            .bind(onNext: {
                $0.dismiss(animated: false)
            }).disposed(by: disposeBag)
        
        clearButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withUnretained(self).map { $0.0 }
            .bind(onNext: {
                $0.clearHistory()
            }).disposed(by: disposeBag)
    }
    
    func outputBind() {
        viewModel.historyListRelay
            .observe(on: MainScheduler.instance)
            .bind(to: historyTableView.rx.items(
                cellIdentifier: "locationHistoryCell", cellType: LocationHistoryCell.self
            )) { [weak self] (index, item, cell) in
                cell.locationLabel.text = item

                cell.clickButtonHandler = {
                    guard var historyList = self?.viewModel.historyListRelay.value else { return }
                    self?.searchTextField.resignFirstResponder()
                    
                    historyList.remove(at: index)
                    historyList.insert(cell.locationLabel.text!, at: 0)
                    self?.viewModel.historyListRelay.accept(historyList)
                    
                    self?.delegate?.mapSearch(query: cell.locationLabel.text!)
                    self?.dismiss(animated: false)
                }
                
                cell.deleteButtonHandler = {
                    guard var historyList = self?.viewModel.historyListRelay.value else { return }
                    historyList.remove(at: index)
                    self?.viewModel.historyListRelay.accept(historyList)
                }
            }.disposed(by: disposeBag)
    }
    
    private func clearHistory() {
        let alert = UIAlertController(title: "알림", message: "최근 조회 목록을 모두 삭제하시겠습니까?", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default) { [weak self] ction in
            self?.viewModel.historyListRelay.accept([])
            Storage.remove("location_history.json", from: .documents)
        }
        let cancel = UIAlertAction(title: "취소", style: .default)
        alert.addAction(confirm)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
//    func tapView() {
//        searchTextField.resignFirstResponder()
//    }
    
}


//extension MapSearchViewController: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "locationEmptyCell", for: indexPath) as? LocationEmptyCell else { return UITableViewCell() }
//        cell.explainLabel.text = "최근 검색어가 없어요"
//        return cell
//    }
//
//}

extension MapSearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.historyListRelay.value.count > 0 { return 50 }
        else { return 150 }
    }
    
}

extension MapSearchViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    // [!] 자음, 모음만 검색하는것 처리
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        var historyList = viewModel.historyListRelay.value
        if !historyList.contains(textField.text!)  {
            historyList.insert(textField.text!, at: 0)
            viewModel.historyListRelay.accept(historyList)
        }
        self.delegate?.mapSearch(query: textField.text!)
        self.dismiss(animated: false)
        return true
    }
    
}

extension MapSearchViewController: BaseViewController {
    
    func initAttributes() {
        safeArea = view.safeAreaLayoutGuide
        
        backButton = UIButton().then {
            $0.setImage(LottyIcons.backButton, for: .normal)
            $0.tintColor = LottyColors.G600
        }
        
        searchTextField = UITextField().then {
            $0.backgroundColor = LottyColors.Placeholder
            $0.layer.cornerRadius = 8
            $0.textColor = LottyColors.G900
            $0.font = LottyFonts.medium(size: 16)
            $0.attributedPlaceholder = NSAttributedString(
                string: "지역 이름으로 검색하세요",
                attributes: [.foregroundColor: LottyColors.Placeholder]
            )
            $0.delegate = self
        }
        
        topView = UIView().then {
            $0.backgroundColor = .white
        }
        
        historyLabel = UILabel().then {
            $0.textColor = LottyColors.Placeholder
            $0.font = LottyFonts.semiBold(size: 15)
            $0.text = "최근 검색어"
        }
        
        clearButton = UIButton().then {
            $0.setImage(LottyIcons.trashIcon, for: .normal)
            $0.tintColor = LottyColors.Placeholder
            $0.titleLabel?.textColor = LottyColors.Placeholder
            $0.setTitle("전체 삭제", for: .normal)
        }
        
        historyTableView = UITableView().then {
            $0.backgroundColor = .white
            $0.delegate = self
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.register(LocationHistoryCell.self, forCellReuseIdentifier: "locationHistoryCell")
        }
        
    }
    
    func initUI() {
        [backButton, searchTextField, topView, historyTableView]
            .forEach { view.addSubview($0) }
        
        [historyLabel, clearButton]
            .forEach { topView.addSubview($0) }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.centerY.equalTo(searchTextField)
            $0.width.height.equalTo(30)
        }
        
        searchTextField.snp.makeConstraints {
            $0.leading.equalTo(backButton.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().offset(-12)
            $0.top.equalTo(safeArea).offset(4)
            $0.height.equalTo(44)
        }
        
        topView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(searchTextField.snp.bottom).offset(10)
            $0.height.equalTo(40)
        }
        
        historyTableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(topView.snp.bottom)
            $0.bottom.equalTo(safeArea)
        }
    }
    
}
