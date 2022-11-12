//
//  BaseViewController.swift
//  Lotty
//
//  Created by JihoMac on 2022/11/07.
//

import UIKit

class BaseViewController: UIViewController, ViewController {
    
    var safeArea = UILayoutGuide()
    var viewModel: ViewModel?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(viewModel: BaseViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initAttributes()
        initUI()
        inputBind()
        outputBind()
    }
    
    func initAttributes() { }
    
    func initUI() { }
    
    func inputBind() { }
    
    func outputBind() { }
    
}
