//
//  Toast.swift
//  MaidFinder
//
//  Created by Gurleen on 20/08/19.
//  Copyright © 2019 Code Brew Labs. All rights reserved.
//

import UIKit
import SwiftEntryKit

class Toast {
    
    static let shared = Toast()
    
    func showAlert(type: AlertType, message: String) {
        var attributes = EKAttributes()
        attributes.windowLevel = .statusBar
        attributes.position = .top
        attributes.displayDuration = 2.5
        attributes.entryBackground = .gradient(gradient: .init(colors: [EKColor(.init(red: 214/255, green: 187/255, blue: 114/255, alpha: 1)), EKColor(.init(red: 214/255, green: 187/255, blue: 114/255, alpha: 1))], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
        attributes.positionConstraints.safeArea = .empty(fillSafeArea: true)
        let title = EKProperty.LabelContent.init(text: message, style: .init(font: UIFont.systemFont(ofSize: 18, weight: .bold), color: .white))
        let description = EKProperty.LabelContent.init(text: "", style: .init(font: UIFont.systemFont(ofSize: 14, weight: .medium), color: .white))
        let simpleMessage = EKSimpleMessage.init(title: title, description: description)
        let notificationMessage = EKNotificationMessage.init(simpleMessage: simpleMessage)
        let contentView = EKNotificationMessageView(with: notificationMessage)
    
        SwiftEntryKit.display(entry: contentView, using: attributes)
        
    }
}
