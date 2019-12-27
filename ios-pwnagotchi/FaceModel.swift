//
//  FaceModel.swift
//  ios-pwnagotchi
//
//  Created by Silsha Fux on 25.12.2019.
//  Copyright © 2019 fnordcordia. All rights reserved.
//

import Combine

struct Face: Codable {
    public var aps_on_channel: Int = 0
    public var apt_tot: Int = 0
    public var channel: Int = 0
    public var epoch: Int = 0
    public var face: String = "(^‿‿^)"
    public var friend_face_text: String? = ""
    public var friend_name_text: String? = ""
    public var lastshake: String = ""
    public var mode: String = ""
    public var name: String = ""
    public var pwnd_run: String = ""    // Not sure why this is a string in state-api
    public var pwnd_tot: Int = 0
    public var status: String = "Please connect."
    public var uptime: String = "00:00:00"
    public var version: String = ""
}
