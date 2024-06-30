import UIKit
import Domain
import CommonUI

final class StoreDetailView: UIView {
    
    private struct Constants {
        static let defaultLeft: CGFloat = 12
        static let defaultSpace: CGFloat = 12
        static let smallSpace: CGFloat = 8
        static let labelRight: CGFloat = -2
        static let naviImageSize: CGFloat = 30
    }
    
    private lazy var nameLabel = UILabel()
    private lazy var addressLabel = UILabel()
    private lazy var phoneLabel = UILabel()
    
    private lazy var naviView = UIView()
    private lazy var naviImageView = UIImageView()
    private lazy var naviLabel = UILabel()
    lazy var naviButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        initAttributes()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func bind(store: Store) {
        nameLabel.text = store.storeName
        addressLabel.text = store.roadAddress == "" ? store.address : store.roadAddress
        phoneLabel.text = store.phone
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
        
        nameLabel = {
            let label = UILabel()
            label.text = "가게 이름"
            label.textAlignment = .left
            label.font = LottyFonts.semiBold(size: 17)
            label.textColor = LottyColors.G900
            return label
        }()
        
        addressLabel = {
            let label = UILabel()
            label.text = "가게 주소"
            label.textAlignment = .left
            label.font = LottyFonts.regular(size: 15)
            label.textColor = LottyColors.G500
            label.numberOfLines = 2
            return label
        }()
        
        phoneLabel = {
            let label = UILabel()
            label.text = "가게 전화번호"
            label.textAlignment = .left
            label.font = LottyFonts.regular(size: 15)
            label.textColor = LottyColors.B500
            return label
        }()
        
        naviView = {
            let view = UIView()
            view.backgroundColor = LottyColors.B600
            view.layer.cornerRadius = 4
            return view
        }()
        
        naviImageView = {
            let imageView = UIImageView()
            imageView.image = LottyIcons.navi.resize(width: 30).withTintColor(.white)
            return imageView
        }()
        
        naviLabel = {
            let label = UILabel()
            label.text = "길찾기"
            label.textAlignment = .center
            label.font = LottyFonts.regular(size: 15)
            label.textColor = .white
            return label
        }()
        
        naviButton = {
            let button = UIButton()
            button.backgroundColor = .clear
            return button
        }()
    }
    
    private func initConstraints() {
        [nameLabel, addressLabel, phoneLabel, naviView].forEach {
            self.addSubview($0)
        }
        
        [naviImageView, naviLabel, naviButton].forEach {
            naviView.addSubview($0)
        }
        
        nameLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(Constants.defaultLeft)
            $0.right.equalTo(naviButton.snp.left).offset(Constants.labelRight)
            $0.top.equalToSuperview().offset(Constants.smallSpace)
        }
        
        addressLabel.snp.makeConstraints {
            $0.left.equalTo(nameLabel)
            $0.right.equalTo(naviButton.snp.left).offset(Constants.labelRight)
            $0.top.equalTo(nameLabel.snp.bottom).offset(Constants.defaultSpace)
        }
        
        phoneLabel.snp.makeConstraints {
            $0.left.right.equalTo(nameLabel)
            $0.top.equalTo(addressLabel.snp.bottom).offset(Constants.smallSpace)
        }
        
        naviView.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-Constants.smallSpace)
            $0.top.equalToSuperview().offset(Constants.defaultSpace)
            $0.bottom.equalToSuperview().offset(-Constants.defaultSpace)
            $0.width.equalTo(naviView.snp.height)
        }
        
        naviImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.smallSpace)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(Constants.naviImageSize)
        }
        
        naviLabel.snp.makeConstraints {
            $0.top.equalTo(naviImageView.snp.bottom).offset(2)
            $0.centerX.equalToSuperview()
        }
        
        naviButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
