import SwiftUI
import CoreImage.CIFilterBuiltins

struct HomeView: View {
    @State private var deviceName = ""
    @State private var serialNumber = ""
    @State private var deviceType = ""
    @State private var generatedQRCode: UIImage? = nil

    var body: some View {
        VStack {
            TextField("Device Name", text: $deviceName)
                .padding()

            TextField("Serial Number", text: $serialNumber)
                .padding()

            TextField("Device Type", text: $deviceType)
                .padding()

            Button("Generate QR Code") {
                generateQRCode()
            }
            .padding()

            if let qrCode = generatedQRCode {
                Image(uiImage: qrCode)
                    .resizable()
                    .scaledToFit()
                    .padding()
            }
        }
        .padding()
        .background(Color.blue.edgesIgnoringSafeArea(.all))
    }

    func generateQRCode() {
        let dataString = "\(deviceName)\n\(serialNumber)\n\(deviceType)"

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            let data = dataString.data(using: .utf8)
            filter.setValue(data, forKey: "inputMessage")

            if let outputImage = filter.outputImage {
                let context = CIContext()

                let scale: CGFloat = 5.0 // Adjust the scale factor as needed
                let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: scale, y: scale))

                if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
                    let uiImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: .up)
                    generatedQRCode = uiImage

                    // Save QR code to the photo gallery
                    UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
