//
//  LottyFonts.swift
//  Lotty
//
//  Created by JihoMac on 2022/11/07.
//

import UIKit

enum LottyFonts {

    static func bold(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Bold", size: size)!
    }
    
    static func semiBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-SemiBold", size: size)!
    }
    
    static func medium(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Medium", size: size)!
    }
    
    static func regular(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Regular", size: size)!
    }

    static func yeonsung(size: CGFloat) -> UIFont {
        return UIFont(name: "BMYEONSUNG", size: size)!
    }
    
    static func dohyeon(size: CGFloat) -> UIFont {
        return UIFont(name: "BMDoHyeon", size: size)!
    }
    
    static func hannaPro(size: CGFloat) -> UIFont {
        return UIFont(name: "BMHANNAPro", size: size)!
    }
    
}
