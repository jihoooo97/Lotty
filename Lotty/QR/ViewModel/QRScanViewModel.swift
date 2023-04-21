//
//  QRScanViewModel.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/21.
//

import Foundation
import RxSwift
import RxRelay

class QRScanViewModel: BaseViewModel {

    let requestURLRelay = PublishRelay<URL>()
 
    override init() {
        super.init()
    }
    
    
    func setURL(url: URL) {
        requestURLRelay.accept(url)
    }
}
