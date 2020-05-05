//
//  ContactPayload.swift
//  ContactTracer
//
//  Created by Leigh Williams on 2020-03-27.
//  Copyright © 2020 Identos. All rights reserved.
//

import Foundation
import CoreBluetooth



public struct ContactPayload: Codable
{
    let nonce:String
    let aud:String
    let sub:String
    var received:Bool = true
    var date:Date = Date()

    func toCommaDelimited() -> String {
        return "\(nonce),\(aud),\(sub)"
    }

}

extension ContactPayload {
    public init(commDelimited:String) {
        let comps : [String] = commDelimited.components(separatedBy:",")
        nonce = comps[0]
        aud = comps[1]
        sub = comps[2]
    }
}
