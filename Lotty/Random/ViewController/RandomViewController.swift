import UIKit
import RxSwift
import RxCocoa
import AVFoundation

final class RandomViewController: UIViewController {
    
    weak var coordinator: RandomCoordinator?
    private let viewModel: RandomViewModel
    private var disposeBag = DisposeBag()
    
    init(viewModel: RandomViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var scrollView = UIScrollView()
    var containerView = UIView()
    var backgroundLogo1 = UIImageView()
    var backgroundLogo2 = UIImageView()
    var backgroundLogo3 = UIImageView()
    let rightLine = RightLine()
    
    var titleLogo = UIImageView()
    var qrScanImage = UIImageView()
    var drawNumberLabel = UILabel()
    var publishDayLabel = UILabel()
    var drawingDayLabel = UILabel()
    var dueDayLabel = UILabel()
    
    let topLine = DottedLine()
    let bottomLine = DottedLine()
    private var gameListView = GameListView()

    var priceLabelTitle = UILabel()
    var priceLabel = UILabel()
    var createLotteryButton = UIButton()
        
    
    override func viewDidLoad() {
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
        scrollView = UIScrollView().then {
            $0.layer.masksToBounds = false
            $0.backgroundColor = .white
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
        }
        
        containerView = UIView().then {
            $0.layer.masksToBounds = false
            $0.backgroundColor = .white
        }
        
        backgroundLogo1 = UIImageView().then {
            $0.image = UIImage(named: "lomin_icon")!
            $0.tintColor = LottyColors.AlphaB600
            $0.contentMode = .scaleAspectFill
        }
        
        backgroundLogo2 = UIImageView().then {
            $0.image = UIImage(named: "lomin_icon")!
            $0.tintColor = LottyColors.AlphaB600
            $0.contentMode = .scaleAspectFill
        }
        
        backgroundLogo3 = UIImageView().then {
            $0.image = UIImage(named: "lomin_icon")!
            $0.tintColor = LottyColors.AlphaB600
            $0.contentMode = .scaleAspectFill
        }
        
        titleLogo = UIImageView().then {
            $0.image = UIImage(named: "splash_lomin")!
            $0.contentMode = .scaleAspectFill
        }
        
        qrScanImage = UIImageView().then {
            $0.image = LottyIcons.qr
            $0.tintColor = LottyColors.G900
            $0.contentMode = .scaleAspectFit
        }
        
        drawNumberLabel = UILabel().then {
            $0.textAlignment = .center
            $0.textColor = LottyColors.G900
            $0.font = LottyFonts.dohyeon(size: 20)
            $0.text = "제 ---- 회"
        }
        
        publishDayLabel = UILabel().then {
            $0.textAlignment = .left
            $0.textColor = LottyColors.G900
            $0.font = LottyFonts.dohyeon(size: 15)
            $0.text = "발   행   일  :  ----/--/-- (-) --:--:--"
        }
        
        drawingDayLabel = UILabel().then {
            $0.textAlignment = .left
            $0.textColor = LottyColors.G900
            $0.font = LottyFonts.dohyeon(size: 15)
            $0.text = "추   첨   일  :  ----/--/-- (-) --:--:--"
        }
        
        dueDayLabel = UILabel().then {
            $0.textAlignment = .left
            $0.textColor = LottyColors.G900
            $0.font = LottyFonts.dohyeon(size: 15)
            $0.text = "지 급 기 한  :  ----/--/--"
        }
        
        priceLabelTitle = UILabel().then {
            $0.textAlignment = .left
            $0.textColor = LottyColors.G900
            $0.font = LottyFonts.dohyeon(size: 17)
            $0.text = "금 액"
        }
        
        priceLabel = UILabel().then {
            $0.textAlignment = .right
            $0.textColor = LottyColors.G900
            $0.font = LottyFonts.dohyeon(size: 17)
            $0.text = "₩5,000"
        }
        
        createLotteryButton = UIButton().then {
            $0.setTitle("번호 생성", for: .normal)
            $0.setTitleColor(LottyColors.B600, for: .normal)
            $0.titleLabel?.font = LottyFonts.bold(size: 15)
            $0.backgroundColor = .white
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.cornerRadius = 4
            $0.layer.masksToBounds = false
            $0.layer.cornerRadius = 4
            $0.layer.applyShadow(x: 0, y: 0.5,
                                 alpha: 0.4, blur: 2)
        }
    }
    
    private func initUI() {
//        let safeArea = view.safeAreaLayoutGuide
        
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
