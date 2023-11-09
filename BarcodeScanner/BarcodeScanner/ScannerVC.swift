//
//  ScannerVC.swift
//  BarcodeScanner
//
//  Created by Navami Ajay on 08/11/23.
//

import UIKit
import AVFoundation

enum cameraError: String {
    case invalidDeviceInput = "Something is wrong with the camera, unable to scan the input"
    case invalidScannedValue = "value scanned is not valid. it must either be ean 8 or ean 13"
}



protocol ScannerVCDelegate: AnyObject {
    func didFind(barcode:String) // takes the scanned barcode to the controller, which passes it to the swift ui
    func didSurface(error: cameraError)
}

final class ScannerVC : UIViewController{
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    weak var scannerDelegate: ScannerVCDelegate?
    
    init(scannerDelegate: ScannerVCDelegate){
        self.scannerDelegate = scannerDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let previewLayer = previewLayer else {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        previewLayer.frame = view.layer.bounds
    }
    
    private func setupCaptureSession() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else{
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        let videoInput: AVCaptureDeviceInput
        
        do{
            try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if captureSession.canAddInput(videoInput){
            captureSession.addInput(videoInput)
        } else {
            scannerDelegate?.didSurface(error: .invalidScannedValue)
            return
        }
        let metaDataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metaDataOutput) {
            captureSession.addOutput(metaDataOutput)
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDataOutput.metadataObjectTypes = [.ean8, .ean13]
        } else {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer!.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer!)
        
        captureSession.startRunning()
    }
    
}

extension ScannerVC: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let object = metadataObjects.first else {
            scannerDelegate?.didSurface(error: .invalidScannedValue)
            return
        }
        guard let machineReadableObject = object as? AVMetadataMachineReadableCodeObject else {
            scannerDelegate?.didSurface(error: .invalidScannedValue)
            return
        }
        guard let barcode = machineReadableObject.stringValue else{
            scannerDelegate?.didSurface(error: .invalidScannedValue)
            return
        }
        captureSession.stopRunning()
        scannerDelegate?.didFind(barcode: barcode)
    }
}
