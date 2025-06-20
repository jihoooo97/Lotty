import BaseFeature
import Core
import UIComponent

import UIKit
import RxSwift
import RxCocoa

public final class DrawViewController: BaseViewController {

    private lazy var titleLabel = UILabel()
    private lazy var qrScanImage = UIImageView()
    private lazy var drawNoLabel = UILabel()
    private lazy var publishingDateLabel = UILabel()
    private lazy var drawnDateLabel = UILabel()
    private lazy var dueDateLabel = UILabel()
    
//    private let topLine = DottedLine()
//    private let bottomLine = DottedLine()
//    private lazy var gameListView = GameListView()

    private lazy var priceLabelTitle = UILabel()
    private lazy var priceLabel = UILabel()
    
    private let fortuneLabel = UILabel()
    private lazy var drawButton = UIButton()
    
    private let fortuneMent = ["당첨 예감!", "좋은 꿈 꾸셨나봐요?", "느낌이 좋은데요?", "대박 느낌!"]
    
    private let viewModel: DrawViewModel
    
    public init(viewModel: DrawViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    
    private func bindViewModel() {
        let input = DrawViewModel.Input(
            drawButtonDidTap: drawButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(from: input)
        
        output.drawNo
            .map { "제 \($0) 회" }
            .asDriver(onErrorJustReturn: "제 ---- 회")
            .drive(drawNoLabel.rx.text)
            .disposed(by: bag)
        
        output.publishingDate
            .map { "발  행  일 : " + $0 }
            .asDriver(onErrorJustReturn: "발  행  일 : ----/--/-- (-) --:--:--")
            .drive(publishingDateLabel.rx.text)
            .disposed(by: bag)
        
        output.drawnDate
            .map { "추  첨  일 : " + $0 }
            .asDriver(onErrorJustReturn: "추  첨  일 : ----/--/-- (-) --:--:--")
            .drive(drawnDateLabel.rx.text)
            .disposed(by: bag)
        
        output.dueDate
            .map { "지 급 기 한 : " + $0 }
            .asDriver(onErrorJustReturn: "지 급 기 한 : ----/--/--")
            .drive { [weak self] dueDate in
                self?.dueDateLabel.text = dueDate
                self?.fortuneLabel.text = self?.fortuneMent.randomElement()
            }.disposed(by: bag)
    }
    
    public override func setUIProperty() {
        titleLabel = {
            let label = UILabel()
            label.text = "추첨하기"
            return label
        }()
        
        qrScanImage = {
            let imageView = UIImageView()
            imageView.image = .init(systemName: "globe")
//            imageView.image = LottyIcons.qr
//            imageView.tintColor = LottyColors.G900
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        drawNoLabel = {
            let label = UILabel()
            label.text = "제 ---- 회"
            label.font = .systemFont(ofSize: 22.0, weight: .bold)
            label.textAlignment = .center
            return label
        }()
        
        publishingDateLabel = {
            let label = UILabel()
            label.text = "발  행  일 : ----/--/-- (-) --:--:--"
            label.font = .systemFont(ofSize: 16.0, weight: .semibold)
            return label
        }()
        
        drawnDateLabel = {
            let label = UILabel()
            label.text = "추  첨  일 : ----/--/-- (-) --:--:--"
            label.font = .systemFont(ofSize: 16.0, weight: .semibold)
            return label
        }()
        
        dueDateLabel = {
            let label = UILabel()
            label.text = "지 급 기 한 : ----/--/--"
            label.font = .systemFont(ofSize: 16.0, weight: .semibold)
            return label
        }()
        
        priceLabelTitle = {
            let label = UILabel()
            label.text = "금 액"
            label.font = .monospacedSystemFont(ofSize: 18.0, weight: .bold)
            return label
        }()
        
        priceLabel = {
            let label = UILabel()
            label.text = "₩5,000"
            label.font = .monospacedSystemFont(ofSize: 18.0, weight: .bold)
            label.textAlignment = .right
            return label
        }()
        
        drawButton = {
            let button = UIButton()
            button.configuration = .plain()
            button.configuration?.title = "번호 생성"
            button.titleLabel?.font = .monospacedSystemFont(ofSize: 18.0, weight: .semibold)
            button.backgroundColor = .systemBackground
            button.layer.cornerRadius = 16
            button.border(.systemBackground, width: 1, radius: 16)
            button.applyShadow(y: 0.5)
            return button
        }()
    }
    
    public override func setLayout() {
        view.addSubviews(
            titleLabel, qrScanImage, drawNoLabel,
            publishingDateLabel, drawnDateLabel, dueDateLabel,
//            topLine, bottomLine, gameListView,
            priceLabelTitle, priceLabel,
            fortuneLabel, drawButton
        )
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(20)
            $0.centerX.equalTo(safeArea)
//            $0.width.equalTo(250)
//            $0.height.equalTo(80)
        }
        
        qrScanImage.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.right)
            $0.centerY.equalTo(titleLabel)
            $0.width.height.equalTo(50)
        }
        
        drawNoLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.centerX.equalTo(safeArea)
        }
        
        publishingDateLabel.snp.makeConstraints {
            $0.left.equalTo(safeArea).offset(42)
            $0.top.equalTo(drawNoLabel.snp.bottom).offset(10)
        }
        
        drawnDateLabel.snp.makeConstraints {
            $0.left.equalTo(publishingDateLabel)
            $0.top.equalTo(publishingDateLabel.snp.bottom).offset(2)
        }
        
        dueDateLabel.snp.makeConstraints {
            $0.left.equalTo(publishingDateLabel)
            $0.top.equalTo(drawnDateLabel.snp.bottom).offset(2)
        }
        
//        topLine.snp.makeConstraints {
//            $0.left.equalTo(publishDayLabel).offset(-15)
//            $0.top.equalTo(dueDayLabel.snp.bottom).offset(20)
//            $0.centerX.equalToSuperview()
//            $0.height.equalTo(1)
//        }
//        
//        gameListView.snp.makeConstraints {
//            $0.left.equalTo(topLine)
//            $0.right.equalTo(topLine)
//            $0.top.equalTo(topLine.snp.bottom).offset(20)
//        }
//        
//        bottomLine.snp.makeConstraints {
//            $0.left.right.equalTo(topLine)
//            $0.top.equalTo(gameListView.snp.bottom).offset(20)
//            $0.height.equalTo(1)
//        }
        
        priceLabelTitle.snp.makeConstraints {
            $0.left.equalTo(publishingDateLabel)
            $0.top.equalTo(dueDateLabel.snp.bottom).offset(20)
        }
        
        priceLabel.snp.makeConstraints {
            $0.right.equalTo(dueDateLabel)
            $0.centerY.equalTo(priceLabelTitle)
        }
        
        fortuneLabel.snp.makeConstraints { make in
            make.centerX.equalTo(safeArea)
            make.top.equalTo(priceLabelTitle.snp.bottom).offset(40)
        }
        
        drawButton.snp.makeConstraints {
            $0.left.right.equalTo(dueDateLabel)
            $0.top.equalTo(fortuneLabel.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(60)
        }
    }

}
