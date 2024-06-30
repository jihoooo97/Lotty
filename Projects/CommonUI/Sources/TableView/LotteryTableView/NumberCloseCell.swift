//
//  NumberCloseCell.swift
//  Lotty
//
//  Created by JihoMac on 2022/11/10.
//

import Domain
import UIKit

public final class NumberCloseCell: UITableViewCell {
    
    public static let cellId = "numberCloseCell"
    
    public var isOpen: Bool = false {
        didSet {
            statusImage.image = isOpen ? LottyIcons.arrowUp : LottyIcons.arrowDown
        }
    }
    
    private let drwNo: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = LottyColors.G900
        label.font = LottyFonts.semiBold(size: 18)
        return label
    }()
    
    private let statusImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = LottyColors.G600
        return imageView
    }()
    
    // MARK: - 메소드
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        contentView.backgroundColor = LottyColors.G50
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        contentView.backgroundColor = LottyColors.G50
    }
    
    
    public func bind(lottery: Lottery) {
        drwNo.text = "\(lottery.turn)회"
        isOpen = lottery.isOpen
    }
    
    private func initUI() {
        self.backgroundColor = LottyColors.G50
        self.selectionStyle = .none
        
        [drwNo, statusImage]
            .forEach { contentView.addSubview($0) }
        
        drwNo.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        statusImage.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }
    }
    
}
