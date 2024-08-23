//
//  UtilityFunctions.swift
//  MAC
//
//  Created by cbl24 on 06/11/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import PhotosUI

//MARK:- EXTENSIONS
extension String: OptionalType {}
extension Int: OptionalType {}
extension Double: OptionalType {}
extension Bool: OptionalType {}
extension Float: OptionalType {}
extension CGFloat: OptionalType {}
extension CGRect: OptionalType {}
extension UIImage: OptionalType {}
extension IndexPath: OptionalType {}

prefix operator /

//unwrapping values
prefix func /<T: OptionalType>(value: T?) -> T {
    guard let validValue = value else { return T() }
    return validValue
}

typealias OptionalDictionary = [String : Any]?

protocol OptionalType { init() }

