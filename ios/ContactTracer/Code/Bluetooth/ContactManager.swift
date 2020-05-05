//
// Created by Leigh Williams on 2020-04-01.
// Copyright (c) 2020 Identos. All rights reserved.
//

import Foundation
import CoreBluetooth

extension CBPeripheralState {
    var stringRepresentation: String {
        switch self {
        case .disconnected: return "disconnected"
        case .connected: return "connected"
        case .connecting: return "connecting"
        case .disconnecting: return "disconnecting"
        @unknown default: return "unknown"
        }
    }
}

public protocol ContactBluetoothDelegate {
    func bluetoothStatusUpdated(state: CBManagerState)
}


open class ContactManager: NSObject, ContactPeripheralDelegate, ContactScannerDelegate {

    private let config: ContactConfig!
    private let peripheral: ContactPeripheral!
    private let scanner: ContactScanner!
    private let userInfo = UserDefaults.standard

    public var delegate: ContactBluetoothDelegate!
    private var bluetoothState = CBManagerState.unknown

    public init(config: ContactConfig) {
        self.config = config
        peripheral = ContactPeripheral(config: config)
        scanner = ContactScanner(config: config)
        super.init()
        scanner.delegate = self
        peripheral.peripheralDelegate = self
    }

    public func bluetoothStatusUpdated(state: CBManagerState) {

        guard bluetoothState != state else {
            return
        }

        bluetoothState = state

        switch bluetoothState {

        case .unknown, .resetting, .unsupported, .unauthorized, .poweredOff:
            scanner.stop()
            peripheral.stop()
        case .poweredOn:
            scanner.start()
            peripheral.start()
        @unknown default:
            fatalError("Invalid state")
        }

        delegate.bluetoothStatusUpdated(state: bluetoothState)
    }

    public func received(data: Data, fromPeripheral peripheral: UUID) {
        let delimited = String(data: data, encoding: .utf8)!
        let payload = ContactPayload(commDelimited: delimited)
        userInfo.addContact(payload: payload)
        NotificationCenter.default.post(name: .payload, object: nil)
    }


    public func payload(forRequest: CBATTRequest) -> Data {
        let payload = ContactPayload(
            nonce: UUID().uuidString,
            aud: "ios",
            sub: config.identifier.uuidString,
            received: false,
            date: Date())
        userInfo.addContact(payload: payload)
        NotificationCenter.default.post(name: .payload, object: nil)
        return payload.toCommaDelimited().data(using: .utf8)!
    }
}
