//
//  NumberCloseCell.swift
//  Lotty
//
//  Created by JihoMac on 2022/11/10.
//

import UIKit
import Then

final class NumberCloseCell: UITableViewCell {
    
    static let cellId = "numberCloseCell"
    
    var drwNo = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = LottyColors.G900
        $0.font = LottyFonts.semiBold(size: 18)
    }
    
    var statusImage = UIImageView().then {
        $0.tintColor = LottyColors.G600
    }
    
    // MARK: - 메소드
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        contentView.backgroundColor = LottyColors.G50
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        contentView.backgroundColor = LottyColors.G50
    }
    
    
    func setData(lottery: LotteryItem) {
        drwNo.text = "\(lottery.lottery.drwNo)회"
        statusImage.image = lottery.open ? LottyIcons.arrowUp : LottyIcons.arrowDown
    }
    
    func initUI() {
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
