//
//  ContentView.swift
//  ios-pwnagotchi WatchKit Extension
//
//  Created by Silsha Fux on 23.12.2019.
//  Copyright © 2019 fnordcordia. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var facedata: FaceFetcher = FaceFetcher()
    
    var body: some View {
        VStack {
            Text(self.facedata.facedata.face)
                .font(.largeTitle)
                .fontWeight(.heavy)
                .multilineTextAlignment(.center)
                .padding(.top, 10.0)
            Text(self.facedata.facedata.status)
                .font(.caption)
                .lineLimit(3)
                .padding(.top, 10.0)
                .padding(.bottom, 30.0)
                .frame(height: 40.0)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
            Button(
                action: { self.facedata.connectBtn() },
                label: { Text(self.facedata.button) }
            )
                .padding(.bottom, 10.0)
            Spacer()
            HStack(alignment: .bottom) {
                if(self.facedata.facedata.pwnd_last != nil) {
                    Text("\(self.facedata.facedata.pwnd_last!)")
                        .font(.caption)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                }
                Text(self.facedata.facedata.uptime)
                    .font(.caption)
                    .multilineTextAlignment(.trailing)
                    .lineLimit(1)
            }
        }
        .navigationBarTitle(self.facedata.titlebar)
        .contextMenu {
            NavigationLink(destination: SettingsView()) {Text("Settings")}
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
