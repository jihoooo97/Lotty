import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import AVFoundation

final class RandomViewController: UIViewController, ViewController {
    
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
    let AGame = GameView()
    let BGame = GameView()
    let CGame = GameView()
    let DGame = GameView()
    let EGame = GameView()
    let bottomLine = DottedLine()

    var priceLabelTitle = UILabel()
    var priceLabel = UILabel()
    var createLotteryButton = UIButton()
    
    var safeArea = UILayoutGuide()
    
    let viewModel = RandomViewModel()
    var disposeBag = DisposeBag()
    
    var gameList: [GameView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initAttributes()
        initUI()
        inputBind()
        outputBind()
        
        setView()
    }
    
    func inputBind() {
        createLotteryButton.rx.tap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .withUnretained(self).map { $0.0 }
            .bind(onNext: {
                HapticManager.shared.hapticImpact(style: .medium)
                _ = $0.viewModel.getDrawNumber()
                $0.viewModel.getPublishDay()
                $0.viewModel.getDrawDay()
                $0.viewModel.getDueDay()
                $0.createNumber()
            }).disposed(by: disposeBag)
    }
    
    func outputBind() {
        viewModel.drawNumberRelay
            .distinctUntilChanged()
            .withUnretained(self).map { ($0.0, $0.1) }
            .bind(onNext: { (vc, drawNumber) in
                vc.drawNumberLabel.text = "제 " + drawNumber + " 회"
            }).disposed(by: disposeBag)
        
        viewModel.publishDayRelay
            .withUnretained(self).map { ($0.0, $0.1) }
            .bind(onNext: { (vc, publishDay) in
                vc.publishDayLabel.text = "발   행   일  :  " + publishDay
            }).disposed(by: disposeBag)
        
        viewModel.drawingDayRelay
            .distinctUntilChanged()
            .withUnretained(self).map { ($0.0, $0.1) }
            .bind(onNext: { (vc, drawingDay) in
                vc.drawingDayLabel.text = "추   첨   일  :  " + drawingDay
            }).disposed(by: disposeBag)
        
        viewModel.dueDayRelay
            .distinctUntilChanged()
            .withUnretained(self).map { ($0.0, $0.1) }
            .bind(onNext: { (vc, dueDay) in
                vc.dueDayLabel.text = "지 급 기 한  :  " + dueDay
            }).disposed(by: disposeBag)
        
        viewModel.lotteryNumberListRelay
            .withUnretained(self).map { ($0.0, $0.1) }
            .bind(onNext: { (vc, numberList) in
                // 순서대로 게임 보여주기
                vc.gameList.enumerated().forEach { game in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05 * Double(game.offset)) {
                        game.element.isHidden = false
                        game.element.setCount(numberList: numberList[game.offset])
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    private func setView() {
        topLine.addDashedBorder()
        bottomLine.addDashedBorder()
        
        gameList = [AGame, BGame, CGame, DGame, EGame]
        
        gameList.forEach {
            $0.isHidden = true
        }
    }
    

    
    func createNumber() {
        gameList.forEach {
            $0.isHidden = true
        }
        
        viewModel.setNumber()
    }
}


extension RandomViewController {
    
    func initAttributes() {
        view.backgroundColor = .white
        safeArea = view.safeAreaLayoutGuide
        
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
        
        AGame.gameNameLabel.text = "A 게임"
        BGame.gameNameLabel.text = "B 게임"
        CGame.gameNameLabel.text = "C 게임"
        DGame.gameNameLabel.text = "D 게임"
        EGame.gameNameLabel.text = "E 게임"
        
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
    
    func initUI() {
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
         topLine, bottomLine, AGame, BGame, CGame, DGame, EGame,
         priceLabelTitle, priceLabel, createLotteryButton]
            .forEach { containerView.addSubview($0) }
        
        backgroundLogo1.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview().offset(-20)
            $0.width.equalTo(160)
            $0.height.equalTo(80)
        }
        
        backgroundLogo2.snp.makeConstraints {
            $0.leading.equalTo(backgroundLogo1)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(160)
            $0.height.equalTo(80)
        }
        
        backgroundLogo3.snp.makeConstraints {
            $0.leading.equalTo(backgroundLogo1)
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
            $0.trailing.equalTo(titleLogo)
            $0.bottom.equalTo(titleLogo).offset(4)
            $0.width.height.equalTo(50)
        }
        
        drawNumberLabel.snp.makeConstraints {
            $0.top.equalTo(titleLogo.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        publishDayLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(42)
            $0.top.equalTo(drawNumberLabel.snp.bottom).offset(10)
        }
        
        drawingDayLabel.snp.makeConstraints {
            $0.leading.equalTo(publishDayLabel)
            $0.top.equalTo(publishDayLabel.snp.bottom).offset(2)
        }
        
        dueDayLabel.snp.makeConstraints {
            $0.leading.equalTo(publishDayLabel)
            $0.top.equalTo(drawingDayLabel.snp.bottom).offset(2)
        }
        
        topLine.snp.makeConstraints {
            $0.leading.equalTo(publishDayLabel).offset(-15)
            $0.top.equalTo(dueDayLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        AGame.snp.makeConstraints {
            $0.leading.equalTo(topLine).offset(8)
            $0.top.equalTo(topLine.snp.bottom).offset(20)
            $0.height.equalTo(20)
        }
        
        BGame.snp.makeConstraints {
            $0.leading.equalTo(AGame)
            $0.top.equalTo(AGame.snp.bottom).offset(20)
            $0.height.equalTo(20)
        }
        
        CGame.snp.makeConstraints {
            $0.leading.equalTo(AGame)
            $0.top.equalTo(BGame.snp.bottom).offset(20)
            $0.height.equalTo(20)
        }
        
        DGame.snp.makeConstraints {
            $0.leading.equalTo(AGame)
            $0.top.equalTo(CGame.snp.bottom).offset(20)
            $0.height.equalTo(20)
        }
        
        EGame.snp.makeConstraints {
            $0.leading.equalTo(AGame)
            $0.top.equalTo(DGame.snp.bottom).offset(20)
            $0.height.equalTo(20)
        }
        
        bottomLine.snp.makeConstraints {
            $0.leading.trailing.equalTo(topLine)
            $0.top.equalTo(EGame.snp.bottom).offset(20)
            $0.height.equalTo(1)
        }
        
        priceLabelTitle.snp.makeConstraints {
            $0.leading.equalTo(publishDayLabel)
            $0.top.equalTo(bottomLine).offset(20)
        }
        
        priceLabel.snp.makeConstraints {
            $0.trailing.equalTo(bottomLine)
            $0.centerY.equalTo(priceLabelTitle)
        }
        
        createLotteryButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(bottomLine)
            $0.top.equalTo(priceLabelTitle.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(60)
        }
    }
    
}
