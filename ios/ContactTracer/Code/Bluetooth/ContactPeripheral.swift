//
//  Bluetooth.swift
//  ContactTracer
//
//  Created by Leigh Williams on 2020-03-27.
//  Copyright © 2020 Identos. All rights reserved.
//

import Foundation
import CoreBluetooth

public protocol ContactPeripheralDelegate: ContactBluetoothDelegate {
    func payload(forRequest: CBATTRequest) -> Data
}

open class ContactPeripheral: NSObject {

    private var peripheralManager: CBPeripheralManager!
    private let config: ContactConfig!
    public var peripheralDelegate: ContactPeripheralDelegate!

    public init(config: ContactConfig!) {
        self.config = config
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }

    public func start() {

        guard !peripheralManager.isAdvertising else {
            print("ContactPeripheral: Already Advertising")
            return
        }

        print("ContactPeripheral: Start")
        let characteristic = CBMutableCharacteristic(
            type: config.characteristicCbuuid,
            properties: [.read],
            value: nil,
            permissions: [.readable])

        let service = CBMutableService(type: config.serviceCbuuid, primary: true)
        service.characteristics = [characteristic]
        peripheralManager.add(service)
        advertise()
    }


    func advertise() {
        peripheralManager.startAdvertising(
            [CBAdvertisementDataLocalNameKey: config.advertisementName, CBAdvertisementDataServiceUUIDsKey: [config.serviceCbuuid]])

    }

    public func stop() {

        guard peripheralManager.isAdvertising else {
            print("ContactPeripheral: Not Advertising")
            return
        }

        print("ContactPeripheral: Stop")
        peripheralManager.removeAllServices()
        peripheralManager.stopAdvertising()
    }

}

extension ContactPeripheral: CBPeripheralManagerDelegate {

    public func peripheralManager(_ peripheral: CBPeripheralManager,
                                  didReceiveRead request: CBATTRequest) {
        print("ContactPeripheral: didReceiveRead")
        request.value = peripheralDelegate.payload(forRequest: request)
        peripheral.respond(to: request, withResult: .success)

    }

    public func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print("ContactPeripheral: peripheralManagerDidUpdateState")
        peripheralDelegate.bluetoothStatusUpdated(state: peripheral.state)
    }
}

