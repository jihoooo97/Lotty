import UIKit
import RxSwift
import RxCocoa
import AVFoundation
import WebKit

final class QrScanViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    private let viewModel: QRScanViewModel
    private var disposeBag = DisposeBag()
    
    init(viewModel: QRScanViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private var scrollView = UIScrollView()
    private var containerView = UIView()
    
    private lazy var qrReaderView = QRReaderView(delegate: self)
    
    private var webView = WKWebView()
    private var noQrView = UIView()
    private var logoImage = UIImageView()
    private var requireLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initAttributes()
        initUI()
        inputBind()
        outputBind()
        
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .authorized {
            setBarcodeReader()
        } else if status == .denied {
            requireCamera()
        } else if status == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video) { isSuccess in
                if isSuccess {
                    self.setBarcodeReader()
                } else {
                    self.requireCamera()
                }
            }
        }
    }
    
    
    private func inputBind() { }
    
    private func outputBind() {
        viewModel.requestURLRelay
            .distinctUntilChanged()
            .withUnretained(self).map { $0 }
            .bind { vc, url in
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                let request = URLRequest(url: url)
                vc.webView.load(request)
                vc.noQrView.isHidden = true
            }
            .disposed(by: disposeBag)
    }
    
    private func requireCamera() {
        AlertManager.shared.showAlert(
            title: "알림",
            message: "카메라 권한이 필요합니다.\n설정에서 카메라 권한을 허용으로 변경해주세요."
        )
    }

    private func setBarcodeReader() {
        qrReaderView.setBarcodeReader()
    }
    
}


extension QrScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        guard
            metadataObjects.count > 0,
            let metaDataObject = metadataObjects[0] as? AVMetadataMachineReadableCodeObject,
            let _ = qrReaderView.videoPreviewLayer.transformedMetadataObject(for: metaDataObject),
            let urlString = metaDataObject.stringValue,
            urlString.hasPrefix("http://"),
            let url = URL(string: urlString)
        else { return }
        viewModel.setURL(url: url)
    }

}

extension QrScanViewController {
   
    private func initAttributes() {
        scrollView = UIScrollView().then {
            $0.layer.masksToBounds = false
            $0.backgroundColor = .white
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
        }
        
        containerView.backgroundColor = .clear
        
        noQrView = UIView().then {
            $0.backgroundColor = .white
        }
        
        logoImage = UIImageView().then {
            $0.image = UIImage(named: "lomin_icon")!
            $0.tintColor = LottyColors.G300
            $0.contentMode = .scaleAspectFill
        }
        
        requireLabel = UILabel().then {
            $0.text = "QR코드를 촬영해주세요"
            $0.textAlignment = .center
            $0.textColor = LottyColors.G300
            $0.font = LottyFonts.semiBold(size: 15)
        }
        
        webView = WKWebView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: view.frame.width,
                height: 500
            ),
            configuration: .init()
        ).then {
            $0.uiDelegate = self
            $0.allowsBackForwardNavigationGestures = true
            $0.allowsLinkPreview = true
            $0.navigationDelegate = self
            $0.scrollView.showsHorizontalScrollIndicator = false
        }
    }
    
    private func initUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        [qrReaderView, webView, noQrView].forEach {
            containerView.addSubview($0)
        }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
            $0.height.greaterThanOrEqualToSuperview()
        }
        
        qrReaderView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(250)
        }
        
        noQrView.snp.makeConstraints {
            $0.top.equalTo(webView)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(100)
        }
        
        [logoImage, requireLabel].forEach {
            noQrView.addSubview($0)
        }
        
        logoImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        requireLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
        }
        
        webView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(qrReaderView.snp.bottom)
            $0.height.equalTo(500)
        }
    }
    
}
