//
// Created by Leigh Williams on 2020-04-19.
// Copyright (c) 2020 Identos. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {

    open override var isEnabled: Bool{
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }

}