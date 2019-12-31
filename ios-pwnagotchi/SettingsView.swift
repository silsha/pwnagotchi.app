//
//  SettingsView.swift
//  ios-pwnagotchi
//
//  Created by Silsha Fux on 23.12.2019.
//  Copyright © 2019 fnordcordia. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @State private var hostname: String = "172.20.10.6"
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        
        let hostnamebinding = Binding<String>(get: {
            (UserDefaults.standard.string(forKey: "hostname") ?? "172.20.10.6")
        }, set: {
            self.hostname = $0.trimmingCharacters(in: .whitespacesAndNewlines)
            UserDefaults.standard.set(self.hostname, forKey: "hostname")
        })
        
        let userbinding = Binding<String>(get: {
            UserDefaults.standard.string(forKey: "username") ?? ""
        }, set: {
            self.username = $0
            UserDefaults.standard.set(self.username, forKey: "username")
        })
        
        let passwordbinding = Binding<String>(get: {
            UserDefaults.standard.string(forKey: "password") ?? ""
        }, set: {
            self.password = $0
            UserDefaults.standard.set(self.password, forKey: "password")
        })
        
        return NavigationView {
            VStack {
                Form {
                    Section(header: Text("WebUI Credentials")){
                        TextField("Hostname", text: hostnamebinding)
                            .textContentType(.URL)
                        TextField("Username", text: userbinding)
                            .textContentType(.username)
                            .autocapitalization(.none)
                        SecureField("Password", text: passwordbinding)
                            .textContentType(.password)
                    }
                }
            } .navigationBarTitle("Settings")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SettingsRow : View {
    var label: String
    var value: String

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(label).font(.subheadline)
                Spacer()
                Text(value).font(.body)
            }
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
