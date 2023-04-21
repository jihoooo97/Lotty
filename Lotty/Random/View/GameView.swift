import UIKit

final class GameView: UIView {
    
    private var gameNameLabel = UILabel()
    private let no1Label = CountLabel()
    private let no2Label = CountLabel()
    private let no3Label = CountLabel()
    private let no4Label = CountLabel()
    private let no5Label = CountLabel()
    private let no6Label = CountLabel()
    
    private var gameName: String
    
    
    init(gameName: String) {
        self.gameName = gameName
        super.init(frame: .zero)
        
        initAttributes()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func showGame() {
        [no1Label, no2Label, no3Label, no4Label, no5Label, no6Label].forEach {
            $0.isHidden = false
        }
    }
    
    func hideGame() {
        [no1Label, no2Label, no3Label, no4Label, no5Label, no6Label].forEach {
            $0.isHidden = true
        }
    }
    
    func bind(numberList: [Int]) {
        [no1Label, no2Label, no3Label, no4Label, no5Label, no6Label].enumerated().forEach {
            $0.element.configure(with: numberList[$0.offset])
            $0.element.animate()
        }
    }
    
    private func initAttributes() {
        backgroundColor = .clear
        
        gameNameLabel = UILabel().then {
            $0.text = gameName
            $0.textColor = LottyColors.G900
            $0.font = UIFont(name: "BMDoHyeon", size: 14)
        }
    }
    
    private func initConstraints() {
        [gameNameLabel, no1Label, no2Label, no3Label,
         no4Label, no5Label, no6Label].forEach {
            self.addSubview($0)
        }
        
        gameNameLabel.snp.makeConstraints {
            $0.left.top.equalToSuperview()
        }
        
        no1Label.snp.makeConstraints {
            $0.left.equalTo(gameNameLabel.snp.right).offset(25)
            $0.top.equalToSuperview()
        }
        
        no2Label.snp.makeConstraints {
            $0.left.equalTo(no1Label.snp.right).offset(40)
            $0.top.equalToSuperview()
        }
        
        no3Label.snp.makeConstraints {
            $0.left.equalTo(no2Label.snp.right).offset(40)
            $0.top.equalToSuperview()
        }
        
        no4Label.snp.makeConstraints {
            $0.left.equalTo(no3Label.snp.right).offset(40)
            $0.top.equalToSuperview()
        }
        
        no5Label.snp.makeConstraints {
            $0.left.equalTo(no4Label.snp.right).offset(40)
            $0.top.equalToSuperview()
        }
        
        no6Label.snp.makeConstraints {
            $0.left.equalTo(no5Label.snp.right).offset(40)
            $0.top.equalToSuperview()
        }
        
        self.snp.makeConstraints {
            $0.left.equalTo(gameNameLabel)
            $0.right.equalTo(no6Label)
            $0.top.bottom.equalTo(gameNameLabel)
        }
    }
    
}
