//
//  BaseViewController.swift
//  Lotty
//
//  Created by JihoMac on 2022/11/07.
//

import UIKit

class BaseViewController<T: BaseViewModel>: UIViewController {
    
    let viewModel: T
    
    init(_ viewModel: T) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
