//
//  UICollectionView+reloadData.swift
//  aceptapago-ios-sdk-utils
//
//  Created by Satori on 13/07/21.
//

import UIKit

extension UICollectionView {
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
        
        if numberOfItems(inSection: 0) == 0 {
            setEmptyMessage(emptyMessage)
        } else {
            restore()
        }
    }
}
