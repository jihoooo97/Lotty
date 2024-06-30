import UIKit
import CommonUI

class SearchBarView: UIButton {
    
    struct Constatns {
        static let scopeImageLeft: CGFloat = 16
        static let scopeImageSize: CGFloat = 20
        static let placeholderLeft: CGFloat = 16
    }
    
    private lazy var scopeImageView = UIImageView()
    private lazy var placeholderLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initAttributes()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func initAttributes() {
        backgroundColor = .white
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = 4
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0.5)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 1
        
        scopeImageView = {
            let imageView = UIImageView()
            imageView.image = LottyIcons.search
            imageView.tintColor = LottyColors.G400
            return imageView
        }()
        
        placeholderLabel = {
            let label = UILabel()
            label.text = "지역 이름으로 검색하세요"
            label.textAlignment = .left
            label.textColor = LottyColors.G400
            label.font = LottyFonts.medium(size: 16)
            return label
        }()
    }
    
    private func initConstraints() {
        [scopeImageView, placeholderLabel].forEach {
            self.addSubview($0)
        }

        scopeImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(Constatns.scopeImageLeft)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(Constatns.scopeImageSize)
        }
        
        placeholderLabel.snp.makeConstraints {
            $0.left.equalTo(scopeImageView.snp.right).offset(Constatns.placeholderLeft)
            $0.centerY.equalToSuperview()
        }
    }
    
}
