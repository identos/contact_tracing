//
// Created by Leigh Williams on 2020-04-01.
// Copyright (c) 2020 Identos. All rights reserved.
//

import Foundation


extension Date {
    var millisecondsSince1970: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
