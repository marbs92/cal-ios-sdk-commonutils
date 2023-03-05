//
//  BAZ_ServiceGPS.swift
//  baz-ios-akpago-utils
//
//  Created by Alfonso Mariano Hernandez Espinosa on 01/09/21.
//

import UIKit
import CoreLocation

@objc public protocol BAZ_ServiceGPSProtocol:class {
    func notifyLocation(latitud: String, longitud: String)
    func notifyDenniedPermission()
}

open class BAZ_ServiceGPS: NSObject, CLLocationManagerDelegate {
    public var locationWasRecovery = false
    private var locationManager : CLLocationManager?
    public weak var delegate : BAZ_ServiceGPSProtocol?
//    private var lat = ""
//    private var long = ""
    
    public func getStatusGPS(){
        initializeLocationServices()
    }
    
  
    func initializeLocationServices() {
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            delegate?.notifyDenniedPermission()
        case .denied:
            delegate?.notifyDenniedPermission()
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            locationManager?.startUpdatingLocation()
            break
        default:
            delegate?.notifyDenniedPermission()
        }
    }
    
    public func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
//            lat = "19.304827838809185"
//            long = "-99.20372078862984"
            locationManager?.stopUpdatingLocation()
            if locationWasRecovery == false{
                locationWasRecovery = true
                delegate?.notifyLocation(latitud: "\(latitude)", longitud: "\(longitude)")
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) { () }
}
