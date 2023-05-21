import UIKit
import RxSwift
import RxCocoa

protocol SearchDelegate: AnyObject {
    func mapSearch(keyword: String)
}

final class AroundSearchViewController: UIViewController {
    
    weak var coordinator: AroundSearchCoordinator?
    private let viewModel: AroundSearchViewModel
    private var disposeBag = DisposeBag()
    
    weak var delegate: SearchDelegate?
    
    
    init(viewModel: AroundSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var navigationBar = UIView()
    var backButton = UIButton()
    var searchBar = UISearchBar()
    
    var historyTopView = HistoryTableViewTopView(type: .map)
    var historyTableView = HistoryTableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initAttributes()
        initConstraints()
        inputBind()
        outputBind()
        bindHistoryTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.searchTextField.becomeFirstResponder()
    }
    
    private func inputBind() {
        backButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withUnretained(self).map { $0.0 }
            .bind { vc in
                vc.searchBar.resignFirstResponder()
                vc.coordinator?.finish()
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withUnretained(self).map { $0.0 }
            .bind { vc in
                guard let keyword = vc.searchBar.text else { return }
                vc.viewModel.selectHistory(keyword: keyword)
                vc.delegate?.mapSearch(keyword: keyword)
                vc.coordinator?.finish()
            }
            .disposed(by: disposeBag)
    }
    
    private func outputBind() {
        viewModel.historyListRelay
            .observe(on: MainScheduler.instance)
            .bind(to: historyTableView.rx.items(
                cellIdentifier: HistoryCell.cellId,
                cellType: HistoryCell.self)
            ) { [weak self] index, data, cell in
                cell.drwNo.text = data.keyword

                cell.clickButtonHandler = {
                    self?.searchBar.resignFirstResponder()
                    self?.viewModel.inputTapHistory.accept(data)
                    self?.delegate?.mapSearch(keyword: data.keyword)
                    self?.coordinator?.finish()
                }

                cell.deleteButtonHandler = {
                    self?.viewModel.inputDeleteHistory.accept(data)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func bindHistoryTableView() {
        viewModel.loadHistory()
        
        historyTopView.clearButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withUnretained(self).map { $0.0 }
            .bind { vc in
                vc.clearHistory()
            }
            .disposed(by: disposeBag)
        
        // MARK: [!] StickyHeader 적용
        historyTableView.rx.didScroll
            .withUnretained(self).map { $0.0 }
            .map { ($0, $0.historyTableView.contentOffset.y) }
            .bind { vc, offset in
                
            }
            .disposed(by: disposeBag)
    }
    
    private func clearHistory() {
        let alert = UIAlertController(
            title: "알림",
            message: "최근 조회 목록을 모두 삭제하시겠습니까?",
            preferredStyle: .alert
        )
        let confirm = UIAlertAction(title: "확인", style: .default) { [weak self] action in
            self?.viewModel.inputClearHistory.accept(())
        }
        let cancel = UIAlertAction(title: "취소", style: .default)
        alert.addAction(confirm)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
}

extension AroundSearchViewController {
    
    private func initAttributes() {
        view.backgroundColor = .white
        
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
        }
    }
    
    private func initConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        [navigationBar, historyTopView, historyTableView].forEach {
            view.addSubview($0)
        }
        
        navigationBar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(safeArea).offset(4)
            $0.height.equalTo(44)
        }
        
        [backButton, searchBar].forEach {
            navigationBar.addSubview($0)
        }
        
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
        
        historyTopView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.height.equalTo(60)
        }
        
        historyTableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(historyTopView.snp.bottom)
        }
    }
    
}
