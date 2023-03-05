//
//  UITableView+reloadData.swift
//  aceptapago-ios-sdk-utils
//
//  Created by Satori on 19/07/21.
//

import UIKit

extension UITableView {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .gray
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "Montserrat-Medium", size: 16)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel;
    }

    func restore() {
        self.backgroundView = nil
    }
    
    public func reloadData(_ emptyMessage: String) {
        reloadData()
        
        guard 0 < self.numberOfSections && 0 < self.numberOfRows(inSection: 0) else {
            setEmptyMessage(emptyMessage)
            return
        }
        
        restore()
    }
}
