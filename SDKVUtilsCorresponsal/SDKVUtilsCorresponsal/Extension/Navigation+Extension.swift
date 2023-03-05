//
//  NavigationExtension.swift
//  cal_ios_sdk_commonutils
//
//  Created by Jorge Cruz on 29/03/21.
//

import UIKit

public extension UINavigationController {
    /**
     It removes all view controllers from navigation controller then set the new root view controller and it pops.
     - parameter vc: root view controller to set a new
     */
    public func popBack(_ count: Int) {
        guard count > 0 else {
            return assertionFailure("Count can not be a negative value.")
        }
        let index = viewControllers.count - count - 1
        guard index > 0 else {
            return assertionFailure("Not enough View Controllers on the navigation stack.")
        }
        popToViewController(viewControllers[index], animated: true)
    }
    
    /// pop back to specific viewcontroller
    public func popBack<T: UIViewController>(toControllerType: T.Type) {
        var viewControllers: [UIViewController] = self.viewControllers
        viewControllers = viewControllers.reversed()
        for currentViewController in viewControllers {
            if currentViewController .isKind(of: toControllerType) {
                self.popToViewController(currentViewController, animated: true)
                break
            }
        }
    }
    
    public var isModal: Bool {
        
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
        
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }
    
    public func displayJailBreakMessage(){
        let alert = UIAlertController(title: "Información", message: "Por cuestiones de seguridad no se puede utilizar esta aplicación en el dispositivo.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    public func initRootViewController(_ vc: UIViewController, duration: CFTimeInterval = 0.3) {
        self.addTransition( duration: duration)
        self.viewControllers.removeAll()
        self.pushViewController(vc, animated: false)
        self.popToRootViewController(animated: false)
    }
    
    /**
     It adds the animation of navigation flow.
     - parameter type: kCATransitionType, it means style of animation
     - parameter duration: CFTimeInterval, duration of animation
     */
    private func addTransition( duration: CFTimeInterval = 0.3) {
        let transition = CATransition()
        transition.duration = duration
        self.view.layer.add(transition, forKey: nil)
    }
    
}
