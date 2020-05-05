//
// Created by Leigh Williams on 2020-04-16.
// Copyright (c) 2020 Identos. All rights reserved.
//

import Foundation

public typealias Parameters = [String: Any]

enum ContactTracerAPI {
    case addDevice(identifier: String, phone: String)
    case confirmDevice(identifier: String, userCode: String, phone: String)
}

extension ContactTracerAPI: Endpoint {

    var bodyData: Data? {
        switch self {
        case .addDevice(let i, let p):
            return try? JSONEncoder().encode(AddDeviceRequest(identifier: i, phone: p))
        case .confirmDevice(_, let c, let p):
            return try? JSONEncoder().encode(ConfirmDeviceRequest(userCode: c, phone: p))
        }
    }

    var fullURL: String {
        baseURL + path
    }

    var baseURL: String {
        "https://BASE_URL_TO_API"
    }

    var method: HTTPMethod {
        switch self {
        case .addDevice, .confirmDevice:
            return .post
        }
    }

    var path: String {
        switch self {
        case .addDevice:
            return "devices"
        case .confirmDevice(let identifier, _, _):
            return "devices/\(identifier)/confirm"
        }
    }
}

struct ConfirmDeviceRequest: Codable {
    let userCode: String
    let phone: String

    public enum CodingKeys: String, CodingKey {
        case userCode = "user_code"
        case phone = "phone"
    }
}

struct AddDeviceRequest: Codable {
    let identifier: String
    let phone: String
}

struct AddDeviceResponse: Codable {
    let iat: Int
    let identifier: String
}