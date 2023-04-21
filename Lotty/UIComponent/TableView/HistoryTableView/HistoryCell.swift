import UIKit
import SnapKit
import Then
import RxSwift

final class HistoryCell: UITableViewCell {
    
    static let cellId = "historyCell"
            
    var clockImage = UIImageView().then {
        $0.image = LottyIcons.clock
        $0.tintColor = LottyColors.G900
    }
    
    var drwNo = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = LottyColors.G900
        $0.font = LottyFonts.regular(size: 16)
    }
    
    var clickButton = UIButton().then {
        $0.backgroundColor = .clear
    }
    
    var deleteButton = UIButton().then {
        $0.setImage(LottyIcons.cancel, for: .normal)
        $0.tintColor = LottyColors.G900
        let config = UIImage.SymbolConfiguration(weight: .thin)
        $0.setPreferredSymbolConfiguration(config,
                                           forImageIn: .normal)
    }
    
    var clickButtonHandler: (() -> Void)?
    var deleteButtonHandler: (() -> Void)?
    
    var disposeBag = DisposeBag()
    
    
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
        
        contentView.backgroundColor = .white
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        contentView.backgroundColor = .white
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
//        disposeBag = DisposeBag()
    }
    
    func inputBind() {
        clickButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                self?.clickButtonHandler?()
            }).disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                self?.deleteButtonHandler?()
            }).disposed(by: disposeBag)
    }
    
    func initUI() {
        self.backgroundColor = .white
        self.selectionStyle = .none
        
        [clockImage, drwNo, clickButton, deleteButton]
            .forEach { contentView.addSubview($0) }
        
        clockImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(11)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(15)
        }
        
        drwNo.snp.makeConstraints {
            $0.leading.equalTo(clockImage.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
        }
        
        clickButton.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.trailing.equalTo(deleteButton.snp.leading).offset(-12)
        }
        
        deleteButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-12)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(30)
        }
    }
    
}
