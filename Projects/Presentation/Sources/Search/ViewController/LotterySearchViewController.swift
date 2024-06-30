import Domain
import Common
import CommonUI
import UIKit
import RxSwift

public final class LotterySearchViewController: BaseViewController {
    
    private let viewModel: LotterySearchViewModel
    
    public init(viewModel: LotterySearchViewModel) {
        self.viewModel = viewModel
        super.init()
        self.hidesBottomBarWhenPushed = true
    }
    
    
    private let navigationBar = UIView()
    private lazy var backButton = UIButton()
    private lazy var searchBar = UISearchBar()
    
    private let searchBarAccessoryView = TextFieldAccessoryView()
    private lazy var lotteryInfoView = LotteryDetailView()

    private let historyTopView = HistoryTableViewTopView(isLottry: true)
    private let historyTableView = HistoryTableView()
    
    public override func viewDidLoad() {
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
            .bind {
                $0.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindSearchBar() {
        searchBar.rx.textDidBeginEditing
            .withUnretained(self).map { $0.0 }
            .bind { vc in
                vc.lotteryInfoView.isHidden = true
                vc.updateLayout(isSearched: false)
            }
            .disposed(by: disposeBag)
        
        searchBarAccessoryView.leftButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                self?.view.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        searchBarAccessoryView.rightButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                guard let turn = Int(self?.searchBar.text ?? "0") else { return }
                self?.viewModel.searchLottery(turn: turn)
                self?.searchBar.text = ""
                self?.view.endEditing(true)
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
//        historyTableView.rx.didScroll
//            .withUnretained(self).map { $0.0 }
//            .map { ($0, $0.historyTableView.contentOffset.y) }
//            .bind { vc, offset in
//                
//            }
//            .disposed(by: disposeBag)
    }
    
    private func outputBind() {
        // MARK: [!] Header로 구현? -> RxDataSource
        viewModel.lotteryInfoRelay
            .observe(on: MainScheduler.instance)
            .withUnretained(self).map { ($0.0, $0.1) }
            .bind { vc, lottery in
                vc.lotteryInfoView.isHidden = false
                vc.lotteryInfoView.bind(lottery: lottery)
                vc.updateLayout(isSearched: true)
            }
            .disposed(by: disposeBag)

        viewModel.historyListRelay
            .observe(on: MainScheduler.instance)
            .bind(to: historyTableView.rx.items(
                cellIdentifier: HistoryCell.cellId,
                cellType: HistoryCell.self)
            ) { [weak self] index, data, cell in
                cell.bind(drwNo: data.keyword + "회")

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
    
    private func updateLayout(isSearched: Bool) {
        historyTopView.snp.remakeConstraints {
            $0.horizontalEdges.equalTo(safeArea)
            $0.height.equalTo(60)
            if isSearched {
                $0.top.equalTo(lotteryInfoView.snp.bottom)
            } else {
                $0.top.equalTo(searchBar.snp.bottom)
            }
        }
    }
    
}

extension LotterySearchViewController {
    
    private func initAttributes() {
        navigationBar.backgroundColor = .white

        backButton = {
            let button = UIButton()
            button.tintColor = LottyColors.B500
            button.setImage(LottyIcons.arrowLeft, for: .normal)
            return button
        }()

        searchBar = {
            let searchBar = UISearchBar()
            let scopeImage = LottyIcons.search.resize(width: 20).withTintColor(LottyColors.Placeholder)
            searchBar.searchTextField.layer.cornerRadius = 8
            searchBar.searchTextField.leftView = UIImageView(image: scopeImage)
            searchBar.searchTextField.leftView?.contentMode = .scaleToFill
            searchBar.searchTextField.textColor = LottyColors.G900
            searchBar.searchTextField.backgroundColor = LottyColors.G50
            searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
                string: "회차를 입력해주세요 ex) 1004",
                attributes: [.foregroundColor: LottyColors.Placeholder,
                             .font: UIFont(name: "Pretendard-Regular", size: 16)!]
            )
            searchBar.layer.borderWidth = 1
            searchBar.layer.borderColor = UIColor.white.cgColor
            searchBar.backgroundColor = .white
            searchBar.barTintColor = .white
            searchBar.keyboardType = .numberPad
            searchBar.inputAccessoryView = searchBarAccessoryView
            return searchBar
        }()

        // MARK: LotteryView
        lotteryInfoView = {
            let view = LotteryDetailView()
            view.backgroundColor = .white
            view.isHidden = true
            let keyboardDown = UITapGestureRecognizer(target: self, action: #selector(keyboardDown))
            view.addGestureRecognizer(keyboardDown)
            return view
        }()
    }

    private func initConstraints() {
        [navigationBar, lotteryInfoView, historyTopView, historyTableView].forEach {
            view.addSubview($0)
        }
        
        [backButton, searchBar].forEach {
            navigationBar.addSubview($0)
        }
        
        navigationBar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(safeArea)
            $0.height.equalTo(44)
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

        lotteryInfoView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeArea)
            $0.top.equalTo(searchBar.snp.bottom)
            $0.height.equalTo(400)
        }

        historyTopView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeArea)
            $0.top.equalTo(searchBar.snp.bottom)
            $0.height.equalTo(60)
        }

        historyTableView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeArea)
            $0.top.equalTo(historyTopView.snp.bottom)
            $0.bottom.equalTo(safeArea)
        }
    }

}
