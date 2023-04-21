//
//  QRAssembly.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/21.
//

import Swinject

class QRAssembly: Assembly {

    func assemble(container: Container) {
        container.register(QRScanViewModel.self) { resolver in
            return QRScanViewModel()
        }
        
        container.register(QrScanViewController.self) { resolver in
            let viewModel = resolver.resolve(QRScanViewModel.self)!
            return QrScanViewController(viewModel: viewModel)
        }
    }
    
}
