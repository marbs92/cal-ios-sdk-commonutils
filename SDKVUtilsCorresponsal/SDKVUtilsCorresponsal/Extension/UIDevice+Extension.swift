//
//  UIDevice+Extension.swift
//  SDKVUtilsCorresponsal
//
//  Created by Dsi Soporte Tecnico on 17/11/21.
//

import Foundation
import UIKit

public enum BAZ_ScreenSize {
    case Small
    case Medium
    case Large
}

public extension UIDevice {
    private var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
    static var isJailBroken: Bool {
        get {
            if UIDevice.current.isSimulator { return false }
             if JailBrokenHelper.hasCydiaInstalled() { return true }
             if JailBrokenHelper.isContainsSuspiciousApps() { return true }
             if JailBrokenHelper.isSuspiciousSystemPathsExists() { return true }
             if JailBrokenHelper.canEditSystemFilesOnPrivate() { return true}
             return JailBrokenHelper.canEditSystemFiles()
        }
    }
    public func getDeviceByPlatform()->String{
        return String(UIDevice.current.identifierForVendor!.uuidString.replacingOccurrences(of: "-", with: "").prefix(16))
    }
    
    static var asapScreenSize: BAZ_ScreenSize = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> BAZ_ScreenSize {
            switch identifier {
            case "iPhone5,1",
                "iPhone5,2",
                "iPhone5,3",
                "iPhone5,4",
                "iPhone6,1",
                "iPhone6,2",
                "iPhone8,4":    return BAZ_ScreenSize.Small

                
            case "iPhone7,2",
                "iPhone7,1",
                "iPhone8,1",
                "iPhone8,2",
                "iPhone9,1",
                "iPhone9,3",
                "iPhone9,2",
                "iPhone9,4",
                "iPhone10,1",
                "iPhone10,4",
                "iPhone10,2",
                "iPhone10,5":   return BAZ_ScreenSize.Medium
                

            case "iPhone10,3",
                "iPhone10,6",
                "iPhone11,2",
                "iPhone11,4",
                "iPhone11,6",
                "iPhone11,8",
                "iPhone12,1",
                "iPhone12,3",
                "iPhone12,5",
                "iPhone13,1",
                "iPhone13,2",
                "iPhone13,3",
                "iPhone13,4",
                "iPhone14,4",
                "iPhone14,5",
                "iPhone14,2",
                "iPhone14,3",
                "iPhone12,8",
                "iPhone14,6":   return BAZ_ScreenSize.Large

                
            default:            return BAZ_ScreenSize.Large
            }
        }

        return mapToDevice(identifier: identifier)
    }()
    
    static var screenMultiplier: CGFloat {
        return (UIScreen.main.bounds.height > 667 ? 1 : (UIScreen.main.bounds.height == 667 ? 0.85 : 0.7))
    }
}
    
private struct JailBrokenHelper {
    static func hasCydiaInstalled() -> Bool {
        return UIApplication.shared.canOpenURL(URL(string: "cydia://")!)
    }

    static func isContainsSuspiciousApps() -> Bool {
        for path in suspiciousAppsPathToCheck {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        return false
    }
    
    static func isSuspiciousSystemPathsExists() -> Bool {
        for path in suspiciousSystemPathsToCheck {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        return false
    }
    
    static func canEditSystemFiles() -> Bool {
        let jailBreakText = "Developer Insider"
        do {
            try jailBreakText.write(toFile: jailBreakText, atomically: true, encoding: .utf8)
            return true
        } catch {
            return false
        }
    }
    
    static func canEditSystemFilesOnPrivate()->Bool{
        let stringToWrite = "Jailbreak Test"
        do {
            try stringToWrite.write(
                toFile: "/private/JailbreakTest.txt",
                atomically: true,
                encoding: String.Encoding.utf8
            )
            // Device is jailbroken
            return true
        } catch {
            return false
        }
    }
    
    /**
     Add more paths here to check for jail break
     */
    static var suspiciousAppsPathToCheck: [String] {
        return ["/Applications/Cydia.app",
                "/Applications/blackra1n.app",
                "/Applications/FakeCarrier.app",
                "/Applications/Icy.app",
                "/Applications/IntelliScreen.app",
                "/Applications/MxTube.app",
                "/Applications/RockApp.app",
                "/Applications/SBSettings.app",
                "/Applications/WinterBoard.app"
        ]
    }
    
    static var suspiciousSystemPathsToCheck: [String] {
        return ["/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
                "/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
                "/private/var/lib/apt",
                "/private/var/lib/apt/",
                "/private/var/lib/cydia",
                "/private/var/mobile/Library/SBSettings/Themes",
                "/private/var/stash",
                "/private/var/tmp/cydia.log",
                "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
                "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
                "/usr/bin/sshd",
                "/usr/libexec/sftp-server",
                "/usr/sbin/sshd",
                "/etc/apt",
                "/bin/bash",
                "/Library/MobileSubstrate/MobileSubstrate.dylib"
        ]
    }
}
