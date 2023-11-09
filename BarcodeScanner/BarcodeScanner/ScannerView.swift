//
//  ScannerView.swift
//  BarcodeScanner
//
//  Created by Navami Ajay on 09/11/23.
//

import SwiftUI

struct ScannerView: UIViewControllerRepresentable {
    @Binding var scannedCode: String
    func makeCoordinator() -> Coordinator {
        Coordinator(scannerView: self)
    }
    
    func makeUIViewController(context: Context) -> ScannerVC {
        ScannerVC(scannerDelegate: context.coordinator)
    }
    
    func updateUIViewController(_ uiViewController: ScannerVC, context: Context) {
        
    }
    
    final class Coordinator: NSObject,ScannerVCDelegate {
        private let scannerView: ScannerView
        init(scannerView: ScannerView) {
            self.scannerView = scannerView
        }
        func didFind(barcode: String) {
            scannerView.scannedCode = barcode
        }
        
        func didSurface(error: cameraError) {
            print(error.rawValue)
        }
        
        
    }
    
    //typealias UIViewControllerType = ScannerVC
    
    
}

#Preview {
    ScannerView(scannedCode: .constant("scannedCode"))
}
