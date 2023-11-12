//
//  MenuBarView.swift
//  Scan&Save
//
//  Created by Blaž Osredkar on 28. 10. 23.
//

import SwiftUI

struct MenuBarView: View {
    
    @Binding var showSignInView: Bool
    var body: some View {
        
        TabView {
            HomeView()
                .tabItem() {
                    Image(systemName: "house")
                    Text("Home")
                }
            QRCodeView()
                .tabItem() {
                    Image(systemName: "qrcode.viewfinder")
                    Text("Scan QR")
                }
            SettingsView(showSignInView: $showSignInView)
                .tabItem() {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}

#Preview {
    MenuBarView(showSignInView: .constant(false))
}
