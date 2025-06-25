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

    private lazy var dismissButton = UIButton()
    private let qrReader = QRReaderView()
    private lazy var webView = WKWebView()
    private lazy var descriptionImage = UIImageView()
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
        dismissButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                self?.dismiss(animated: true)
            }.disposed(by: bag)
        
        qrReader.qrUrl
            .distinctUntilChanged()
            .map { URLRequest(url: $0) }
            .withUnretained(self)
            .subscribe { owner, urlRequest in
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                owner.webView.load(urlRequest)
                
                if !owner.descriptionLabel.isHidden {
                    owner.descriptionImage.isHidden = true
                    owner.descriptionImage.removeFromSuperview()
                    owner.descriptionLabel.isHidden = true
                    owner.descriptionLabel.removeFromSuperview()
                }
            }.disposed(by: bag)
    }
    
    public override func setUIProperty() {
        dismissButton = {
            let button = UIButton()
            button.configuration = .plain()
            button.configuration?.image = .init(systemName: "xmark")
            button.tintColor = .white
            return button
        }()
        
        webView = {
            let webView = WKWebView()
            webView.scrollView.showsHorizontalScrollIndicator = false
            webView.scrollView.showsVerticalScrollIndicator = false
            return webView
        }()
        
        descriptionImage = {
            let imageView = UIImageView()
            imageView.image = .icon(named: "icon_lomin")
            imageView.tintColor = .lightGray.withAlphaComponent(0.5)
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        descriptionLabel = {
            let label = UILabel()
            label.text = "QR코드를 촬영하여\n당첨정보를 조회하세요!"
            label.font = .systemFont(ofSize: 18.0, weight: .medium)
            label.textColor = .lightGray.withAlphaComponent(0.5)
            label.textAlignment = .center
            label.numberOfLines = 0
            return label
        }()
    }
    
    public override func setLayout() {
        view.addSubviews(qrReader, webView, dismissButton)
        webView.addSubviews(descriptionImage, descriptionLabel)
        
        dismissButton.snp.makeConstraints { make in
            make.left.top.equalTo(safeArea).inset(20)
            make.size.equalTo(30)
        }
        
        qrReader.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(safeArea)
            make.height.equalTo(250)
        }
        
        webView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(safeArea)
            make.top.equalTo(qrReader.snp.bottom)
        }
        
        descriptionImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(safeArea.snp.width).multipliedBy(0.5)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(descriptionImage)
        }
    }

}
