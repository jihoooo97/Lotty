//
//  QRReaderView.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/21.
//

import UIKit
import AVFoundation

final class QRReaderView: UIView {

    private var squreLine = UIView()
    private var leftBoard = UIView()
    private var rightBoard = UIView()
    private var topBoard = UIView()
    private var bottomBoard = UIView()
    
    private var captureSession = AVCaptureSession()
    var videoPreviewLayer = AVCaptureVideoPreviewLayer()
    
    private let delegate: AVCaptureMetadataOutputObjectsDelegate
    
    
    init(delegate: AVCaptureMetadataOutputObjectsDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        
        initAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setVideoLayer(rect: CGRect) -> CGRect{
        let width = UIScreen.main.bounds.width
        let height: CGFloat = 250
        
        // 영상을 담을 공간.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        //카메라의 크기 지정
        videoPreviewLayer.frame = CGRect(
            x: 0, y: 0, width: width, height: height
        )
        //카메라의 비율지정
        videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        layer.addSublayer(videoPreviewLayer)
        
        return videoPreviewLayer.metadataOutputRectConverted(fromLayerRect: rect)
    }

    func setBarcodeReader() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            
            let output = AVCaptureMetadataOutput()
            captureSession.addOutput(output)
            
            output.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
            output.metadataObjectTypes = [.qr]
            
            // 제한하고 싶은 영역
            let rect = CGRect(
                x: ((self.frame.width) - 150) / 2,
                y: 50,
                width: 150, height: 150
            )
            let rectConverted = self.setVideoLayer(rect: rect)
            output.rectOfInterest = rectConverted
            self.initConstraints()
            
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.captureSession.startRunning()
            }
        } catch {
            print("error")
        }
    }
    
    private func initAttributes() {
        backgroundColor = .clear
        
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
    }
    
    private func initConstraints() {
        [squreLine, leftBoard, rightBoard, topBoard, bottomBoard].forEach {
            self.addSubview($0)
        }
        
        squreLine.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(150)
        }
        
        leftBoard.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview()
            $0.right.equalTo(squreLine.snp.left)
        }
        
        rightBoard.snp.makeConstraints {
            $0.right.top.bottom.equalToSuperview()
            $0.left.equalTo(squreLine.snp.right)
        }
        
        topBoard.snp.makeConstraints {
            $0.left.right.equalTo(squreLine)
            $0.top.equalToSuperview()
            $0.bottom.equalTo(squreLine.snp.top)
        }
        
        bottomBoard.snp.makeConstraints {
            $0.left.right.equalTo(squreLine)
            $0.top.equalTo(squreLine.snp.bottom)
            $0.bottom.equalToSuperview()
        }
    }
    
}
