//
//  Fonts+Colors.swift
//  ContactTracer
//
//  Created by Leigh Williams on 2020-03-30.
//  Copyright © 2020 Identos. All rights reserved.
//

import Foundation
import UIKit


enum Colors {
    case blue, black, white

    public func uiColor() -> UIColor {
        switch self {
        case .blue:
            return UIColor(red: 44 / 255, green: 124 / 255, blue: 181 / 255, alpha: 1)
        case .black:
            return .black
        case .white:
            return .white
        }
    }

    public func cgColor() -> CGColor {
        return uiColor().cgColor
    }

}

enum Fonts {
    case title, description, button, link, normalBold, normalMedium

    public func get() -> UIFont {
        switch self {
        case .title:
            return UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold)
        case .normalBold:
            return UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        case .description:
            return UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        case .button:
            return UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        case .link:
            return UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        case .normalMedium:
            return UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        }
    }
}
