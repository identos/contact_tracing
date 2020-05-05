import Foundation
import CoreBluetooth

let serviceCbuid = CBUUID(string: "ba209999-0c6c-11d2-97cf-00c04f8eea40")
let charCbuid = CBUUID(string: "ba209999-0c6c-11d2-97cf-00c04f8eea41")
let subUuid = UUID(uuidString: "ba209999-0c6c-11d2-97cf-000000000000")!

public struct ContactPayload: Codable
{
    let nonce:String
    let aud:String
    let sub:String

    func toCommaDelimited() -> String {
        return "\(nonce),\(aud),\(sub)"
    }

    static func fromCommaDelimited(commDelimited:String) -> ContactPayload {
        let comps : [String] = commDelimited.components(separatedBy:",")
        return ContactPayload(nonce: comps[0], aud: comps[1], sub: comps[2])
    }
}

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

open class BluetoothPeripheral: NSObject, CBPeripheralManagerDelegate {
    
    private var peripheralManager: CBPeripheralManager!
    
    override public init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    public func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
            case .unknown:
                print("Bluetooth Device is UNKNOWN")
            case .unsupported:
                print("Bluetooth Device is UNSUPPORTED")
            case .unauthorized:
                print("Bluetooth Device is UNAUTHORIZED")
            case .resetting:
                print("Bluetooth Device is RESETTING")
            case .poweredOff:
                print("Bluetooth Device is POWERED OFF")
            case .poweredOn:
                print("Bluetooth Device is POWERED ON")
                addServices()
            @unknown default:
                print("Unknown State")
            }
        }
    
    public func peripheralManager(_ peripheral: CBPeripheralManager,
                                    didReceiveRead request: CBATTRequest){
        
    let payloadString = ContactPayload(nonce: UUID().uuidString, aud:"http://authority.url", sub:subUuid.uuidString).toCommaDelimited()
    request.value = payloadString.data(using: .utf8)
    peripheral.respond(to:request, withResult:.success)
    }
    
    private var service: CBUUID!
    
    public func addServices(){
        
        let characteristic = CBMutableCharacteristic(type: CBUUID(string: "ba209999-0c6c-11d2-97cf-00c04f8eea41"), properties: [.read], value: nil, permissions: [.readable])
        service = CBUUID(string: "ba209999-0c6c-11d2-97cf-00c04f8eea40")
        let myService = CBMutableService(type: service, primary: true)
        myService.characteristics = [characteristic]
        peripheralManager.add(myService)
        startAdvertising()
        
    }
    
    
    public func startAdvertising(){
        peripheralManager.startAdvertising([CBAdvertisementDataLocalNameKey : "BLEPeripheralApp", CBAdvertisementDataServiceUUIDsKey :     [service]])
    }
}



open class BluetoothScanner: NSObject {

    private var centralManager: CBCentralManager!
    private var contactPeripheral: CBPeripheral?

    public override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    open func centralManagerDidUpdateState(_ central: CBCentralManager) {

        switch central.state {
        case .poweredOn:
            startScanning(central: central)
        case .poweredOff:
            stopScanning(central: central)
        default: break
        }

    }

    func stopScanning(central: CBCentralManager) {
        print("Start Scanning")
        central.stopScan()
    }

    func startScanning(central: CBCentralManager) {
        print("Start Scanning")
        central.scanForPeripherals(withServices: [CBUUID(string: "ba209999-0c6c-11d2-97cf-00c04f8eea40")], options: nil)
    }
}

extension BluetoothScanner: CBCentralManagerDelegate {

    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices([CBUUID(string: "ba209999-0c6c-11d2-97cf-00c04f8eea40")])
    }

    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        if(contactPeripheral == nil || contactPeripheral?.identifier != peripheral.identifier){
        contactPeripheral = peripheral
        centralManager.connect(peripheral)
        }
    }

}

extension BluetoothScanner: CBPeripheralDelegate {

    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {
            return
        }

        for service in services {
            peripheral.discoverCharacteristics([CBUUID(string: "ba209999-0c6c-11d2-97cf-00c04f8eea41")], for: service)
        }
    }

    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {

        guard let characteristics = service.characteristics else {
            return
        }

        for characteristic in characteristics {
            peripheral.readValue(for: characteristic)
        }

    }

    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic,
                           error: Error?) {


        let characteristicData = characteristic.value!
        let commaSeperated = String(data: characteristicData, encoding: .utf8)!
        let payload = ContactPayload.fromCommaDelimited(commDelimited: commaSeperated)
        centralManager.cancelPeripheralConnection(peripheral)
        print(payload)

    }
}

//let peripheral = BluetoothPeripheral()
let scanner = BluetoothScanner()


//        let payload = ContactPayload(nonce: UUID().uuidString, issuedAt: "Date().millisecondsSince1970", aud: "Aud", sub: "Sub")
//        let encoder = JSONEncoder()
//        request.value = try! encoder.encode(payload)
//        peripheral.respond(to:request, withResult:.success)

//
//
//open class BluetoothPeripheral: NSObject, CBPeripheralManagerDelegate {
//
//    private var peripheralManager: CBPeripheralManager!
//
//    override public init() {
//        super.init()
//        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
//    }
//
//    public func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
//        switch peripheral.state {
//            case .unknown:
//                print("Bluetooth Device is UNKNOWN")
//            case .unsupported:
//                print("Bluetooth Device is UNSUPPORTED")
//            case .unauthorized:
//                print("Bluetooth Device is UNAUTHORIZED")
//            case .resetting:
//                print("Bluetooth Device is RESETTING")
//            case .poweredOff:
//                print("Bluetooth Device is POWERED OFF")
//            case .poweredOn:
//                print("Bluetooth Device is POWERED ON")
//                addServices()
//            @unknown default:
//                print("Unknown State")
//            }
//        }
//
//    public func peripheralManager(_ peripheral: CBPeripheralManager,
//                                    didReceiveRead request: CBATTRequest){
//        let payloadString = ContactPayload(nonce: UUID().uuidString, issuedAt: String(Date().millisecondsSince1970), aud:"http://authority.url", sub:UUID().uuidString).toCommaDelimited()
//        request.value = payloadString.data(using: .utf8)
//        peripheral.respond(to:request, withResult:.success)
//    }
//
//    private var service: CBUUID!
//
//    public func addServices(){
//
//        let characteristic = CBMutableCharacteristic(type: CBUUID(string: "ba209999-0c6c-11d2-97cf-00c04f8eea41"), properties: [.read], value: nil, permissions: [.readable])
//
//        let myService = CBMutableService(type: CBUUID(string: "ba209999-0c6c-11d2-97cf-00c04f8eea40"), primary: true)
//
//        myService.characteristics = [characteristic]
//
//        peripheralManager.add(myService)
//
//        startAdvertising()
//
//    }
//
//
//    public func startAdvertising(){
//        peripheralManager.startAdvertising([CBAdvertisementDataLocalNameKey : "Apperoni", CBAdvertisementDataServiceUUIDsKey :     [service]])
//    }
//}

