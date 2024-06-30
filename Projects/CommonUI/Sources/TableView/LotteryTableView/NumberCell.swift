import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Domain

public final class NumberCell: UITableViewCell {
    
    public static let cellId = "numberCell"
    
    // MARK: 날짜
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = LottyColors.G600
        label.font = LottyFonts.regular(size: 15)
        return label
    }()
    
    // MARK: 로또 번호 뷰
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = LottyColors.G900
        label.font = LottyFonts.medium(size: 15)
        label.text = "당첨번호"
        return label
    }()
    
    let drwNoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let no1Label = LotteryLabel()
    let no2Label = LotteryLabel()
    let no3Label = LotteryLabel()
    let no4Label = LotteryLabel()
    let no5Label = LotteryLabel()
    let no6Label = LotteryLabel()
    let bonusNoLabel = LotteryLabel()
    
    let plusImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = LottyIcons.plus
        imageView.tintColor = LottyColors.G600
        return imageView
    }()
    
    // MARK: 당첨금 뷰
    let medalImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = LottyIcons.medal
        return imageView
    }()

    let winCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = LottyColors.G900
        label.font = LottyFonts.yeonsung(size: 16)
        return label
    }()
    
    let winAmountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = LottyColors.B500
        label.font = LottyFonts.dohyeon(size: 24)
        return label
    }()
    
    let topIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = LottyColors.G400
        return view
    }()
    
    let detailButton: UIButton = {
        let button = UIButton()
        button.setTitle("자세히 보기", for: .normal)
        button.setTitleColor(LottyColors.G600, for: .normal)
        button.titleLabel?.font = LottyFonts.semiBold(size: 13)
        return button
    }()
    
    let bottomIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = LottyColors.G400
        return view
    }()
    
    var disposeBag = DisposeBag()
    
    public var detailButtonHandler: (() -> Void)?
    
    // MARK: - 메소드
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initUI()
        inputBind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        self.backgroundColor = .white
        contentView.backgroundColor = .white
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
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
    
    public func setData(lottery: Lottery) {
        dateLabel.text = lottery.drawNumberDate
        no1Label.lotteryNo = lottery.drawNo1
        no2Label.lotteryNo = lottery.drawNo2
        no3Label.lotteryNo = lottery.drawNo3
        no4Label.lotteryNo = lottery.drawNo4
        no5Label.lotteryNo = lottery.drawNo5
        no6Label.lotteryNo = lottery.drawNo6
        bonusNoLabel.lotteryNo = lottery.bonusNo
        winCountLabel.text = "총 \(lottery.winnerCount)명 당첨"
        winAmountLabel.text = lottery.winnerPrizeAmount + "원"
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
