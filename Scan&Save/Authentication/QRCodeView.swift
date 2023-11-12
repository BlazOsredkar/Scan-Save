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
                print("Name: \(name), Serial Number: \(serialNumber), Device Type: \(deviceType)")

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

            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.frame = scannerView.layer.bounds
            previewLayer.videoGravity = .resizeAspectFill
            scannerView.layer.addSublayer(previewLayer)

            viewController.view.addSubview(scannerView)

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
            VStack {
                if let code = scannedCode {
                    Text("Scanned Code: \(code)")
                        .padding()

                    Button("Scan Again") {
                        // Clear the scanned code and allow scanning again
                        self.scannedCode = nil
                        self.isScanning = true
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
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeView()
    }
}
