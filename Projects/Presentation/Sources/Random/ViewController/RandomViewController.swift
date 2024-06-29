import Common
import CommonUI
import UIKit
import RxSwift
import AVFoundation

public final class RandomViewController: BaseViewController {
    
    private let viewModel: RandomViewModel
    
    public init(viewModel: RandomViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    
    private lazy var scrollView = UIScrollView()
    private lazy var containerView = UIView()
    private lazy var backgroundLogo1 = UIImageView()
    private lazy var backgroundLogo2 = UIImageView()
    private lazy var backgroundLogo3 = UIImageView()
    let rightLine = RightLine()
    
    private lazy var titleLogo = UIImageView()
    private lazy var qrScanImage = UIImageView()
    private lazy var drawNumberLabel = UILabel()
    private lazy var publishDayLabel = UILabel()
    private lazy var drawingDayLabel = UILabel()
    private lazy var dueDayLabel = UILabel()
    
    private let topLine = DottedLine()
    private let bottomLine = DottedLine()
    private lazy var gameListView = GameListView()

    private lazy var priceLabelTitle = UILabel()
    private lazy var priceLabel = UILabel()
    private lazy var createLotteryButton = UIButton()
        
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        initAttributes()
        initUI()
        inputBind()
        outputBind()
    }
    
    
    private func inputBind() {
        createLotteryButton.rx.tap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .withUnretained(self).map { $0.0 }
            .bind { vc in
                HapticManager.shared.hapticImpact(style: .medium)
                vc.viewModel.tapCreateLotteryButtonRelay.accept(())
            }
            .disposed(by: disposeBag)
    }
    
    private func outputBind() {
        viewModel.gameRelay
            .withUnretained(self).map { $0 }
            .bind { vc, game in
                vc.drawNumberLabel.text = "제 " + "\(game.turn)" + " 회"
                vc.publishDayLabel.text = "발   행   일  :  " + game.publishDay
                vc.drawingDayLabel.text = "추   첨   일  :  " + game.drawingDay
                vc.dueDayLabel.text = "지 급 기 한  :  " + game.dueDay
                vc.gameListView.setGame(numberList: game.numberList)
            }
            .disposed(by: disposeBag)
    }
}


extension RandomViewController {
    
