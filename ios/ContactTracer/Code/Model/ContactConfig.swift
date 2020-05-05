//
// Created by Leigh Williams on 2020-04-04.
// Copyright (c) 2020 Identos. All rights reserved.
//

import Foundation
import CoreBluetooth

public struct ContactConfig {
    let advertisementName: String
    let identifier: UUID
    let serviceCbuuid: CBUUID
    let characteristicCbuuid: CBUUID
}