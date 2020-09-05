//
//  ViewController.swift
//  CameraExample
//
//  Created by JanFranco on 5.09.2020.
//  Copyright © 2020 janfranco. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
        
    private let captureSession = AVCaptureSession()
    
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let preview = AVCaptureVideoPreviewLayer(session: self.captureSession)
        preview.videoGravity = .resizeAspect
        return preview
    }()
    
    private let videoOutput = AVCaptureVideoDataOutput()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        accessCamera()
    }
    
    func accessCamera() {
        addCameraInput()
        addPreviewLayer()
        addVideoOutput()
        captureSession.startRunning()
    }
    
    private func addCameraInput() {
        guard let device = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .front)
        else {
            fatalError("no front camera. but don't all iOS 10 devices have them?")
        }
        
        let cameraInput = try! AVCaptureDeviceInput(device: device)
        captureSession.addInput(cameraInput)
    }
    
    private func addPreviewLayer() {
        self.view.layer.addSublayer(self.previewLayer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.previewLayer.frame = self.view.bounds
    }
    
    override func viewWillLayoutSubviews() {
        self.previewLayer.frame = self.view.bounds
        if previewLayer.connection!.isVideoOrientationSupported {
            self.previewLayer.connection!.videoOrientation = .landscapeLeft
        }
    }
    
    private func addVideoOutput() {
        videoOutput.videoSettings =
            [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "my.image.handling.queue"))
        captureSession.addOutput(self.videoOutput)
    }
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            debugPrint("unable to get image from sample buffer")
            return
        }
        
        print("did receive image frame")
        
        // process
    }
    
}