    private func initAttributes() {
        scrollView = {
            let scrollView = UIScrollView()
            scrollView.layer.masksToBounds = false
            scrollView.backgroundColor = .white
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            return scrollView
        }()
        
        containerView = {
            let view = UIView()
            view.layer.masksToBounds = false
            view.backgroundColor = .white
            return view
        }()
        
        backgroundLogo1 = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "lomin_icon")!
            imageView.tintColor = LottyColors.AlphaB600
            imageView.contentMode = .scaleAspectFill
            return imageView
        }()
        
        backgroundLogo2 = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "lomin_icon")!
            imageView.tintColor = LottyColors.AlphaB600
            imageView.contentMode = .scaleAspectFill
            return imageView
        }()
        
        backgroundLogo3 = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "lomin_icon")!
            imageView.tintColor = LottyColors.AlphaB600
            imageView.contentMode = .scaleAspectFill
            return imageView
        }()
        
        titleLogo = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "splash_lomin")!
            imageView.contentMode = .scaleAspectFill
            return imageView
        }()
        
        qrScanImage = {
            let imageView = UIImageView()
            imageView.image = LottyIcons.qr
            imageView.tintColor = LottyColors.G900
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        drawNumberLabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.textColor = LottyColors.G900
            label.font = LottyFonts.dohyeon(size: 20)
            label.text = "제 ---- 회"
            return label
        }()
        
        publishDayLabel = {
            let label = UILabel()
            label.textAlignment = .left
            label.textColor = LottyColors.G900
            label.font = LottyFonts.dohyeon(size: 15)
            label.text = "발   행   일  :  ----/--/-- (-) --:--:--"
            return label
        }()
        
        drawingDayLabel = {
            let label = UILabel()
            label.textAlignment = .left
            label.textColor = LottyColors.G900
            label.font = LottyFonts.dohyeon(size: 15)
            label.text = "추   첨   일  :  ----/--/-- (-) --:--:--"
            return label
        }()
        
        dueDayLabel = {
            let label = UILabel()
            label.textAlignment = .left
            label.textColor = LottyColors.G900
            label.font = LottyFonts.dohyeon(size: 15)
            label.text = "지 급 기 한  :  ----/--/--"
            return label
        }()
        
        priceLabelTitle = {
            let label = UILabel()
            label.textAlignment = .left
            label.textColor = LottyColors.G900
            label.font = LottyFonts.dohyeon(size: 17)
            label.text = "금 액"
            return label
        }()
        
        priceLabel = {
            let label = UILabel()
            label.textAlignment = .right
            label.textColor = LottyColors.G900
            label.font = LottyFonts.dohyeon(size: 17)
            label.text = "₩5,000"
            return label
        }()
        
        createLotteryButton = {
            let button = UIButton()
            button.setTitle("번호 생성", for: .normal)
            button.setTitleColor(LottyColors.B600, for: .normal)
            button.titleLabel?.font = LottyFonts.bold(size: 15)
            button.backgroundColor = .white
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.cornerRadius = 4
            button.layer.masksToBounds = false
            button.layer.cornerRadius = 4
            button.layer.applyShadow(x: 0, y: 0.5,
                                 alpha: 0.4, blur: 2)
            return button
        }()
    }
    
    private func initUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
            $0.height.greaterThanOrEqualToSuperview()
        }
        
        [backgroundLogo1, backgroundLogo2, backgroundLogo3,
         rightLine, titleLogo, qrScanImage,drawNumberLabel,
         publishDayLabel, drawingDayLabel, dueDayLabel,
         topLine, bottomLine, gameListView,
         priceLabelTitle, priceLabel, createLotteryButton]
            .forEach { containerView.addSubview($0) }
        
        backgroundLogo1.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.equalToSuperview().offset(-20)
            $0.width.equalTo(160)
            $0.height.equalTo(80)
        }
        
        backgroundLogo2.snp.makeConstraints {
            $0.left.equalTo(backgroundLogo1)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(160)
            $0.height.equalTo(80)
        }
        
        backgroundLogo3.snp.makeConstraints {
            $0.left.equalTo(backgroundLogo1)
            $0.bottom.equalToSuperview().offset(-30)
            $0.width.equalTo(160)
            $0.height.equalTo(80)
        }
        
        rightLine.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.trailing).offset(-13)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(view.snp.height)
            $0.height.equalTo(25)
        }
        
        titleLogo.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(250)
            $0.height.equalTo(80)
        }
        
        qrScanImage.snp.makeConstraints {
            $0.right.equalTo(titleLogo)
            $0.bottom.equalTo(titleLogo).offset(4)
            $0.width.height.equalTo(50)
        }
        
        drawNumberLabel.snp.makeConstraints {
            $0.top.equalTo(titleLogo.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        publishDayLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(42)
            $0.top.equalTo(drawNumberLabel.snp.bottom).offset(10)
        }
        
        drawingDayLabel.snp.makeConstraints {
            $0.left.equalTo(publishDayLabel)
            $0.top.equalTo(publishDayLabel.snp.bottom).offset(2)
        }
        
        dueDayLabel.snp.makeConstraints {
            $0.left.equalTo(publishDayLabel)
            $0.top.equalTo(drawingDayLabel.snp.bottom).offset(2)
        }
        
        topLine.snp.makeConstraints {
            $0.left.equalTo(publishDayLabel).offset(-15)
            $0.top.equalTo(dueDayLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        gameListView.snp.makeConstraints {
            $0.left.equalTo(topLine)
            $0.right.equalTo(topLine)
            $0.top.equalTo(topLine.snp.bottom).offset(20)
        }
        
        bottomLine.snp.makeConstraints {
            $0.left.right.equalTo(topLine)
            $0.top.equalTo(gameListView.snp.bottom).offset(20)
            $0.height.equalTo(1)
        }
        
        priceLabelTitle.snp.makeConstraints {
            $0.left.equalTo(publishDayLabel)
            $0.top.equalTo(bottomLine).offset(20)
        }
        
        priceLabel.snp.makeConstraints {
            $0.right.equalTo(bottomLine)
            $0.centerY.equalTo(priceLabelTitle)
        }
        
        createLotteryButton.snp.makeConstraints {
            $0.left.right.equalTo(bottomLine)
            $0.top.equalTo(priceLabelTitle.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(60)
        }
    }
    
}
