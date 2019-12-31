//
//  MapFetcher.swift
//  ios-pwnagotchi
//
//  Created by Silsha Fux on 30.12.2019.
//  Copyright © 2019 fnordcordia. All rights reserved.
//

import Foundation
import Combine
import SwiftUI
import MapKit

public class MapFetcher: ObservableObject {
    @Published var mapitems = MapItems()
    @Published var showError = false
    @Published var connectBtn = "Reload data"
    
    init() {
        return
    }
    
    func load() {
        let host = UserDefaults.standard.string(forKey: "hostname") ?? "172.20.10.6"
        let username = UserDefaults.standard.string(forKey: "username")!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! ?? ""
        let password = UserDefaults.standard.string(forKey: "password")!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! ?? ""
        let path = "http://" + username + ":" + password + "@" + host + ":8080/plugins/webgpsmap/all"
        let url = URL(string: path)
        DispatchQueue.main.async {
            self.showError = false
            self.connectBtn = "Reloading …"
        }
        
        URLSession.shared.dataTask(with: url!) {(data,response,error) in
            do {
                DispatchQueue.main.async {
                    self.connectBtn = "Reload data"
                }
                if let d = data {
                    let decodedLists = try JSONDecoder().decode(MapItems.self, from: d)
                    DispatchQueue.main.async {
                        self.mapitems = decodedLists
                    }
                    print("Got locations")
                }else {
                    DispatchQueue.main.async {
                        self.showError = true
                    }
                    print("No Data")
                }
            } catch {
                DispatchQueue.main.async {
                    self.showError = true
                }
                print(error)
                print ("Error")
            }
            
        }.resume()
    }
}
