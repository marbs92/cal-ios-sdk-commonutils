//
//  UIFont+Extension.swift
//  cal_ios_sdk_commonutils
//
//  Created by Jorge Cruz on 05/04/21.
//

import UIKit

public extension UIFont {

    private static var fontsRegistered: Bool = false

        static func registerFontsIfNeeded() {
            guard
                !fontsRegistered,
                let fontURLs = Bundle.local_ak_utils.urls(forResourcesWithExtension: "ttf", subdirectory: nil)
            else { return }

            fontURLs.forEach({ CTFontManagerRegisterFontsForURL($0 as CFURL, .process, nil) })
            fontsRegistered = true
        }
    
    /*  ----------------------------------------- **/
    class var Poppins_Bold_24 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-Bold", size: 24.0) ?? UIFont.systemFont(ofSize: 24.0)
    }
    class var Poppins_Bold_22 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-Bold", size: 22.0) ?? UIFont.systemFont(ofSize: 22.0)
    }
    class var Poppins_Bold_20 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-Bold", size: 20.0) ?? UIFont.systemFont(ofSize: 20.0)
    }
    class var Poppins_Bold_18 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-Bold", size: 18.0) ?? UIFont.systemFont(ofSize: 18.0)
    }
    class var Poppins_Bold_16 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-Bold", size: 16.0) ?? UIFont.systemFont(ofSize: 16.0)
    }
    class var Poppins_Bold_15 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-Bold", size: 15.0) ?? UIFont.systemFont(ofSize: 15.0)
    }
    class var Poppins_Bold_14 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-Bold", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
    }
    class var Poppins_Bold_12 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-Bold", size: 12.0) ?? UIFont.systemFont(ofSize: 12.0)
    }
    
    
    class var Poppins_Semibold_40 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-SemiBold", size: 40.0) ?? UIFont.systemFont(ofSize: 40.0)
    }
    class var Poppins_Semibold_30 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-SemiBold", size: 30.0) ?? UIFont.systemFont(ofSize: 30.0)
    }
    class var Poppins_Semibold_26 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-SemiBold", size: 26.0) ?? UIFont.systemFont(ofSize: 26.0)
    }
    class var Poppins_Semibold_24 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-SemiBold", size: 24.0) ?? UIFont.systemFont(ofSize: 24.0)
    }
    class var Poppins_Semibold_22 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-SemiBold", size: 22.0) ?? UIFont.systemFont(ofSize: 22.0)
    }
    class var Poppins_Semibold_20 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-SemiBold", size: 20.0) ?? UIFont.systemFont(ofSize: 20.0)
    }
    class var Poppins_Semibold_18 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-SemiBold", size: 18.0) ?? UIFont.systemFont(ofSize: 18.0)
    }
    class var Poppins_Semibold_17 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-SemiBold", size: 17.0) ?? UIFont.systemFont(ofSize: 17.0)
    }
    class var Poppins_Semibold_16 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-SemiBold", size: 16.0) ?? UIFont.systemFont(ofSize: 16.0)
    }
    class var Poppins_Semibold_14 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-SemiBold", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
    }
    class var Poppins_Semibold_13 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-SemiBold", size: 13.0) ?? UIFont.systemFont(ofSize: 13.0)
    }
    class var Poppins_Semibold_12 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-SemiBold", size: 12.0) ?? UIFont.systemFont(ofSize: 12.0)
    }
    class var Poppins_Semibold_10 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-SemiBold", size: 10.0) ?? UIFont.systemFont(ofSize: 10.0)
    }
    
    
    class var Poppins_Medium_80 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-Medium", size: 80.0) ?? UIFont.systemFont(ofSize: 80.0)
    }
    class var Poppins_Medium_60 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-Medium", size: 60.0) ?? UIFont.systemFont(ofSize: 60.0)
    }
    class var Poppins_Medium_55 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-Medium", size: 55.0) ?? UIFont.systemFont(ofSize: 55.0)
    }
    class var Poppins_Medium_45 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-Medium", size: 45.0) ?? UIFont.systemFont(ofSize: 45.0)
    }
    class var Poppins_Medium_40 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-Medium", size: 40.0) ?? UIFont.systemFont(ofSize: 40.0)
    }
    class var Poppins_Medium_34 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-Medium", size: 34.0) ?? UIFont.systemFont(ofSize: 34.0)
    }
    class var Poppins_Medium_30 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-Medium", size: 30.0) ?? UIFont.systemFont(ofSize: 30.0)
    }
    class var Poppins_Medium_28 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-Medium", size: 28.0) ?? UIFont.systemFont(ofSize: 28.0)
    }
    class var Poppins_Medium_20 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-Medium", size: 20.0) ?? UIFont.systemFont(ofSize: 20.0)
    }
    class var Poppins_Medium_18 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-Medium", size: 18.0) ?? UIFont.systemFont(ofSize: 18.0)
    }
    class var Poppins_Medium_16 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-Medium", size: 16.0) ?? UIFont.systemFont(ofSize: 16.0)
    }
    class var Poppins_Medium_15 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-Medium", size: 15.0) ?? UIFont.systemFont(ofSize: 15.0)
    }
    class var Poppins_Medium_14 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-Medium", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
    }
    class var Poppins_Medium_12 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-Medium", size: 12.0) ?? UIFont.systemFont(ofSize: 12.0)
    }
    
    class var Poppins_Regular_26 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-Regular", size: 26.0) ?? UIFont.systemFont(ofSize: 26.0)
    }
    class var Poppins_Regular_24 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-Regular", size: 24.0) ?? UIFont.systemFont(ofSize: 24.0)
    }
    class var Poppins_Regular_18 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-Regular", size: 18.0) ?? UIFont.systemFont(ofSize: 18.0)
    }
    class var Poppins_Regular_20 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-Regular", size: 20.0) ?? UIFont.systemFont(ofSize: 20.0)
    }
    class var Poppins_Regular_17 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-Regular", size: 17.0) ?? UIFont.systemFont(ofSize: 17.0)
    }
    class var Poppins_Regular_16 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-Regular", size: 16.0) ?? UIFont.systemFont(ofSize: 16.0)
    }
    class var Poppins_Regular_15 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-Regular", size: 15.0) ?? UIFont.systemFont(ofSize: 15.0)
    }
    class var Poppins_Regular_14 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-Regular", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
    }
    class var Poppins_Regular_13 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-Regular", size: 13.0) ?? UIFont.systemFont(ofSize: 13.0)
    }
    class var Poppins_Regular_12 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-Regular", size: 12.0) ?? UIFont.systemFont(ofSize: 12.0)
    }
    class var Poppins_Regular_11 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-Regular", size: 11.0) ?? UIFont.systemFont(ofSize: 11.0)
    }
    
    class var Poppins_Regular_10 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-Regular", size: 10.0) ?? UIFont.systemFont(ofSize: 10.0)
    }
    
    class var Poppins_Light_14 : UIFont {
        registerFontsIfNeeded()
        return UIFont(name: "Poppins-Light", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
    }
    /*  ----------------------------------------- **/
}
