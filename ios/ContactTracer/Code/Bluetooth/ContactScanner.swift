//
//  BluetoothScanner.swift
//  ContactTracer
//
//  Created by Leigh Williams on 2020-03-27.
//  Copyright © 2020 Identos. All rights reserved.
//

import Foundation
import CoreBluetooth

public protocol ContactScannerDelegate: ContactBluetoothDelegate {
    func received(data: Data, fromPeripheral: UUID)
}

open class ContactScanner: NSObject {

    private let centralManager: CBCentralManager!
    private let config: ContactConfig!
    public var delegate: ContactScannerDelegate!
    private let scannerInfo = UserDefaults.standard
    private var peripherals = [CBPeripheral]()

    public init(config: ContactConfig!) {
        self.config = config
        centralManager = CBCentralManager(delegate: nil, queue: DispatchQueue.main)
        super.init()
        centralManager.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(onRescan(_:)), name: .reScan, object: nil)
    }

    @objc func onRescan(_ notification: Notification)
    {
        peripherals.removeAll()
        stop()
        start()
    }

    func stop() {
        if centralManager.isScanning {
            print("ContactScanner: Stop Scanning")
            centralManager.stopScan()
        }
    }

    func start() {
        if !centralManager.isScanning {
            print("ContactScanner: Start Scanning")
            centralManager.scanForPeripherals(withServices: [config.serviceCbuuid],
                options: nil)
        }
    }
}

extension ContactScanner: CBCentralManagerDelegate {

    open func centralManagerDidUpdateState(_ central: CBCentralManager) {
        delegate.bluetoothStatusUpdated(state: central.state)
    }

    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("ContactScanner: didConnect: \(peripheral.identifier)")
        peripheral.delegate = self
        peripheral.discoverServices([config.serviceCbuuid])
    }

    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        print("ContactScanner: didDiscover: \(peripheral.identifier)")
        if peripherals.first(where: { $0.identifier == peripheral.identifier }) == nil {
            print("ContactScanner: connect To: \(peripheral.identifier)")
            peripherals.append(peripheral)
            centralManager.connect(peripheral)
        }
    }

}


extension ContactScanner: CBPeripheralDelegate {

    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("ContactScanner: didDiscoverServices")
        guard let services = peripheral.services,
              let service = services.first(where: { $0.uuid == config.serviceCbuuid }) else {
            print("ContactScanner: No valid service found")
            return
        }
        peripheral.discoverCharacteristics([config!.characteristicCbuuid], for: service)

    }

    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {

        print("ContactScanner: didDiscoverCharacteristicsFor")
        guard let characteristics = service.characteristics,
              let characteristic = characteristics.first(where: { $0.uuid == config.characteristicCbuuid }) else {
            print("ContactScanner: No valid characteristic found")
            return
        }

        peripheral.readValue(for: characteristic)
    }

    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic,
                           error: Error?) {

        print("ContactScanner: didUpdateValueFor")
        guard let data = characteristic.value else {
            print("ContactScanner: No data found")
            return
        }

        delegate.received(data: data, fromPeripheral: peripheral.identifier)
    }
}


