//
//  Validation.swift
//  InsureTika
//
//  Created by keshav kumar on 31/01/20.
//  Copyright © 2020 keshav kumar. All rights reserved.
//

import UIKit
enum AlertType: String {
    case success = "SUCCESS"
    case apiFailure = "API_FAILURE"
    case validationFailure = "VALIDATION_FAILURE"
    var title: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    var color: UIColor {
        return Color.colorPrimary.value

//            switch self {
//            case .validationFailure:
//              return Color.buttonBlue.value
//            case .apiFailure:
//              return Color.gradient1.value
//            case .success:
//              return Color.success.value
//            }
    }
}

enum Color: String {
    case colorLightPrimary = "colorLightPrimary"
    case placeholderGray = "colorPlaceholder"
    case colorPrimary = "colorPrimary"
    case colorText = "colorText"
    case bottomLineColor = "colorTextFieldBottomLine"
    
    
    var value: UIColor {
        return UIColor(named: self.rawValue) ?? UIColor()
    }
}
