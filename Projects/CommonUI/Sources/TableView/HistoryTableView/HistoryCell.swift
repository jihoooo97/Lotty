import UIKit
import SnapKit
import RxSwift

public final class HistoryCell: UITableViewCell {
    
    public static let cellId = "historyCell"
            
    let clockImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = LottyIcons.clock
        imageView.tintColor = LottyColors.G900
        return imageView
    }()
    
    let drwNo: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = LottyColors.G900
        label.font = LottyFonts.regular(size: 16)
        return label
    }()
    
    let clickButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(LottyIcons.cancel, for: .normal)
        button.tintColor = LottyColors.G900
        let config = UIImage.SymbolConfiguration(weight: .thin)
        button.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        return button
    }()
    
    public var clickButtonHandler: (() -> Void)?
    public var deleteButtonHandler: (() -> Void)?
    
    var disposeBag = DisposeBag()
    
    
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
        contentView.backgroundColor = .white
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        contentView.backgroundColor = .white
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
//        disposeBag = DisposeBag()
    }
    
    public func bind(drwNo: String) {
        self.drwNo.text = drwNo
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
