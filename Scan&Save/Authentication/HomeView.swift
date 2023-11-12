import SwiftUI
import CoreImage.CIFilterBuiltins

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var deviceName = ""
    @Published var serialNumber = ""
    @Published var deviceType: String = ""

    
    @Published var error_text: String = ""
    @Published var showErrorAlert = false
    
    
    func signIn(){
        guard !deviceName.isEmpty, !serialNumber.isEmpty, !deviceType.isEmpty else {
            print("No email or password found")
            error_text = "Please fill in all fields to continue."
            showErrorAlert = true
            return
        }
        
        
    }
    
}


struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    @State private var generatedQRCode: UIImage? = nil

    var body: some View {
        ZStack {
            Color(red: 0.22, green: 0.34, blue: 0.96)
                .edgesIgnoringSafeArea(.top)
            VStack {
                HStack {
                    Image(systemName: "qrcode")
                    Text("QR code generator")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                VStack {
                    Text("Device name:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.white)
                    TextField("", text: $viewModel.deviceName, prompt: Text("Device name...").foregroundColor(.white))
                        .padding()
                        .background(Color(red: 0.37, green: 0.47, blue: 1.00))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 0.5)
                        )
                    
                    Spacer()
                        .frame(height: 20)
                    
                    Text("Serial number:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.white)
                    TextField("", text: $viewModel.serialNumber, prompt: Text("Serial number...").foregroundColor(.white))
                        .padding()
                        .background(Color(red: 0.37, green: 0.47, blue: 1.00))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 0.5)
                        )
                    
                    Spacer()
                        .frame(height: 20)
                    Text("Device type:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.white)
                    TextField("", text: $viewModel.deviceType, prompt: Text("Device type...").foregroundColor(.white))
                        .padding()
                        .background(Color(red: 0.37, green: 0.47, blue: 1.00))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 0.5)
                        )
                        
                    
                    Spacer()
                        .frame(height: 20)
    
                    Button {
                        viewModel.signIn()
                        generateQRCode()
                    } label: {
                        HStack {
                            Image(systemName: "qrcode")
                            Text("Generate QR code")
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(10)
                    }
                    
                    if let qrCode = generatedQRCode {
                        Image(uiImage: qrCode)
                            .resizable()
                            .scaledToFit()
                            .padding()
                    }
                }.alert(isPresented: $viewModel.showErrorAlert) {
                    Alert(
                        title: Text("Error"),
                        message: Text(viewModel.error_text),
                        dismissButton: .default(Text("OK")) {
                            // Handle OK button tap if needed
                        }
                    )
                }
                .padding()
            }
            .padding()
        }
    }

    func generateQRCode() {
        let dataString = "\(viewModel.deviceName)\n\(viewModel.serialNumber)\n\(viewModel.deviceType)"

        guard let filter = CIFilter(name: "CIQRCodeGenerator"),
              let data = dataString.data(using: .utf8) else {
            // Handle the case where the filter or data is nil
            print("Error: Unable to create filter or convert data.")
            return
        }

        filter.setValue(data, forKey: "inputMessage")

        guard let outputImage = filter.outputImage else {
            // Handle the case where the output image is nil
            print("Error: Unable to generate QR code image.")
            return
        }

        let context = CIContext()

        let scale: CGFloat = 5.0 // Adjust the scale factor as needed
        let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: scale, y: scale))

        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else {
            // Handle the case where the CGImage is nil
            print("Error: Unable to create CGImage from scaled image.")
            return
        }

        let uiImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: .up)
        generatedQRCode = uiImage

        // Save QR code to the photo gallery
        UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
        viewModel.deviceName = ""
        viewModel.serialNumber = ""
        viewModel.deviceType = ""
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
