import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import AVKit
import WebKit

final class QrScanViewController: UIViewController, ViewController {
    
    var scrollView = UIScrollView()
    var containerView = UIView()
    
    var qrContainerView = UIView()
    var squreLine = UIView()
    var leftBoard = UIView()
    var rightBoard = UIView()
    var topBoard = UIView()
    var bottomBoard = UIView()
    
    var webView = WKWebView()
    var noQrView = UIView()
    var logoImage = UIImageView()
    var requireLabel = UILabel()
    
    var safeArea = UILayoutGuide()
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer = AVCaptureVideoPreviewLayer()
    
    var before = ""
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func inputBind() {
        
    }
    
    func outputBind() {
        
    }
    
    func requireCamera() {
        let alert = UIAlertController(title: "알림", message: "카메라 권한이 필요합니다.\n설정에서 카메라 권한을 허용으로 변경해주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setBarcodeReader() {
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        if let captureDevice = captureDevice {
            do {
                // 제한하고 싶은 영역
                let rect = CGRect(x: (view.frame.width - 150) / 2,
                                  y: 50,
                                  width: 150,
                                  height: 150)
                let input = try AVCaptureDeviceInput(device: captureDevice)
                captureSession.addInput(input)
                
                let output = AVCaptureMetadataOutput()
                captureSession.addOutput(output)
                
                output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                output.metadataObjectTypes = [.qr]
                
                let rectConverted = setVideoLayer(rect: rect)
                output.rectOfInterest = rectConverted
                initCameraFrame()
                captureSession.startRunning()
            } catch {
                print("error")
            }
        }
    }
    
    private func setVideoLayer(rect: CGRect) -> CGRect{
        let width = UIScreen.main.bounds.width
        let height: CGFloat = 250
        // 영상을 담을 공간.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        //카메라의 크기 지정
        videoPreviewLayer.frame = CGRect(x: 0,
                                         y: 0,
                                         width: width,
                                         height: height)
        //카메라의 비율지정
        videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        qrContainerView.layer.addSublayer(videoPreviewLayer)
        
        return videoPreviewLayer.metadataOutputRectConverted(fromLayerRect: rect)
    }
    
}


extension QrScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.startRunning()
        if metadataObjects.count == 0 { return }
        
        let metaDataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        guard let StringCodeValue = metaDataObject.stringValue else { return }
        
        noQrView.isHidden = true
        if before == StringCodeValue { return }
        guard let _ = self.videoPreviewLayer.transformedMetadataObject(for: metaDataObject) else { return }
        guard let url = URL(string: StringCodeValue) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
        before = StringCodeValue
    }
    
}

extension QrScanViewController: WKUIDelegate, WKNavigationDelegate {
    
    
    
}

extension QrScanViewController {
   
    func initAttributes() {
        scrollView = UIScrollView().then {
            $0.layer.masksToBounds = false
            $0.backgroundColor = .white
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
        }
        
        containerView.backgroundColor = .clear
        
        qrContainerView.backgroundColor = .clear
        
        squreLine = UIView().then {
            $0.backgroundColor = .none
            $0.layer.borderWidth = 0.5
            $0.layer.borderColor = LottyColors.B500.cgColor
        }
        
        leftBoard = UIView().then {
            $0.backgroundColor = .black
            $0.alpha = 0.4
        }
        
        rightBoard = UIView().then {
            $0.backgroundColor = .black
            $0.alpha = 0.4
        }
        
        topBoard = UIView().then {
            $0.backgroundColor = .black
            $0.alpha = 0.4
        }
        
        bottomBoard = UIView().then {
            $0.backgroundColor = .black
            $0.alpha = 0.4
        }
        
        noQrView = UIView().then {
            $0.backgroundColor = .white
        }
        
        logoImage = UIImageView().then {
            $0.image = UIImage(named: "lomin_icon")!
            $0.tintColor = LottyColors.G300
            $0.contentMode = .scaleAspectFill
        }
        
        requireLabel = UILabel().then {
            $0.textAlignment = .center
            $0.textColor = LottyColors.G300
            $0.font = LottyFonts.semiBold(size: 15)
            $0.text = "QR코드를 촬영해주세요"
        }
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: CGRect(x: 0, y: 0,
                                          width: view.frame.width, height: 750),
                            configuration: webConfiguration).then {
            $0.uiDelegate = self
            $0.allowsBackForwardNavigationGestures = true
            $0.allowsLinkPreview = true
            $0.navigationDelegate = self
            $0.scrollView.showsHorizontalScrollIndicator = false
        }
    }
    
    func initUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        [qrContainerView, webView, noQrView]
            .forEach { containerView.addSubview($0) }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
            $0.height.greaterThanOrEqualToSuperview()
        }
        
        qrContainerView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(250)
        }
        
        noQrView.snp.makeConstraints {
            $0.top.equalTo(webView)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(100)
        }
        
        [logoImage, requireLabel]
            .forEach { noQrView.addSubview($0) }
        
        logoImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        requireLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
        }
        
        webView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(qrContainerView.snp.bottom)
            $0.height.equalTo(750)
        }
    }
    
    func initCameraFrame() {
        [squreLine, leftBoard, rightBoard, topBoard, bottomBoard]
            .forEach { qrContainerView.addSubview($0) }
        
        squreLine.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(150)
        }
        
        leftBoard.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.trailing.equalTo(squreLine.snp.leading)
        }
        
        rightBoard.snp.makeConstraints {
            $0.trailing.top.bottom.equalToSuperview()
            $0.leading.equalTo(squreLine.snp.trailing)
        }
        
        topBoard.snp.makeConstraints {
            $0.leading.trailing.equalTo(squreLine)
            $0.top.equalToSuperview()
            $0.bottom.equalTo(squreLine.snp.top)
        }
        
        bottomBoard.snp.makeConstraints {
            $0.leading.trailing.equalTo(squreLine)
            $0.top.equalTo(squreLine.snp.bottom)
            $0.bottom.equalToSuperview()
        }
    }
    
}
