import UIKit
import RxSwift
import RxCocoa

final class LotterySearchViewController: UIViewController {
    
    private let viewModel: LotterySearchViewModel
    private var disposeBag = DisposeBag()
    
    public init(viewModel: LotterySearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private var navigationBar = UIView()
    private var backButton = UIButton()
    private var searchBar = UISearchBar()
    private var scrollView = UIScrollView()
    private var stackView = UIStackView()
    
    private var lotteryInfoView = LotteryDetailView()

    private var historyTopView = HistoryTableViewTopView(type: .lottery)
    private var historyTableView = HistoryTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initAttributes()
        initConstraints()
        inputBind()
        outputBind()
        bindSearchBar()
        bindHistoryTableView()
    }
    
    
    private func inputBind() {
        backButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withUnretained(self).map { $0.0 }
            .bind { vc in
                vc.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindSearchBar() {
        searchBar.rx.textDidBeginEditing
            .withUnretained(self).map { $0.0 }
            .bind { vc in
                vc.lotteryInfoView.isHidden = true
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
            .filter { $0.count > 0 }
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withUnretained(self).map { ($0.0, $0.1) }
            .bind { vc, text in
                if let turn = Int(text) {
                    vc.viewModel.searchLottery(turn: turn)
                    vc.scrollView.setContentOffset(.zero, animated: false)
                    vc.searchBar.text = ""
                    vc.searchBar.resignFirstResponder()
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func bindHistoryTableView() {
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
    
    private func outputBind() {
        // MARK: [!] Header로 구현? -> RxDataSource
        viewModel.lotteryInfoRelay
            .observe(on: MainScheduler.instance)
            .withUnretained(self).map { ($0.0, $0.1) }
            .bind { vc, lottery in
                vc.lotteryInfoView.isHidden = false
                vc.lotteryInfoView.bind(lottery: lottery)
            }
            .disposed(by: disposeBag)

        viewModel.historyListRelay
            .observe(on: MainScheduler.instance)
            .bind(to: historyTableView.rx.items(
                cellIdentifier: HistoryCell.cellId,
                cellType: HistoryCell.self)
            ) { [weak self] index, data, cell in
                cell.drwNo.text = data.keyword + "회"

                cell.clickButtonHandler = {
                    self?.searchBar.resignFirstResponder()
                    self?.viewModel.inputTapHistory.accept(data)
                }

                cell.deleteButtonHandler = {
                    self?.viewModel.inputDeleteHistory.accept(data)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.searchResultErrorRelay
            .withUnretained(self).map { $0.0 }
            .bind { vc in
                AlertManager.shared.showAlert(
                    title: "회차 오류",
                    message: "로또 회차 정보가 없습니다"
                )
                vc.searchBar.text = ""
            }
            .disposed(by: disposeBag)
    }
    
    func setFirstInfo(lottery: Lottery) {
        viewModel.searchLottery(turn: lottery.turn)
    }
    
    private func clearHistory() {
        let alert = UIAlertController(title: "알림", message: "최근 조회 목록을 모두 삭제하시겠습니까?", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default) { [weak self] action in
            self?.viewModel.inputClearHistory.accept(())
        }
        let cancel = UIAlertAction(title: "취소", style: .default)
        alert.addAction(confirm)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    @objc func keyboardDown() {
        self.searchBar.searchTextField.resignFirstResponder()
    }
    
}

extension LotterySearchViewController {
    
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
            $0.searchTextField.layer.cornerRadius = 8
            $0.searchTextField.leftView = UIImageView(image: scopeImage)
            $0.searchTextField.leftView?.contentMode = .scaleToFill
            $0.searchTextField.textColor = LottyColors.G900
            $0.searchTextField.backgroundColor = LottyColors.G50
            $0.searchTextField.attributedPlaceholder = NSAttributedString(
                string: "회차를 입력해주세요 ex) 1004",
                attributes: [.foregroundColor: LottyColors.Placeholder,
                             .font: UIFont(name: "Pretendard-Regular", size: 16)!]
            )
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.white.cgColor
            $0.backgroundColor = .white
            $0.barTintColor = .white
            $0.keyboardType = .numberPad
        }

        scrollView = UIScrollView().then {
            $0.backgroundColor = .white
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.keyboardDismissMode = .onDrag
        }

        stackView = UIStackView().then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .center
            $0.backgroundColor = .white
        }

        // MARK: LotteryView
        lotteryInfoView = LotteryDetailView().then {
            $0.backgroundColor = .white
            $0.isHidden = true
            let keyboardDown = UITapGestureRecognizer(target: self, action: #selector(keyboardDown))
            $0.addGestureRecognizer(keyboardDown)
        }
    }

    private func initConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        [navigationBar, scrollView].forEach {
            view.addSubview($0)
        }
        
        scrollView.addSubview(stackView)
        
        navigationBar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(safeArea)
            $0.height.equalTo(44)
        }
        
        scrollView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.bottom.equalTo(safeArea)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.height.equalTo(view)
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
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        [lotteryInfoView, historyTopView, historyTableView].forEach {
            stackView.addArrangedSubview($0)
        }

        lotteryInfoView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(400)
        }

        historyTopView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(60)
        }

        historyTableView.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
    }

}
