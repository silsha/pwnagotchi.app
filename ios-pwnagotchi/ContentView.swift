//
//  ContentView.swift
//  ios-pwnagotchi
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
    @State var name = "Hi :3"
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text(face)
                    .font(.system(size: 500, design: .monospaced))
                    .minimumScaleFactor(0.1)
                    .lineLimit(1)
                    .padding(.vertical, 30.0)
                    .padding(.trailing, 60.0)
                    .frame(maxWidth: .infinity)
                Text(text)
                    .font(.system(size: 60))
                    .minimumScaleFactor(0.5)
                    .lineLimit(3)
                    .padding(.all, 30.0)
                    .frame(maxHeight: 150.0)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                Button(
                    action: { self.connectBtn() },
                    label: { Text(button)
                        .font(.system(size:40))
                }
                )
                HStack(alignment: .bottom) {
                    Text("Uptime: \(uptime)")
                        .font(.body)
                        .lineLimit(1)
                        .padding(.bottom, 10.0)
                }
                
            }
            .navigationBarTitle(self.titlebar)
            .navigationBarItems(trailing:
                NavigationLink(destination: SettingsView()) {Text("Settings")}
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
        self.titlebar = "PWND: " + self.curses + " (" + self.total + ") | " + self.mode
        let host = UserDefaults.standard.string(forKey: "hostname") ?? "172.20.10.6"
        let username = UserDefaults.standard.string(forKey: "username") ?? ""
        let password = UserDefaults.standard.string(forKey: "password") ?? ""
        guard let url = URL(string: "http://" + username + ":" + password + "@" + host + ":8080/plugins/state-api/json") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in guard let data = data else { return }
            do {
                self.button = "Disconnect"
                // make sure this JSON is in the format we expect
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // try to read out a string array
                    self.face = json["face"] as! String
                    self.text = json["status"] as! String
                    self.curses = json["pwnd_run"] as! String
                    self.total = String(json["pwnd_tot"] as! Int)
                    self.mode = json["mode"] as! String
                    self.uptime = json["uptime"] as! String
                    self.name = json["name"] as! String
                    self.getFace()
                }
            } catch let error as NSError {
                self.text = "Couldn't connect."
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
