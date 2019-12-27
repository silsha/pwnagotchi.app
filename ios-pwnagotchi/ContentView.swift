//
//  ContentView.swift
//  ios-pwnagotchi
//
//  Created by Silsha Fux on 23.12.2019.
//  Copyright © 2019 fnordcordia. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var facedata: FaceFetcher = FaceFetcher()
    @State var showWarning : Bool = false
    
    var body: some View {
        
        let showWarningBinding = Binding<Bool>(get: {
            return (UserDefaults.standard.string(forKey: "username") == nil || UserDefaults.standard.string(forKey: "username") == "")
        }, set: {
            self.showWarning = $0
        })
        
        return NavigationView {
            VStack {
                Text(self.facedata.facedata.lastshake)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 18.0)
                Spacer()
                Text(self.facedata.facedata.face)
                    .font(.system(size: 100, design: .monospaced))
                    .minimumScaleFactor(0.1)
                    .lineLimit(1)
                    .frame(width: UIScreen.main.bounds.width, alignment: .center)
                    .scaledToFill()
                    .fixedSize(horizontal: true, vertical: true)
                Text(self.facedata.facedata.status)
                    .font(.system(size: 60))
                    .minimumScaleFactor(0.5)
                    .lineLimit(3)
                    .padding(.all, 30.0)
                    .frame(maxHeight: 150.0, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                if(self.facedata.facedata.friend_name_text != nil) {
                    Text("\(self.facedata.facedata.friend_face_text ?? "") \(self.facedata.facedata.friend_name_text ?? "")")
                }
                Button(
                    action: { self.facedata.connectBtn()},
                    label: { Text(self.facedata.button)
                        .font(.system(size:40))
                }
                )
                HStack(alignment: .bottom) {
                    Text("Uptime: \(self.facedata.facedata.uptime)")
                        .font(.body)
                        .lineLimit(1)
                        .padding(.bottom, 10.0)
                }

            }
            .navigationBarTitle(self.facedata.titlebar)
            .navigationBarItems(trailing:
                NavigationLink(destination: SettingsView()) {Text("Settings")}
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .alert(isPresented: showWarningBinding) {
            Alert(title: Text("No credentials found. Please enter them in the settings menu."))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
