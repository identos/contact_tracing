//
// Created by Leigh Williams on 2020-04-04.
// Copyright (c) 2020 Identos. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit

fileprivate let kIdentifier = "identifier"
fileprivate let kHasJoined = "hasJoined"
fileprivate let kContactPayloads = "contactPayloads"
fileprivate let kPhoneNumber = "phoneNumber"

extension UserDefaults {

    var appUUID: UUID? {
        get {
            UIDevice.current.identifierForVendor
        }
    }

    var phoneNumber: String? {
        get {
            string(forKey: kPhoneNumber)
        }
        set(number) {
            set(number, forKey: kPhoneNumber)
        }
    }

    var hasJoined: Bool {
        get {
            bool(forKey: kHasJoined)
        }
        set (joined){
            set(true, forKey: kHasJoined)
        }
    }

    var contacts: [ContactPayload] {
        get {
            if let payloadsData = data(forKey: kContactPayloads),
            let payloads = try? JSONDecoder().decode([ContactPayload].self, from: payloadsData){
                return payloads
            } else{
               return  [ContactPayload]()
            }

        }
        set(contacts) {
            set(try! JSONEncoder().encode(contacts), forKey: kContactPayloads)
        }
    }

    func loadContactConfig() -> ContactConfig {
        ContactConfig(
            advertisementName: "ContactTracerAppIOS",
            identifier: UIDevice.current.identifierForVendor!,
            serviceCbuuid: CBUUID(string: "ba209999-0c6c-11d2-97cf-00c04f8eea40"),
            characteristicCbuuid: CBUUID(string: "ba209999-0c6c-11d2-97cf-00c04f8eea41"))
    }

    public func addContact(payload: ContactPayload) {
        var payloads = contacts
        payloads.append(payload)
        contacts = payloads
    }
}
