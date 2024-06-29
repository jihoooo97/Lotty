import Common
import CommonUI
import RxSwift
import AVFoundation
import WebKit

public final class QrScanViewController: BaseViewController {
    
    private let viewModel: QRScanViewModel
    
    public init(viewModel: QRScanViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    
    private lazy var scrollView = UIScrollView()
    private let containerView = UIView()
    
    private lazy var qrReaderView = QRReaderView(delegate: self)
    
    private let noQrView = UIView()
    private lazy var logoImage = UIImageView()
    private lazy var requireLabel = UILabel()
    private lazy var webView = WKWebView()
    
    
    public override func viewDidLoad() {
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
    
    private func initAttributes() {
        scrollView = {
            let scrollView = UIScrollView()
            scrollView.layer.masksToBounds = false
            scrollView.backgroundColor = .white
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            return scrollView
        }()
        
        containerView.backgroundColor = .clear
        noQrView.backgroundColor = .white
        
        logoImage = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "lomin_icon")!
            imageView.tintColor = LottyColors.G300
            imageView.contentMode = .scaleAspectFill
            return imageView
        }()
        
        requireLabel = {
            let label = UILabel()
            label.text = "QR코드를 촬영해주세요"
            label.textAlignment = .center
            label.textColor = LottyColors.G300
            label.font = LottyFonts.semiBold(size: 15)
            return label
        }()
        
        webView = {
            let webView = WKWebView()
            webView.uiDelegate = self
            webView.allowsBackForwardNavigationGestures = true
            webView.allowsLinkPreview = true
            webView.navigationDelegate = self
            webView.scrollView.showsHorizontalScrollIndicator = false
            webView.backgroundColor = .systemBackground
            return webView
        }()
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


extension QrScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    private func requireCamera() {
        AlertManager.shared.showAlert(
            title: "알림",
            message: "카메라 권한이 필요합니다.\n설정에서 카메라 권한을 허용으로 변경해주세요."
        )
    }

    private func setBarcodeReader() {
        qrReaderView.setBarcodeReader()
    }
    
    public func metadataOutput(
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

extension QrScanViewController: WKUIDelegate, WKNavigationDelegate {}
