//
//  QRViewfinderView.swift
//  SearchFeature
//
//  Created by 유지호 on 6/19/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import Core

import UIKit
import AVFoundation
import RxSwift
import RxRelay

public final class QRReaderView: UIView {
    
    private lazy var readerArea = UIView()
    
    private lazy var leftDimmedView = UIView()
    private lazy var rightDimmedView = UIView()
    private lazy var topDimmedView = UIView()
    private lazy var bottomDimmedView = UIView()
    
    private let captureSession = AVCaptureSession()
    private lazy var videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    
    public let qrUrl = PublishRelay<URL>()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUIProperty()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func setQRReader() {
        guard captureSession.inputs.isEmpty, captureSession.outputs.isEmpty else { return }
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            
            let output = AVCaptureMetadataOutput()
            captureSession.addOutput(output)
            
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            output.metadataObjectTypes = [.qr]
            
            videoPreviewLayer.frame = self.frame
            videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            
            // 제한하고 싶은 영역
            let rect = CGRect(
                x: (self.frame.width - 150) / 2,
                y: (self.frame.height - 150) / 2,
                width: 150,
                height: 150
            )
            
            let rectConverted = videoPreviewLayer.metadataOutputRectConverted(fromLayerRect: rect)
            
            output.rectOfInterest = rectConverted
            
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.captureSession.startRunning()
            }
        } catch {
            print("Error to set QR Reader")
        }
    }
    
    private func setUIProperty() {
        self.backgroundColor = .clear
        
        readerArea = {
            let view = UIView()
            view.backgroundColor = nil
            view.border(.tintColor, width: 0.5, radius: 0.0)
            return view
        }()
        
        [leftDimmedView, rightDimmedView, topDimmedView, bottomDimmedView].forEach {
            $0.backgroundColor = .black
            $0.alpha = 0.4
        }
    }
    
    private func setLayout() {
        self.layer.addSublayer(videoPreviewLayer)
        self.addSubviews(readerArea, leftDimmedView, rightDimmedView, topDimmedView, bottomDimmedView)
        
        readerArea.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(150)
        }
        
        leftDimmedView.snp.makeConstraints { make in
            make.left.verticalEdges.equalToSuperview()
            make.right.equalTo(readerArea.snp.left)
        }
        
        rightDimmedView.snp.makeConstraints { make in
            make.right.verticalEdges.equalToSuperview()
            make.left.equalTo(readerArea.snp.right)
        }
        
        topDimmedView.snp.makeConstraints { make in
            make.left.equalTo(leftDimmedView.snp.right)
            make.right.equalTo(rightDimmedView.snp.left)
            make.top.equalToSuperview()
            make.bottom.equalTo(readerArea.snp.top)
        }
        
        bottomDimmedView.snp.makeConstraints { make in
            make.left.equalTo(leftDimmedView.snp.right)
            make.right.equalTo(rightDimmedView.snp.left)
            make.top.equalTo(readerArea.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
}


extension QRReaderView: AVCaptureMetadataOutputObjectsDelegate {
    
    public func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        guard let metaDataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let urlString = metaDataObject.stringValue,
              urlString.hasPrefix("http://"),
              let url = URL(string: urlString)
        else {
            return
        }
        
        qrUrl.accept(url)
    }
    
}
