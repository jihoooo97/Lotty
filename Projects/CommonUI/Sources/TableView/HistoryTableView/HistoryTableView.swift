//
//  HistoryTableView.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/20.
//

import UIKit

public final class HistoryTableView: UITableView {
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        backgroundColor = .clear
        separatorStyle = .none
        keyboardDismissMode = .onDrag
        showsHorizontalScrollIndicator = false
        delegate = self
        register(HistoryCell.self, forCellReuseIdentifier: HistoryCell.cellId)
        estimatedRowHeight = 50
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension HistoryTableView: UITableViewDelegate {
    
}
