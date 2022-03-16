import UIKit
import AVKit
import WebKit

class QrScanViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    @IBOutlet weak var qrView: UIView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var firstView: UIView!
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer = AVCaptureVideoPreviewLayer()
    var centerGuideLineView = UIView()
    var before = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.uiDelegate = self
        webView.navigationDelegate = self
        qrView.layer.borderWidth = 1
        qrView.layer.borderColor = UIColor.white.cgColor
        
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .authorized {
            setBarcodeReader()
        } else if status == .denied {
            let alert = UIAlertController(title: "알림", message: "카메라 권한이 필요합니다.\n설정에서 카메라 권한을 허용으로 변경해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if status == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video) { isSuccess in
                if isSuccess {
                    DispatchQueue.main.async {
                        self.setBarcodeReader()
                    }
                } else {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "알림", message: "카메라 권한이 필요합니다.\n설정에서 카메라 권한을 허용으로 변경해주세요.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setBarcodeReader() {
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        if let captureDevice = captureDevice {
            do {
                // 제한하고 싶은 영역
                let rectOfInterest = CGRect(x: (qrView.bounds.width - 150) / 2 , y: (qrView.bounds.height - 150) / 2, width: 150, height: 150)
                
                let input = try AVCaptureDeviceInput(device: captureDevice)
                captureSession.addInput(input)
                
                let output = AVCaptureMetadataOutput()
                captureSession.addOutput(output)
                
                output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                output.metadataObjectTypes = [.qr]
                
                let rectConverted = setVideoLayer(rectOfInterest: rectOfInterest)
                output.rectOfInterest = rectConverted
                setCenterGuideLineView(rectOfInterest: rectOfInterest)
                captureSession.startRunning()
            } catch {
                print("error")
            }
        }
    }
    
    private func setVideoLayer(rectOfInterest: CGRect) -> CGRect{
        // 영상을 담을 공간.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        //카메라의 크기 지정
        videoPreviewLayer.frame = qrView.layer.bounds
        //카메라의 비율지정
        videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        qrView.layer.addSublayer(videoPreviewLayer)
        
        return videoPreviewLayer.metadataOutputRectConverted(fromLayerRect: rectOfInterest)
    }
    
    func setCenterGuideLineView(rectOfInterest: CGRect) {
        let line = UIView()
        line.frame = rectOfInterest
        line.backgroundColor = .none
        line.layer.borderWidth = 0.5
        line.layer.borderColor = UIColor.B500.cgColor
        qrView.addSubview(line)
    }
}

extension QrScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.startRunning()
        if metadataObjects.count == 0 { return }
        
        let metaDataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        guard let StringCodeValue = metaDataObject.stringValue else { return }
        firstView.isHidden = true
        if before == StringCodeValue { return }
        guard let _ = self.videoPreviewLayer.transformedMetadataObject(for: metaDataObject) else { return }
        guard let url = URL(string: StringCodeValue) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
        before = StringCodeValue
    }
}
