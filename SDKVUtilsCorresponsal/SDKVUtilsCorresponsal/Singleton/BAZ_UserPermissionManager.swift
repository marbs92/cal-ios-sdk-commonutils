//
//  BAZ_UserPermission.swift
//  SDKVUtilsCorresponsal
//
//  Created by Dsi Soporte Tecnico on 28/01/22.
//

import UIKit
import UserNotifications

public enum BAZ_UserPermissionEnum: String{
    case Notificaciones = "Notificaciones"
}

open class BAZ_UserPermissionManager: NSObject, UNUserNotificationCenterDelegate {

    private let unCenter = UNUserNotificationCenter.current()
    public static let shareInstance = BAZ_UserPermissionManager()
    
    
    private func checkPermission(permissionRequest:BAZ_UserPermissionEnum) -> Bool {
        switch permissionRequest {
        case .Notificaciones:
            let authorization = UIApplication.shared.isRegisteredForRemoteNotifications
            return authorization
        }
        
    }
    
    public func requestNotificationPermission() -> Void{
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
           self.callNotificationPermision()
        }
    }
    
    private func callNotificationPermision(){
        let options: UNAuthorizationOptions = [ .alert, .badge, .sound ]
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            unCenter.delegate = self
            unCenter.requestAuthorization(
                options: options,
                completionHandler: {_, _ in
                    _ = [1,2,3,4,5].filter({return $0 > 1})
                })
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
    }
    
}

extension BAZ_UserPermissionManager {
    
    //open app , i can get de information
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound]);
    }
    
    //open app , i can get de information when i touch the notification
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response:
        UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler();
    }
    
    
}
