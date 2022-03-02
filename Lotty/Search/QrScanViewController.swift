import UIKit
import AVKit
import WebKit

class QrScanViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    @IBOutlet weak var qrView: UIView!
    @IBOutlet weak var webView: WKWebView!
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer = AVCaptureVideoPreviewLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.backgroundColor = .none
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if (status == .authorized) {
            setBarcodeReader()
            setCenterGuideLineView()
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
              captureSession = AVCaptureSession()
              
                let input: AVCaptureDeviceInput
            input = try AVCaptureDeviceInput(device: captureDevice)
                captureSession.addInput(input)
                
                let metadataOutput = AVCaptureMetadataOutput()
                captureSession.addOutput(metadataOutput)
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.qr]
                
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                videoPreviewLayer.videoGravity = .resizeAspectFill
                videoPreviewLayer.frame = qrView.layer.bounds
                qrView.layer.addSublayer(videoPreviewLayer)
                captureSession.startRunning()
                setCenterGuideLineView()
            } catch {
                print("error")
            }
        }
    }
    
    func setCenterGuideLineView() {
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
