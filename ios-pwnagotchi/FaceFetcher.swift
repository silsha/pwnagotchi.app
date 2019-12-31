//
//  FaceFetcher.swift
//  ios-pwnagotchi
//
//  Created by Silsha Fux on 25.12.2019.
//  Copyright © 2019 fnordcordia. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

public class FaceFetcher: ObservableObject {
    @Published var facedata = Face()
    @Published var button : String = "Connect"
    @Published var titlebar : String = "Not connected"
    
    @Published var running : Bool = false
    
    
    let willChange = PassthroughSubject<Void, Never>()
    
    init() {
        return
    }
    
    func load() {
        let host = UserDefaults.standard.string(forKey: "hostname") ?? "172.20.10.6"
        let username = UserDefaults.standard.string(forKey: "username")?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let password = UserDefaults.standard.string(forKey: "password")?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let path = "http://" + username + ":" + password + "@" + host + ":8080/plugins/state-api/json"
        let url = URL(string: path)
        
        URLSession.shared.dataTask(with: url!) {(data,response,error) in
            if ((error) != nil) {
                DispatchQueue.main.async {
                    self.facedata.face = "(☓‿‿☓)"
                    self.facedata.status = "Could not connect."
                    self.button = "Connect"
                    self.running = false
                }
                return
            }
            do {
                if (self.running == true) {
                    DispatchQueue.main.async {
                        self.button = "Disconnect"
                    }
                }
                if let d = data {
                    let decodedFace = try JSONDecoder().decode(Face.self, from: d)
                    DispatchQueue.main.async {
                        self.facedata = decodedFace
                        if (self.running == true) {
                            #if os(watchOS)
                                self.titlebar = "\(self.facedata.pwnd_run)/\(self.facedata.pwnd_tot) \(self.facedata.mode)"
                            #else
                                self.titlebar = "PWND: \(self.facedata.pwnd_run) (\(self.facedata.pwnd_tot)) | \(self.facedata.mode)"
                            #endif
                            self.load()
                        }
                    }
                } else {
                    print("No Data")
                }
            } catch {
                print(error)
                DispatchQueue.main.async {
                    self.facedata.face = "(☓‿‿☓)"
                    self.facedata.status = "Something went wrong."
                    self.button = "Connect"
                    self.running = false
                }
            }
        }.resume()
    }
    
    func connectBtn() {
        if self.running == false {
            self.button = "Connecting …"
            self.running = true
            self.load()
        } else {
            self.running = false
            self.button = "Connect"
            self.titlebar = "Not connected"
            return
        }
    }
}
