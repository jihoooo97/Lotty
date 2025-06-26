import BaseFeature
import Core
import UIComponent

import UIKit
import RxSwift
import RxCocoa

public final class DrawViewController: BaseViewController {

    private lazy var titleLogo = UIImageView()
    private lazy var qrScanImage = UIImageView()
    private lazy var drawNoLabel = UILabel()
    private lazy var publishingDateLabel = UILabel()
    private lazy var drawnDateLabel = UILabel()
    private lazy var dueDateLabel = UILabel()
    
    private lazy var lotteryView = DrawnLotteryView()

    private lazy var priceLabelTitle = UILabel()
    private lazy var priceLabel = UILabel()
    
    private lazy var drawButton = UIButton()
    
    private let rightLine = UIView()
    
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
            .map { "발   행   일 : " + $0 }
            .asDriver(onErrorJustReturn: "발   행   일 : ----/--/-- (-) --:--:--")
            .drive(publishingDateLabel.rx.text)
            .disposed(by: bag)
        
        output.drawnDate
            .map { "추   첨   일 : " + $0 }
            .asDriver(onErrorJustReturn: "추   첨   일 : ----/--/-- (-) --:--:--")
            .drive(drawnDateLabel.rx.text)
            .disposed(by: bag)
        
        output.dueDate
            .map { "지 급 기 한 : " + $0 }
            .asDriver(onErrorJustReturn: "지 급 기 한 : ----/--/--")
            .drive { [weak self] dueDate in
                self?.dueDateLabel.text = dueDate
            }.disposed(by: bag)
        
        output.winNoList
            .asDriver(onErrorJustReturn: [])
            .drive { [weak self] winNoList in
                self?.lotteryView.drawLottery(with: winNoList)
            }.disposed(by: bag)
    }
    
    public override func setUIProperty() {
        titleLogo = {
            let imageView = UIImageView()
            imageView.image = UIComponentAsset.logoMain.image.withRenderingMode(.alwaysOriginal)
            return imageView
        }()
        
        qrScanImage = {
            let imageView = UIImageView()
            imageView.image = .init(systemName: "qrcode")
            imageView.tintColor = .label
            imageView.contentMode = .scaleAspectFit
            imageView.preferredSymbolConfiguration = .init(font: .monospacedSystemFont(ofSize: 18.0, weight: .semibold))
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
            label.text = "발   행   일 : ----/--/-- (-) --:--:--"
            label.font = .systemFont(ofSize: 16.0, weight: .bold)
            return label
        }()
        
        drawnDateLabel = {
            let label = UILabel()
            label.text = "추   첨   일 : ----/--/-- (-) --:--:--"
            label.font = .systemFont(ofSize: 16.0, weight: .bold)
            return label
        }()
        
        dueDateLabel = {
            let label = UILabel()
            label.text = "지 급 기 한 : ----/--/--"
            label.font = .systemFont(ofSize: 16.0, weight: .bold)
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
            let title = NSAttributedString(
                string: "번호생성",
                attributes: [
                    .font: UIFont.monospacedSystemFont(ofSize: 18.0, weight: .semibold),
                    .foregroundColor: UIComponentAsset.accentColor.color
                ]
            )
            button.configuration?.attributedTitle = AttributedString(title)
            button.backgroundColor = .systemBackground
            button.border(.systemBackground, width: 1, radius: 16)
            button.applyShadow(y: 0.5)
            return button
        }()
        
        rightLine.backgroundColor = UIComponentAsset.accentColor.color.withAlphaComponent(0.5)
    }
    
    public override func setLayout() {
        let leftIcon1 = UIImageView(image: UIComponentAsset.iconLomin.image)
        leftIcon1.tintColor = UIComponentAsset.accentColor.color.withAlphaComponent(0.5)
        let leftIcon2 = UIImageView(image: UIComponentAsset.iconLomin.image)
        leftIcon2.tintColor = UIComponentAsset.accentColor.color.withAlphaComponent(0.5)
        let leftIcon3 = UIImageView(image: UIComponentAsset.iconLomin.image)
        leftIcon3.tintColor = UIComponentAsset.accentColor.color.withAlphaComponent(0.5)
        
        view.addSubviews(
            leftIcon1, leftIcon2, leftIcon3, rightLine,
            titleLogo, qrScanImage, drawNoLabel,
            publishingDateLabel, drawnDateLabel, dueDateLabel,
            lotteryView,
            priceLabelTitle, priceLabel, drawButton
        )
        
        titleLogo.snp.makeConstraints { make in
            make.top.equalTo(safeArea)
            make.centerX.equalTo(safeArea)
            make.width.equalTo(titleLogo.snp.height).multipliedBy(2)
            make.height.equalTo(90)
        }
        
        qrScanImage.snp.makeConstraints { make in
            make.left.equalTo(titleLogo.snp.right)
            make.bottom.equalTo(titleLogo)
            make.size.equalTo(60)
        }
        
        drawNoLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLogo.snp.bottom).offset(20)
            make.centerX.equalTo(safeArea)
        }
        
        publishingDateLabel.snp.makeConstraints { make in
            make.left.equalTo(safeArea).offset(42)
            make.top.equalTo(drawNoLabel.snp.bottom).offset(10)
        }
        
        drawnDateLabel.snp.makeConstraints { make in
            make.left.equalTo(publishingDateLabel)
            make.top.equalTo(publishingDateLabel.snp.bottom).offset(4)
        }
        
        dueDateLabel.snp.makeConstraints { make in
            make.left.equalTo(publishingDateLabel)
            make.top.equalTo(drawnDateLabel.snp.bottom).offset(4)
        }
        
        lotteryView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(safeArea).multipliedBy(0.8)
            make.top.equalTo(dueDateLabel.snp.bottom).offset(12)
        }
        
        priceLabelTitle.snp.makeConstraints { make in
            make.left.equalTo(lotteryView).inset(8)
            make.top.equalTo(lotteryView.snp.bottom).offset(20)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.right.equalTo(lotteryView).inset(8)
            make.centerY.equalTo(priceLabelTitle)
        }
        
        drawButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(lotteryView)
            make.top.equalTo(priceLabel.snp.bottom).offset(40)
            make.height.equalTo(60)
        }
        
        leftIcon1.snp.makeConstraints { make in
            make.left.top.equalTo(safeArea)
            make.width.equalTo(160)
            make.height.equalTo(100)
        }
        
        leftIcon2.snp.makeConstraints { make in
            make.left.centerY.equalTo(safeArea)
            make.width.equalTo(160)
            make.height.equalTo(100)
        }
        
        leftIcon3.snp.makeConstraints { make in
            make.left.bottom.equalTo(safeArea)
            make.width.equalTo(160)
            make.height.equalTo(100)
        }
        
        rightLine.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(8)
            make.verticalEdges.equalToSuperview()
            make.width.equalTo(30)
        }
    }

}
