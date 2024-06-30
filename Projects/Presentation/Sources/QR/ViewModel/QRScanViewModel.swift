//
//  QRScanViewModel.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/21.
//

import Foundation
import RxSwift
import RxRelay

public final class QRScanViewModel {

    let requestURLRelay = PublishRelay<URL>()
 
    private let disposeBag = DisposeBag()
    
    public init() { }
    
    
    func setURL(url: URL) {
        requestURLRelay.accept(url)
    }
    
}
