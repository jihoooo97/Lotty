import UIKit
import SnapKit
import Then

final class GameView: UIView {
    
    let gameNameLabel = UILabel().then {
        $0.sizeToFit()
        $0.text = "A 게임"
        $0.textColor = LottyColors.G900
        $0.font = UIFont(name: "BMDoHyeon", size: 14)
    }
    
    let no1Label = CountLabel().then {
        $0.sizeToFit()
        $0.text = "45"
        $0.textColor = LottyColors.G900
        $0.font = UIFont(name: "BMDoHyeon", size: 13)
    }
    
    let no2Label = CountLabel().then {
        $0.sizeToFit()
        $0.text = "45"
        $0.textColor = LottyColors.G900
        $0.font = UIFont(name: "BMDoHyeon", size: 13)
    }
    
    let no3Label = CountLabel().then {
        $0.sizeToFit()
        $0.text = "45"
        $0.textColor = LottyColors.G900
        $0.font = UIFont(name: "BMDoHyeon", size: 13)
    }
    
    let no4Label = CountLabel().then {
        $0.sizeToFit()
        $0.text = "45"
        $0.textColor = LottyColors.G900
        $0.font = UIFont(name: "BMDoHyeon", size: 13)
    }
    
    let no5Label = CountLabel().then {
        $0.sizeToFit()
        $0.text = "45"
        $0.textColor = LottyColors.G900
        $0.font = UIFont(name: "BMDoHyeon", size: 13)
    }
    
    let no6Label = CountLabel().then {
        $0.sizeToFit()
        $0.text = "45"
        $0.textColor = LottyColors.G900
        $0.font = UIFont(name: "BMDoHyeon", size: 13)
    }
    
    let bonusNoLabel = CountLabel().then {
        $0.sizeToFit()
        $0.text = "45"
        $0.textColor = LottyColors.G900
        $0.font = UIFont(name: "BMDoHyeon", size: 13)
    }
    
    var noList: [CountLabel] = []
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setCount(numberList: [Int]) {
        noList.enumerated().forEach {
            $0.element.configure(with: numberList[$0.offset])
            $0.element.animate()
        }
    }
    
    func initUI() {
        backgroundColor = .clear
        frame = CGRect(x: 0, y: 0, width: 50, height: 20)
        
        noList = [no1Label, no2Label, no3Label,
                  no4Label, no5Label, no6Label, bonusNoLabel]
        
        [gameNameLabel, no1Label, no2Label, no3Label,
         no4Label, no5Label, no6Label, bonusNoLabel]
            .forEach { self.addSubview($0) }
        
        gameNameLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
        
        no1Label.snp.makeConstraints {
            $0.leading.equalTo(gameNameLabel.snp.trailing).offset(25)
            $0.centerY.equalToSuperview()
        }
        
        no2Label.snp.makeConstraints {
            $0.leading.equalTo(no1Label.snp.trailing).offset(35)
            $0.centerY.equalToSuperview()
        }
        
        no3Label.snp.makeConstraints {
            $0.leading.equalTo(no2Label.snp.trailing).offset(35)
            $0.centerY.equalToSuperview()
        }
        
        no4Label.snp.makeConstraints {
            $0.leading.equalTo(no3Label.snp.trailing).offset(35)
            $0.centerY.equalToSuperview()
        }
        
        no5Label.snp.makeConstraints {
            $0.leading.equalTo(no4Label.snp.trailing).offset(35)
            $0.centerY.equalToSuperview()
        }
        
        no6Label.snp.makeConstraints {
            $0.leading.equalTo(no5Label.snp.trailing).offset(35)
            $0.centerY.equalToSuperview()
        }
        
        bonusNoLabel.snp.makeConstraints {
            $0.leading.equalTo(no6Label.snp.trailing).offset(35)
            $0.centerY.equalToSuperview()
        }
    }
    
}
