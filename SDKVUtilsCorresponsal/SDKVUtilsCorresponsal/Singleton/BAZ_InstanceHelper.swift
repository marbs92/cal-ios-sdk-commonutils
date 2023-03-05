//
//  BAZ_InstanceHelper.swift
//  SDKVUtilsCorresponsal
//
//  Created by Branchbit on 20/12/21.
//

import Foundation
import Firebase

open class FirebaseEnviromentHelper
{
    //MARK: Constants to configurate Firebase
    public static var GENERIC_APP_INSTANCE = ""
}

//MARK: - Func that configure the Surveys enviroment instance
extension FirebaseEnviromentHelper
{
    /**
    This function creates a FirebaseApp Instace for 'Genrcis App' , receives:
    - Parameter enviroment: An EnviromentFirebase enum that spcifies the enviroment ot initilice the Generic App firebase instance.
    */
    
    public static func AceptaPagoCreateInstance(enviroment: EnviromentFirebase) -> FirebaseOptions
    {
        switch enviroment
        {
        case .Release:
            let builder                     = FirebaseOptions(googleAppID: "1:537615387178:ios:b0a7612e61b14aa9b71153", gcmSenderID: "886141109976")
            builder.bundleID                = "com.aceptapagobaz.apps"
            builder.apiKey                  = "AIzaSyDjXP2d4ltD0ufznj_mViF49UE-Vq1oZRk"
            builder.clientID                = "537615387178-8fas67hbsvgirto4dn6fcsiv6ga93sqs.apps.googleusercontent.com"
            builder.databaseURL             = "https://baz-aceptapago.firebaseio.com"
            builder.storageBucket           = "baz-aceptapago.appspot.com"
            builder.projectID               = "baz-aceptapago"
            self.GENERIC_APP_INSTANCE       = "aceptapagobaserelease"
            return builder
        case .Prod:
            let builder                     = FirebaseOptions(googleAppID: "1:886141109976:ios:d8c1f05150590b07e1b9ad", gcmSenderID: "886141109976")
            builder.bundleID                = "com.jorge.aceptapago.general"
            builder.apiKey                  = "AIzaSyAWYSyS4uj-6xwF9MAGnTVQ18_-Lw-8n0o"
            builder.clientID                = "886141109976-enuikf7tn7mfam5bhdjurs29htvu65hj.apps.googleusercontent.com"
            builder.databaseURL             = "https://aceptapago-caf95.firebaseio.com"
            builder.storageBucket           = "aceptapago-caf95.appspot.com"
            builder.projectID               = "aceptapago-caf95"
            self.GENERIC_APP_INSTANCE       = "aceptapagobaseprod"
            return builder
        case .Qa:
            let builder                     = FirebaseOptions(googleAppID: "1:886141109976:ios:d8c1f05150590b07e1b9ad", gcmSenderID: "886141109976")
            builder.bundleID                = "com.jorge.aceptapago.general"
            builder.apiKey                  = "AIzaSyAWYSyS4uj-6xwF9MAGnTVQ18_-Lw-8n0o"
            builder.clientID                = "886141109976-enuikf7tn7mfam5bhdjurs29htvu65hj.apps.googleusercontent.com"
            builder.databaseURL             = "https://aceptapago-caf95.firebaseio.com"
            builder.storageBucket           = "aceptapago-caf95.appspot.com"
            builder.projectID               = "aceptapago-caf95"
            self.GENERIC_APP_INSTANCE       = "aceptapagobaseqa"
            return builder
        case .Development:
            let builder                     = FirebaseOptions(googleAppID: "1:886141109976:ios:d8c1f05150590b07e1b9ad", gcmSenderID: "886141109976")
            builder.bundleID                = "com.jorge.aceptapago.general"
            builder.apiKey                  = "AIzaSyAWYSyS4uj-6xwF9MAGnTVQ18_-Lw-8n0o"
            builder.clientID                = "886141109976-enuikf7tn7mfam5bhdjurs29htvu65hj.apps.googleusercontent.com"
            builder.databaseURL             = "https://aceptapago-caf95.firebaseio.com"
            builder.storageBucket           = "aceptapago-caf95.appspot.com"
            builder.projectID               = "aceptapago-caf95"
            self.GENERIC_APP_INSTANCE       = "aceptapagobasedev"
            return builder
        }
    }
    
    /**
     This funciton returns the FirebasApp Instance for 'Generic App'  .
     - Returns : A FirebaseApp Instance for 'Generic App'  .
     */
    /**
     This functionr returns the Firebase Generic App coptions
     -Returns : FirebaseOptions that repersentes the generic App
     **/
    public static func getGenericAppFirebaseOptions(enviroment: EnviromentFirebase) -> FirebaseOptions
    {
        return AceptaPagoCreateInstance(enviroment: enviroment)
    }
}
