//
//  UIResponder.swift
//  AceptaPagoBaz
//
//  Created by David on 06/07/20.
//  Copyright © 2020 Zeus. All rights reserved.
//

import UIKit


extension UIResponder {
    static var isSwizzling: Bool = false
    public static let shared = UIResponder()
   
   open class func swizzle() {
        guard !isSwizzling else { return }

        swizzle(originalSelector: #selector(touchesBegan(_:with:)), to: #selector(_swizzled_touchesBegan(_:with:)))
        swizzle(originalSelector: #selector(touchesMoved(_:with:)), to: #selector(_swizzled_touchesMoved(_:with:)))
        swizzle(originalSelector: #selector(touchesEnded(_:with:)), to: #selector(_swizzled_touchesEnded(_:with:)))

        isSwizzling = true
    }

    static func swizzle(originalSelector: Selector, to swizzledSelector: Selector) {
        let originalMethod = class_getInstanceMethod(self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
        let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
        if didAddMethod {
            class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
        } else {
            method_exchangeImplementations(originalMethod!, swizzledMethod!);
        }
    }

    @objc func _swizzled_touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        _swizzled_touchesBegan(touches, with: event)
    }

    @objc func _swizzled_touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        _swizzled_touchesMoved(touches, with: event)
    }
    
    @objc func _swizzled_touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        _swizzled_touchesEnded(touches, with: event)
    }


    private var _className: String {
        return String(describing: type(of: self))
    }
}

// MARK: - uninstall
extension UIResponder {
    class func unswizzle() {
        guard isSwizzling else { return }
        
        _unswizzleMethod(originalSelector: #selector(touchesBegan(_:with:)), to: #selector(_swizzled_touchesBegan(_:with:)))
        _unswizzleMethod(originalSelector: #selector(touchesMoved(_:with:)), to: #selector(_swizzled_touchesMoved(_:with:)))
        _unswizzleMethod(originalSelector: #selector(touchesEnded(_:with:)), to: #selector(_swizzled_touchesEnded(_:with:)))

        
        isSwizzling = false
    }

    private class func _unswizzleMethod(originalSelector: Selector, to swizzledSelector: Selector) {

        guard
            let originalMethod = class_getInstanceMethod(self, originalSelector),
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            else { return }

        if class_addMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(swizzledMethod)) {
            class_replaceMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        } else {
            method_exchangeImplementations(swizzledMethod, originalMethod)
        }
    }
    
}
