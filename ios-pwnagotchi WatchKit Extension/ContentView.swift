//
//  ContentView.swift
//  ios-pwnagotchi WatchKit Extension
//
//  Created by Silsha Fux on 23.12.2019.
//  Copyright © 2019 fnordcordia. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var face = "(ᵔ◡◡ᵔ)"
    @State var text = "Please connect."
    @State var curses = "-"
    @State var total = "-"
    @State var mode = "?"
    @State var button = "Connect"
    @State var titlebar = "Not connected"
    @State var uptime = "00:00:00"
       
    var body: some View {
        VStack {
            Text(face)
                .font(.largeTitle)
                .fontWeight(.heavy)
                .multilineTextAlignment(.center)
                .padding(.top, 10.0)
            Text(text)
                .font(.caption)
                .lineLimit(3)
                .padding(.top, 10.0)
                .padding(.bottom, 30.0)
                .frame(height: 40.0)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
            Button(
                action: { self.connectBtn() },
                label: { Text(button) }
            )
            Spacer()
            HStack(alignment: .bottom) {
                Spacer()
                Text(uptime)
                    .font(.caption)
                    .multilineTextAlignment(.trailing)
                    .lineLimit(1)
                    .padding(.bottom, -10.0)
                    .padding(.trailing, 10.0)
            }
                
                
                
        }
        .navigationBarTitle(titlebar)
        .contextMenu {
            NavigationLink(destination: SettingsView()) {Text("Settings")}
        }
    }
    
    @State var running : Bool = false
    
    func connectBtn() {
        if self.running == false {
            self.button = "Connecting …"
            self.running = true
            self.getFace()
        } else {
            self.running = false
            self.button = "Connect"
            self.titlebar = "Not connected"
            return
        }
    }
    
    func getFace() {
        if (self.running == false) {
            return
        }
        self.button = "Disconnect"
        self.titlebar = self.curses + "/" + self.total + " | " + self.mode
        let host = UserDefaults.standard.string(forKey: "hostname") ?? "172.20.10.6"
        let username = UserDefaults.standard.string(forKey: "username") ?? ""
        let password = UserDefaults.standard.string(forKey: "password") ?? ""
        guard let url = URL(string: "http://" + username + ":" + password + "@" + host + ":8080/plugins/state-api/json") else { return }
        
            URLSession.shared.dataTask(with: url) { (data, response, error) in guard let data = data else { return }
                do {
                    // make sure this JSON is in the format we expect
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        // try to read out a string array
                        self.face = json["face"] as! String
                        self.text = json["status"] as! String
                        self.curses = json["pwnd_run"] as! String
                        self.total = String(json["pwnd_tot"] as! Int)
                        self.mode = json["mode"] as! String
                        self.uptime = json["uptime"] as! String
                        self.getFace()
                    }
                } catch let error as NSError {
                    self.text = "Couldn't connect"
                    self.face = "(☓‿‿☓)"
                    self.button = "Connect"
                    self.running = false
                    print("Failed to load: \(error.localizedDescription)")
                }
                
            }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
