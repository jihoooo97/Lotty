import Core
import UIComponent
import BaseFeature

import UIKit
import AVFoundation
import WebKit
import SnapKit
import RxSwift
import RxCocoa

public final class QRViewController: BaseViewController {

    private let qrReader = QRReaderView()
    private lazy var webView = WKWebView()
    private lazy var descriptionLabel = UILabel()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        qrReader.setQRReader()
    }
    
    
    private func bind() {
        qrReader.qrUrl
            .distinctUntilChanged()
            .map { URLRequest(url: $0) }
            .withUnretained(self)
            .subscribe { owner, urlRequest in
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                owner.webView.load(urlRequest)
                
                if !owner.descriptionLabel.isHidden {
                    owner.descriptionLabel.isHidden = true
                    owner.descriptionLabel.removeFromSuperview()
                }
            }.disposed(by: bag)
    }
    
    public override func setUIProperty() {
        webView = {
            let webView = WKWebView()
            webView.scrollView.showsHorizontalScrollIndicator = false
            webView.scrollView.showsVerticalScrollIndicator = false
            return webView
        }()
        
        descriptionLabel = {
            let label = UILabel()
            label.text = "QR코드를 촬영하여\n당첨정보를 조회하세요!"
            label.font = .systemFont(ofSize: 18.0, weight: .medium)
            label.textAlignment = .center
            label.numberOfLines = 0
            return label
        }()
    }
    
    public override func setLayout() {
        view.addSubviews(qrReader, webView)
        webView.addSubview(descriptionLabel)
        
        qrReader.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(safeArea)
            make.height.equalTo(250)
        }
        
        webView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(safeArea)
            make.top.equalTo(qrReader.snp.bottom)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

}
