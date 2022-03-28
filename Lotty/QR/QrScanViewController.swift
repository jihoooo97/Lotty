import UIKit
import AVKit
import WebKit
import Network

class QrScanViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    @IBOutlet weak var qrView: UIView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var firstView: UIView!
    
    let monitor = NWPathMonitor()
    var captureSession = AVCaptureSession()
    var videoPreviewLayer = AVCaptureVideoPreviewLayer()
    var centerGuideLineView = UIView()
    var before = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monitor.start(queue: .global())
        monitor.pathUpdateHandler = { path in
            if path.status != .satisfied {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "오류", message: "네트워크 연결을 확인해주세요", preferredStyle: .alert)
                    let confirm = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(confirm)
                    self.present(alert, animated: true)
                }
            }
        }
        webView.uiDelegate = self
        webView.navigationDelegate = self
        qrView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 250)
        
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
        let width = UIScreen.main.bounds.width
        let height = qrView.frame.height
        // 영상을 담을 공간.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        //카메라의 크기 지정
        videoPreviewLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
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
        
        let leftBoard = UIView()
        leftBoard.frame = CGRect(x: 0, y: 0, width: line.frame.minX, height: qrView.frame.height)
        leftBoard.backgroundColor = .black
        leftBoard.alpha = 0.4
        qrView.addSubview(leftBoard)
        
        let rightBoard = UIView()
        rightBoard.frame = CGRect(x: line.frame.maxX, y: 0, width: qrView.frame.width - line.frame.maxX, height: qrView.frame.height)
        rightBoard.backgroundColor = .black
        rightBoard.alpha = 0.4
        qrView.addSubview(rightBoard)
        
        let topBoard = UIView()
        topBoard.frame = CGRect(x: line.frame.minX, y: 0, width: line.frame.width, height: line.frame.minY)
        topBoard.backgroundColor = .black
        topBoard.alpha = 0.4
        qrView.addSubview(topBoard)
        
        let bottomBoard = UIView()
        bottomBoard.frame = CGRect(x: line.frame.minX, y: line.frame.maxY, width: line.frame.width, height: qrView.frame.height - line.frame.maxY)
        bottomBoard.backgroundColor = .black
        bottomBoard.alpha = 0.4
        qrView.addSubview(bottomBoard)
    }
}

extension QrScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.startRunning()
        if metadataObjects.count == 0 { return }
        
        let metaDataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        guard let StringCodeValue = metaDataObject.stringValue else { return }
        if monitor.currentPath.status == .satisfied {
            firstView.isHidden = true
            if before == StringCodeValue { return }
            guard let _ = self.videoPreviewLayer.transformedMetadataObject(for: metaDataObject) else { return }
            guard let url = URL(string: StringCodeValue) else { return }
            let request = URLRequest(url: url)
            webView.load(request)
            before = StringCodeValue
        } else {
            let alert = UIAlertController(title: "오류", message: "네트워크 연결을 확인해주세요", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "확인", style: .default)
            alert.addAction(confirm)
            self.present(alert, animated: true)
        }
    }
}
