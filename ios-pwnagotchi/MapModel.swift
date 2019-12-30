//
//  MapModel.swift
//  ios-pwnagotchi
//
//  Created by Silsha Fux on 30.12.2019.
//  Copyright © 2019 fnordcordia. All rights reserved.
//

import Combine
import Foundation

struct MapValue: Codable {
    public var ssid: String = ""
    public var mac: String = ""
    public var type: String = ""
    public var lng: Double = 0.0
    public var lat: Double = 0.0
    public var acc: Double = 0.0
    public var tsFirst: Int = 0
    public var tsLast: Int = 0
    public var pass: String?

    enum CodingKeys: String, CodingKey {
        case ssid, mac, type, lng, lat, acc, pass
        case tsFirst = "ts_first"
        case tsLast = "ts_last"
    }

    public init(ssid: String, mac: String, type: String, lng: Double, lat: Double, acc: Double, tsFirst: Int, tsLast: Int, pass: String?) {
        self.ssid = ssid
        self.mac = mac
        self.type = type
        self.lng = lng
        self.lat = lat
        self.acc = acc
        self.tsFirst = tsFirst
        self.tsLast = tsLast
        self.pass = pass
    }
}

typealias MapItems = [String: MapValue]
