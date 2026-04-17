//
//  LottyMarker.swift
//  MapFeature
//
//  Created by 유지호 on 6/27/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import Core
import UIComponent

import UIKit
import NMapsMap

final class LottyMarker: NMFMarker {
    
    var isSelected: Bool = false {
        didSet {
            if isSelected {
                self.iconImage = NMFOverlayImage(image: UIComponentAsset.iconCloverFour.image)
            } else {
                self.iconImage = NMFOverlayImage(image: UIComponentAsset.iconCloverThree.image)
            }
        }
    }
    
    override init() {
        super.init()
        
        self.iconImage = NMFOverlayImage(image: UIComponentAsset.iconCloverThree.image)
        self.width = 50
        self.height = 60
    }
    
}
