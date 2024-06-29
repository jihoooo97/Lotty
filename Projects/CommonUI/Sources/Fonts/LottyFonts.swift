//
//  LottyFonts.swift
//  Lotty
//
//  Created by JihoMac on 2022/11/07.
//

import UIKit

public enum LottyFonts {

    public static func bold(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Bold", size: size)!
    }
    
    public static func semiBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-SemiBold", size: size)!
    }
    
    public static func medium(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Medium", size: size)!
    }
    
    public static func regular(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Regular", size: size)!
    }

    public static func yeonsung(size: CGFloat) -> UIFont {
        return UIFont(name: "BMYEONSUNG", size: size)!
    }
    
    public static func dohyeon(size: CGFloat) -> UIFont {
        return UIFont(name: "BMDoHyeon", size: size)!
    }
    
    public static func hannaPro(size: CGFloat) -> UIFont {
        return UIFont(name: "BMHANNAPro", size: size)!
    }
    
}
