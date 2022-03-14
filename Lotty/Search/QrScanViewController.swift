import UIKit
import AVKit
import WebKit

class QrScanViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    @IBOutlet weak var qrView: UIView!
    @IBOutlet weak var webView: WKWebView!
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer = AVCaptureVideoPreviewLayer()
    var centerGuideLineView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.uiDelegate = self
        webView.navigationDelegate = self
        qrView.layer.borderWidth = 1
        qrView.layer.borderColor = UIColor.white.cgColor
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.backgroundColor = .none
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if (status == .authorized) {
            setBarcodeReader()
        } else if (status == .denied) {
            let alert = UIAlertController(title: "알림", message: "카메라 권한이 필요합니다.\n설정에서 카메라 권한을 허용으로 변경해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if (status == .notDetermined) {
            AVCaptureDevice.requestAccess(for: .video) { (isSuccess) in
                if (isSuccess) {
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.popViewController(animated: true)
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
        let videoLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        //카메라의 크기 지정
        videoLayer.frame = qrView.layer.bounds
        //카메라의 비율지정
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        qrView.layer.addSublayer(videoLayer)
        
        return videoLayer.metadataOutputRectConverted(fromLayerRect: rectOfInterest)
    }
    
    func setCenterGuideLineView(rectOfInterest: CGRect) {
        let cornerLength: CGFloat = 20
        let cornerLineWidth: CGFloat = 5
        
        // 가이드라인의 각 모서리 point
        let upperLeftPoint = CGPoint(x: rectOfInterest.minX, y: rectOfInterest.minY)
        let upperRightPoint = CGPoint(x: rectOfInterest.maxX, y: rectOfInterest.minY)
        let lowerRightPoint = CGPoint(x: rectOfInterest.maxX, y: rectOfInterest.maxY)
        let lowerLeftPoint = CGPoint(x: rectOfInterest.minX, y: rectOfInterest.maxY)
        
        // 각 모서리를 중심으로 한 Edge를 그림.
        let upperLeftCorner = UIBezierPath()
        upperLeftCorner.lineWidth = cornerLineWidth
        upperLeftCorner.move(to: CGPoint(x: upperLeftPoint.x + cornerLength, y: upperLeftPoint.y))
        upperLeftCorner.addLine(to: CGPoint(x: upperLeftPoint.x, y: upperLeftPoint.y))
        upperLeftCorner.addLine(to: CGPoint(x: upperLeftPoint.x, y: upperLeftPoint.y + cornerLength))
        
        let upperRightCorner = UIBezierPath()
        upperRightCorner.lineWidth = cornerLineWidth
        upperRightCorner.move(to: CGPoint(x: upperRightPoint.x - cornerLength, y: upperRightPoint.y))
        upperRightCorner.addLine(to: CGPoint(x: upperRightPoint.x, y: upperRightPoint.y))
        upperRightCorner.addLine(to: CGPoint(x: upperRightPoint.x, y: upperRightPoint.y + cornerLength))
        
        let lowerRightCorner = UIBezierPath()
        lowerRightCorner.lineWidth = cornerLineWidth
        lowerRightCorner.move(to: CGPoint(x: lowerRightPoint.x, y: lowerRightPoint.y - cornerLength))
        lowerRightCorner.addLine(to: CGPoint(x: lowerRightPoint.x, y: lowerRightPoint.y))
        lowerRightCorner.addLine(to: CGPoint(x: lowerRightPoint.x - cornerLength, y: lowerRightPoint.y))
        
        let lowerLeftCorner = UIBezierPath()
        lowerLeftCorner.lineWidth = cornerLineWidth
        lowerLeftCorner.move(to: CGPoint(x: lowerLeftPoint.x + cornerLength, y: lowerLeftPoint.y))
        lowerLeftCorner.addLine(to: CGPoint(x: lowerLeftPoint.x, y: lowerLeftPoint.y))
        lowerLeftCorner.addLine(to: CGPoint(x: lowerLeftPoint.x, y: lowerLeftPoint.y - cornerLength))
        
        upperLeftCorner.stroke()
        upperRightCorner.stroke()
        lowerRightCorner.stroke()
        lowerLeftCorner.stroke()
        
        // layer 에 추가
        let upperLeftCornerLayer = CAShapeLayer()
        upperLeftCornerLayer.path = upperLeftCorner.cgPath
        upperLeftCornerLayer.strokeColor = UIColor.black.withAlphaComponent(0.5).cgColor
        upperLeftCornerLayer.fillColor = UIColor.clear.cgColor
        upperLeftCornerLayer.lineWidth = cornerLineWidth
        
        let upperRightCornerLayer = CAShapeLayer()
        upperRightCornerLayer.path = upperRightCorner.cgPath
        upperRightCornerLayer.strokeColor = UIColor.black.withAlphaComponent(0.5).cgColor
        upperRightCornerLayer.fillColor = UIColor.clear.cgColor
        upperRightCornerLayer.lineWidth = cornerLineWidth
        
        let lowerRightCornerLayer = CAShapeLayer()
        lowerRightCornerLayer.path = lowerRightCorner.cgPath
        lowerRightCornerLayer.strokeColor = UIColor.black.withAlphaComponent(0.5).cgColor
        lowerRightCornerLayer.fillColor = UIColor.clear.cgColor
        lowerRightCornerLayer.lineWidth = cornerLineWidth
        
        let lowerLeftCornerLayer = CAShapeLayer()
        lowerLeftCornerLayer.path = lowerLeftCorner.cgPath
        lowerLeftCornerLayer.strokeColor = UIColor.black.withAlphaComponent(0.5).cgColor
        lowerLeftCornerLayer.fillColor = UIColor.clear.cgColor
        lowerLeftCornerLayer.lineWidth = cornerLineWidth
        
        view.layer.addSublayer(upperLeftCornerLayer)
        view.layer.addSublayer(upperRightCornerLayer)
        view.layer.addSublayer(lowerRightCornerLayer)
        view.layer.addSublayer(lowerLeftCornerLayer)
    }
}

extension QrScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.startRunning()
        if metadataObjects.count == 0 { return }
        
        let metaDataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        guard let StringCodeValue = metaDataObject.stringValue else { return }
        guard let _ = self.videoPreviewLayer.transformedMetadataObject(for: metaDataObject) else { return }
        guard let url = URL(string: StringCodeValue) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
