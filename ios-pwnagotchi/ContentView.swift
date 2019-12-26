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
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text(self.facedata.facedata.face)
                    .font(.system(size: 500, design: .monospaced))
                    .minimumScaleFactor(0.1)
                    .lineLimit(1)
                    .padding(.vertical, 30.0)
                    .padding(.trailing, 60.0)
                    .frame(maxWidth: .infinity)
                Text(self.facedata.facedata.status)
                    .font(.system(size: 60))
                    .minimumScaleFactor(0.5)
                    .lineLimit(3)
                    .padding(.all, 30.0)
                    .frame(maxHeight: 150.0)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                if(self.facedata.facedata.friend_name_text != "") {
                Text("\(self.facedata.facedata.friend_face_text) \(self.facedata.facedata.friend_name_text)")
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
