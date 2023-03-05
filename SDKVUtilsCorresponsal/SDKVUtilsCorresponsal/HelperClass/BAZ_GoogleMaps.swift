//
//  BAZ_GoogleMaps.swift
//  baz-ios-akpago-utils
//
//  Created by Jorge Cruz on 21/04/21.
//


import Foundation
import GoogleMaps

class BAZ_GoogleMaps: NSObject {
    
    lazy var mapView: GMSMapView = {
        let map = GMSMapView(frame: .zero)
        map.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return map
    }()
    lazy var marker: GMSMarker = {
        let marker = GMSMarker()
        marker.isDraggable = true
        return marker
    }()
    
    private var geocoding = BAZ_NativeGeocoding(address: "")
    weak var delegate: GoogleMapsDelegate?
    private(set) public var currentCoordinates = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    private(set) public var address: String = ""
    
    init(delegate: GoogleMapsDelegate) {
        super.init()
        self.delegate = delegate
    }
    
    func addMapToView(_ view: UIView) {
        mapView.frame = view.bounds
        mapView.delegate = self
        view.addSubview(mapView)
        let camera = GMSCameraPosition(latitude: 19.432602, longitude: -99.133205, zoom: 17.0)
        mapView.animate(to: camera)
    }
    
    func addMarker(address: String) {
        geocoding.address = address
        geocoding.geocode { [weak self] (coordinates) in
            guard let coordxy = coordinates else {
                printDebug("Ha ocurrido un error al obtener las coordenadas.")
                self?.delegate?.updatedMarker(information: nil)
                return
            }
            self?.address = address
            self?.addMarker(address: address, coordinates: coordxy)
        }
    }
    
    func addMarker(address: String, coordinates: CLLocationCoordinate2D) {
        marker.position = coordinates
        marker.title = address
        marker.snippet = address
        marker.map = mapView
        let camera = GMSCameraPosition(latitude: coordinates.latitude, longitude: coordinates.longitude, zoom: 17.0)
        mapView.animate(to: camera)
        self.currentCoordinates = coordinates
        self.address = address
        let information = BAZ_GoogleMaps.Marker(address: address, coordinates: coordinates)
        delegate?.updatedMarker(information: information)
    }
    
    struct Marker {
        let address: String
        let coordinates: CLLocationCoordinate2D
    }
    
}

extension BAZ_GoogleMaps: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        self.currentCoordinates = coordinate
        self.addMarker(address: self.address, coordinates: coordinate)
    }
}

protocol GoogleMapsDelegate: NSObject {
    func updatedMarker(information: BAZ_GoogleMaps.Marker?)
}

