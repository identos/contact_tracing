//
// Created by Leigh Williams on 2020-03-30.
// Copyright (c) 2020 Identos. All rights reserved.
//

import Foundation

enum NavigationStep {
    case info, contactInfo, otp, turnOnBluetooth, status, statusOff, statusUnauthorized

    func next() -> NavigationStep {
        switch self {
        case .info:
            return .contactInfo
        case .contactInfo:
            return .otp
        case .otp:
            return .turnOnBluetooth
        case .turnOnBluetooth:
            return .status
        case .status:
            return .statusOff
        case .statusOff:
            return .status
        case .statusUnauthorized:
            return .status
        }
    }
}

protocol NavigationStepDelegate {
    func next()
}


