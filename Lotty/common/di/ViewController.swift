//
//  ViewController.swift
//  Lotty
//
//  Created by JihoMac on 2022/11/12.
//

import UIKit

protocol ViewController {

    var safeArea: UILayoutGuide { get set }
    
    func initAttributes()
    
    func initUI()
    
    func inputBind()
    
    func outputBind()
    
}
