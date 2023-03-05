//
//  BAZ_NativeGeocoding.swift
//  baz-ios-akpago-utils
//
//  Created by Jorge Cruz on 21/04/21.
//

import UIKit
import GoogleMaps

class BAZ_NativeGeocoding: NSObject {
    
    var address: String
    lazy var geocoder = CLGeocoder()
    
    init(address: String) {
        self.address = address
    }
    
    func geocode(completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        geocoder.geocodeAddressString(self.address) { (result, error) in
            guard let markers = result, let marker = markers.first, let location = marker.location, error == nil else {
                completion(nil)
                return
            }
            completion(location.coordinate)
        }
    }

}
