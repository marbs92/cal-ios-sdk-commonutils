//
//  ViewControllerExtension.swift
//  cal_ios_sdk_commonutils
//
//  Created by Jorge Cruz on 05/04/21.
//

import UIKit

public extension UIViewController{
   
    func hideKeyboardWhenTappedAround() {
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = true
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
