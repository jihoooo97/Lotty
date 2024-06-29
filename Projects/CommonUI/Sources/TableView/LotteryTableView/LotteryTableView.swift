//
//  LotteryTableView.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/20.
//

import UIKit

public class LotteryTableView: UITableView {
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        backgroundColor = .clear
        separatorStyle = .none
        refreshControl?.tintColor = LottyColors.AlphaB600
        register(NumberCell.self, forCellReuseIdentifier: NumberCell.cellId)
        register(NumberCloseCell.self, forCellReuseIdentifier: NumberCloseCell.cellId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
