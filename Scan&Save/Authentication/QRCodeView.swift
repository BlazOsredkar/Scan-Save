import SwiftUI
import AVFoundation

struct QRCodeScannerView: UIViewControllerRepresentable {
    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: QRCodeScannerView

        init(parent: QRCodeScannerView) {
            self.parent = parent
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                self.found(code: stringValue)
            }
        }

        func found(code: String) {
            // Stop the session when a QR code is found
            parent.session.stopRunning()

            // Parse QR code data (assuming it's a comma-separated string)
            let components = code.components(separatedBy: "\n")
            print(components)
            if components.count == 3 {
                let name = components[0]
                let serialNumber = components[1]
                let deviceType = components[2]

                // Do something with the extracted data
                let code = "Name: \(name), \nSerial Number: \(serialNumber), \nDevice Type: \(deviceType)"

                // Pass the scanned code to the callback
                parent.didFindCode(code)
            } else {
                print("Invalid QR code format")
            }
        }
    }

    var didFindCode: (String) -> Void
    @Binding var isScanning: Bool

    // Declare AVCaptureSession as a property
    var session = AVCaptureSession()

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let scannerView = UIView()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            print("No video capture device available")
            return viewController
        }

        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            session.addInput(videoInput)
        } catch {
            print("Error creating video input: \(error)")
            return viewController
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]

            viewController.view.addSubview(scannerView)

            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = viewController.view.layer.bounds
            scannerView.layer.addSublayer(previewLayer)

            DispatchQueue.global(qos: .userInitiated).async {
                if isScanning {
                    session.startRunning()
                    print("Session started running on background thread")
                }
            }

        } else {
            print("Cannot add metadata output to session")
        }

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct QRCodeView: View {
    
    @State private var scannedCode: String?
    @State private var isScanning = true

    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.22, green: 0.34, blue: 0.96)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    if let code = scannedCode {
                        Text("Scanned Code: \n\(code)")
                            .font(.system(size: 30))
                            
                        
                        Button {
                            // Clear the scanned code and allow scanning again
                            self.scannedCode = nil
                            self.isScanning = true
                        }label: {
                            HStack {
                                Image(systemName: "qrcode")
                                Text("Scan QR code again")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                            }
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding(20)
                        }
                        .padding()
                    } else {
                        QRCodeScannerView(didFindCode: { code in
                            // Handle the QR code data
                            print("Scanned code: \(code)")
                            
                            // Set the scanned code to update the UI
                            self.scannedCode = code
                            self.isScanning = false
                        }, isScanning: $isScanning)
                        .navigationBarTitle("QR Code Scanner")
                        .edgesIgnoringSafeArea(.top)
                    }
                }.edgesIgnoringSafeArea(.horizontal)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeView()
    }
}
