//
//  ContentView.swift
//  BarcodeScanner
//
//  Created by Navami Ajay on 08/11/23.
//

import SwiftUI

struct BarcodeScannerView: View {
    @State private var scannedCode:String = ""
    
    var body: some View {
        NavigationStack{
            VStack {
                ScannerView(scannedCode: $scannedCode)
                    .frame(maxWidth: .infinity, maxHeight: 300)
                Label("Scanned Barcode", systemImage: "barcode.viewfinder")
                    .padding(.top,50)
                Text(scannedCode.isEmpty ? "Not Yet Scanned" : scannedCode)
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(scannedCode.isEmpty ? .red : .green)
                    .padding()
            }
            .navigationTitle("Barcode Scanner")
            
        }
        
    }
}

#Preview {
    BarcodeScannerView()
}
