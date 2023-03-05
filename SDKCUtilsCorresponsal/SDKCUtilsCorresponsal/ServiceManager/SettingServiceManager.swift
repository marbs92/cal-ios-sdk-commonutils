//
//  SettingServiceManager.swift
//  baz-ios-akpago-utils
//
//  Created by Jorge Cruz on 22/06/21.
//

import UIKit

public enum SettingServiceManagerEnviroment {
    case development
    case qa
    case release
}


open class SettingServiceManager: NSObject {
    public static let shared = SettingServiceManager()
    public var base : String?
    public var host : String?
    public var token : String?
    public var valToken : String?
}

open class SettingServiceManagerDefinition{
    public static let shared = SettingServiceManagerDefinition()
    public var hostAceptaPago: String = ""
    public var hostCorresponsal: String = ""
    public var tokenAceptaPago: String = ""
    public var tokenCorresponsal: String = ""
    public var firebaseFuntionalities: String = ""
    public var licenseMicroblink: String = ""
    public var firebaseRelease: Bool = false
    public var sertiRelease: Bool = false
    public var firebasePrinterApp: Bool = false
    public var sentry = ""
}
