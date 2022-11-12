//
//  ViewController.swift
//  Lotty
//
//  Created by JihoMac on 2022/11/12.
//

import UIKit

protocol ViewController {

    var safeArea: UILayoutGuide { get set }
    
    func inputBind()
    
    func outputBind()
    
    func initAttributes()
    
    func initUI()
    
}
