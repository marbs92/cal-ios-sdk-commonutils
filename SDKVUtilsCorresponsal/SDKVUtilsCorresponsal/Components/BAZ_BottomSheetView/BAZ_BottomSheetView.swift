//
//  BAZ_BottomSheetView.swift
//  SDKVUtilsCorresponsal
//
//  Created by Luis Fernando Sánchez Palma on 10/06/22.
//

import Foundation
import UIKit

@objc internal protocol BAZ_BottomSheetDelegate {
    @objc optional func notifyBottomSheetClosed()
    @objc optional func notifyBottomSheetOpened()
}

internal class BAZ_BottomSheetView: UIViewController {
    private var ui: BAZ_BottomSheetViewUI?
    
    internal var showCloseButton: Bool = false
    internal var cardViewHeightPercentaje: CGFloat = 70
    internal var delegate: BAZ_BottomSheetDelegate?
    internal var contentView: UIView = UIView()
    private var blackSpace: CGFloat = 0
    
    override func loadView() {
        self.ui = BAZ_BottomSheetViewUI(delegate: self,
                                         showCloseButton: self.showCloseButton,
                                         cardViewHeightPercentaje: self.cardViewHeightPercentaje,
                                         contentView: self.contentView)
        self.view = self.ui
        
        self.blackSpace = (((100 - self.cardViewHeightPercentaje) / 100) * UIScreen.main.bounds.height)
    }
    
    
    override func viewDidLoad() {
        self.show(completionHandler: nil)
    }
    
    public func show(completionHandler: (() -> Void)?, callDelegate: Bool = false){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.animate(withDuration: 0.5) {
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                self.ui?.cardViewTopAnchor.constant = (self.blackSpace + 40)
                self.view.layoutIfNeeded()
            } completion: { _ in
                completionHandler?()
                if callDelegate {
                    self.delegate?.notifyBottomSheetClosed?()
                }
            }
        }
    }
    
    public func hide(completionHandler: (() -> Void)?, callDelegate: Bool = false){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.animate(withDuration: 0.5) {
                self.ui?.cardViewTopAnchor.constant = self.ui?.frame.height ?? UIScreen.main.bounds.height
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.dismiss(animated: false) {
                    completionHandler?()
                    if callDelegate {
                        self.delegate?.notifyBottomSheetClosed?()
                    }
                }
            }
        }
    }
}

extension BAZ_BottomSheetView: BAZ_BottomSheetViewUIDelegate {
    func notifyClose() {
        self.hide(completionHandler: nil, callDelegate: true)
    }
}
