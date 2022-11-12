import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class NumberCell: UITableViewCell {
    
//    @IBOutlet weak var date: UILabel!
//    @IBOutlet weak var no1: UILabel!
//    @IBOutlet weak var no2: UILabel!
//    @IBOutlet weak var no3: UILabel!
//    @IBOutlet weak var no4: UILabel!
//    @IBOutlet weak var no5: UILabel!
//    @IBOutlet weak var no6: UILabel!
//    @IBOutlet weak var bonusNo: UILabel!
//    @IBOutlet weak var winCount: UILabel!
//    @IBOutlet weak var winAmount: UILabel!
//    @IBOutlet weak var detailButton: UIButton!
    
    static let cellId = "numberCell"
    
    // MARK: 날짜
    var dateLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = LottyColors.G600
        $0.font = LottyFonts.regular(size: 15)
    }
    
    // MARK: 로또 번호 뷰
    var titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = LottyColors.G900
        $0.font = LottyFonts.medium(size: 15)
        $0.text = "당첨번호"
    }
    
    var drwNoContainerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    var no1Label = LotteryLabel()
    var no2Label = LotteryLabel()
    var no3Label = LotteryLabel()
    var no4Label = LotteryLabel()
    var no5Label = LotteryLabel()
    var no6Label = LotteryLabel()
    var bonusNoLabel = LotteryLabel()
    
    var plusImage = UIImageView().then {
        $0.image = LottyIcons.plus
        $0.tintColor = LottyColors.G600
    }
    
    // MARK: 당첨금 뷰
    var medalImage = UIImageView().then {
        $0.image = LottyIcons.medal
    }

    var winCountLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = LottyColors.G900
        $0.font = LottyFonts.yeonsung(size: 16)
    }
    
    var winAmountLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = LottyColors.B500
        $0.font = LottyFonts.dohyeon(size: 24)
    }
    
    var topIndicator = UIView().then {
        $0.backgroundColor = LottyColors.G400
    }
    
    var detailButton = UIButton().then {
        $0.setTitle("자세히 보기", for: .normal)
        $0.setTitleColor(LottyColors.G600, for: .normal)
        $0.titleLabel?.font = LottyFonts.semiBold(size: 13)
    }
    
    var bottomIndicator = UIView().then {
        $0.backgroundColor = LottyColors.G400
    }
    
    var disposeBag = DisposeBag()
    
    var detailButtonHandler: (() -> Void)?
    
    // MARK: - 메소드
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initUI()
        inputBind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        self.backgroundColor = .white
        contentView.backgroundColor = .white
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.backgroundColor = .white
        contentView.backgroundColor = .white
    }
    
    func inputBind() {
        detailButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                self?.detailButtonHandler?()
            }).disposed(by: disposeBag)
    }
    
    func setData(lottery: LotteryItem) {
        dateLabel.text = lottery.lottery.drwNoDate
        no1Label.lotteryNo = lottery.lottery.drwtNo1
        no2Label.lotteryNo = lottery.lottery.drwtNo2
        no3Label.lotteryNo = lottery.lottery.drwtNo3
        no4Label.lotteryNo = lottery.lottery.drwtNo4
        no5Label.lotteryNo = lottery.lottery.drwtNo5
        no6Label.lotteryNo = lottery.lottery.drwtNo6
        bonusNoLabel.lotteryNo = lottery.lottery.bnusNo
        winCountLabel.text = "총 \(lottery.lottery.firstPrzwnerCo)명 당첨"
        winAmountLabel.text = lottery.lottery.firstWinamnt.numberFormatter() + "원"
    }
    
    private func initUI() {
        self.backgroundColor = .white
        self.selectionStyle = .none
        
        [dateLabel, titleLabel, drwNoContainerView,
         no1Label, no2Label, no3Label, no4Label,
         no5Label, no6Label, plusImage, bonusNoLabel,
         medalImage, winCountLabel, winAmountLabel,
         detailButton, topIndicator, bottomIndicator]
            .forEach { contentView.addSubview($0) }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(10)
            $0.centerX.equalTo(dateLabel)
        }
        
        drwNoContainerView.snp.makeConstraints {
            $0.leading.equalTo(no1Label)
            $0.trailing.equalTo(bonusNoLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(36)
        }
        
        no1Label.snp.makeConstraints {
            $0.centerY.equalTo(drwNoContainerView)
            $0.width.height.equalTo(36)
        }
        
        no2Label.snp.makeConstraints {
            $0.leading.equalTo(no1Label.snp.trailing).offset(5)
            $0.centerY.equalTo(drwNoContainerView)
            $0.width.height.equalTo(36)
        }
        
        no3Label.snp.makeConstraints {
            $0.leading.equalTo(no2Label.snp.trailing).offset(5)
            $0.centerY.equalTo(drwNoContainerView)
            $0.width.height.equalTo(36)
        }
        
        no4Label.snp.makeConstraints {
            $0.leading.equalTo(no3Label.snp.trailing).offset(5)
            $0.centerY.equalTo(drwNoContainerView)
            $0.width.height.equalTo(36)
        }
        
        no5Label.snp.makeConstraints {
            $0.leading.equalTo(no4Label.snp.trailing).offset(5)
            $0.centerY.equalTo(drwNoContainerView)
            $0.width.height.equalTo(36)
        }
        
        no6Label.snp.makeConstraints {
            $0.leading.equalTo(no5Label.snp.trailing).offset(5)
            $0.centerY.equalTo(drwNoContainerView)
            $0.width.height.equalTo(36)
        }
        
        plusImage.snp.makeConstraints {
            $0.leading.equalTo(no6Label.snp.trailing).offset(5)
            $0.centerY.equalTo(drwNoContainerView)
            $0.width.height.equalTo(20)
        }
        
        bonusNoLabel.snp.makeConstraints {
            $0.leading.equalTo(plusImage.snp.trailing).offset(5)
            $0.centerY.equalTo(drwNoContainerView)
            $0.width.height.equalTo(36)
        }
        
        medalImage.snp.makeConstraints {
            $0.trailing.equalTo(winCountLabel.snp.leading).offset(-4)
            $0.centerY.equalTo(winCountLabel)
            $0.width.height.equalTo(20)
        }
        
        winCountLabel.snp.makeConstraints {
            $0.top.equalTo(drwNoContainerView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        winAmountLabel.snp.makeConstraints {
            $0.top.equalTo(winCountLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        topIndicator.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomIndicator).offset(-40)
            $0.height.equalTo(0.3)
        }
        
        detailButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(topIndicator)
            $0.bottom.equalTo(bottomIndicator)
        }
        
        bottomIndicator.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(0.3)
        }
    }
    
}
