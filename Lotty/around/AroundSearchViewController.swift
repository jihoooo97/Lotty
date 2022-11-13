import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

protocol SearchDelegate: NSObjectProtocol {
    func mapSearch(query: String)
}

final class AroundSearchViewController: UIViewController {
    
    var navigationBar = UIView()
    var backButton = UIButton()
    var searchBar = UISearchBar()
    
    var historyTopView = UIView()
    var historyTitleLabel = UILabel()
    var historyClearButton = UIButton()
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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBar.searchTextField.becomeFirstResponder()
    }
    
    func inputBind() {
        backButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withUnretained(self).map { $0.0 }
            .bind(onNext: {
                $0.dismiss(animated: false)
            }).disposed(by: disposeBag)
        
        historyClearButton.rx.tap
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
                cellIdentifier: HistoryCell.cellId, cellType: HistoryCell.self
            )) { [weak self] (index, item, cell) in
                cell.drwNo.text = item
                
                cell.clickButtonHandler = {
                    self?.searchBar.searchTextField.resignFirstResponder()

                    self?.delegate?.mapSearch(query: item)
                    self?.viewModel.updateHistory(index: index, query: item)
                    self?.dismiss(animated: false)
                }
                
                cell.deleteButtonHandler = {
                    self?.viewModel.deleteHistory(index: index)
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
    
}

extension AroundSearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.historyListRelay.value.count > 0 { return 50 }
        else { return 150 }
    }
    
}

extension AroundSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        self.viewModel.updateHistory(index: -1, query: searchBar.text!)
        self.delegate?.mapSearch(query: searchBar.text!)
        self.dismiss(animated: false)
    }
    
}

extension AroundSearchViewController: ViewController {
    
    func initAttributes() {
        view.backgroundColor = .white
        safeArea = view.safeAreaLayoutGuide
        
        navigationBar = UIView().then {
            $0.backgroundColor = .white
        }
        
        backButton = UIButton().then {
            $0.tintColor = LottyColors.B500
            $0.setImage(LottyIcons.arrowLeft, for: .normal)
        }
        
        searchBar = UISearchBar().then {
            let scopeImage = LottyIcons.search.resize(width: 20).withTintColor(LottyColors.Placeholder)
            $0.searchTextField.layer.cornerRadius = 4
            $0.searchTextField.leftView = UIImageView(image: scopeImage)
            $0.searchTextField.leftView?.contentMode = .scaleToFill
            $0.searchTextField.textColor = LottyColors.G900
            $0.searchTextField.backgroundColor = LottyColors.G50
            $0.searchTextField.attributedPlaceholder = NSAttributedString(
                string: "지역 이름으로 검색하세요",
                attributes: [.foregroundColor: LottyColors.Placeholder,
                             .font: UIFont(name: "Pretendard-Regular", size: 16)!]
            )
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.white.cgColor
            $0.backgroundColor = .white
            $0.barTintColor = .white
            $0.delegate = self
        }
        
        historyTopView = UIView().then {
            $0.backgroundColor = .white
        }
        
        historyTitleLabel = UILabel().then {
            $0.textAlignment = .center
            $0.textColor = LottyColors.Placeholder
            $0.font = LottyFonts.semiBold(size: 15)
            $0.text = "최근 검색어"
        }
        
        historyClearButton = UIButton().then {
            $0.setTitle("전체 삭제", for: .normal)
            $0.setTitleColor(LottyColors.Placeholder, for: .normal)
            $0.titleLabel?.font = LottyFonts.semiBold(size: 13)
            let clearImage = LottyIcons.trashIcon.resize(width: 15).withTintColor(LottyColors.Placeholder)
            $0.setImage(clearImage, for: .normal)
        }
        
        historyTableView = UITableView().then {
            $0.backgroundColor = .white
            $0.separatorStyle = .none
            $0.keyboardDismissMode = .onDrag
            $0.delegate = self
            $0.register(HistoryCell.self, forCellReuseIdentifier: HistoryCell.cellId)
        }
    }
    
    func initUI() {
        [navigationBar, historyTopView, historyTableView]
            .forEach { view.addSubview($0) }
        
        navigationBar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(safeArea).offset(4)
            $0.height.equalTo(44)
        }
        
        [backButton, searchBar]
            .forEach { navigationBar.addSubview($0) }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(25)
        }
        
        searchBar.snp.makeConstraints {
            $0.leading.equalTo(backButton.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-8)
            $0.top.bottom.equalTo(navigationBar)
        }
        
        [historyTitleLabel, historyClearButton]
            .forEach { historyTopView.addSubview($0) }
        
        historyTopView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.height.equalTo(66)
        }
        
        historyTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.centerY.equalToSuperview()
        }
        
        historyClearButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-26)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(70)
        }
        
        historyTableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(historyTopView.snp.bottom)
        }
    }
    
}
