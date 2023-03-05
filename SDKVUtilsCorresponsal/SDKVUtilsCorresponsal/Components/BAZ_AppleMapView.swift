//
//  BAZ_AppleMapView.swift
//  baz-ios-akpago-utils
//
//  Created by Luis Grano on 06/09/21.
//

import Foundation
import MapKit

public struct BAZ_AppleMapAddress {
    let street: String?
    let number: String?
    let suburb: String?
    let city: String?
    let state: String?
    let postalCode: String?
    
    public init (street: String?,
                 number: String?,
                 suburb: String?,
                 city: String?,
                 state: String?,
                 postalCode: String?){
        self.street = street
        self.number = number
        self.suburb = suburb
        self.city = city
        self.state = state
        self.postalCode = postalCode
    }
}
public struct BAZ_AppleCoordinates {
    public let latitude: String
    public let longitude: String
    
    public init(latitude: String, longitude: String){
        self.latitude = latitude
        self.longitude = longitude
    }
}

public protocol BAZ_AppleMapDelegate {
    func coordinatesDidUpdate(coordinates: BAZ_AppleCoordinates)
}

open class BAZ_AppleMapView: UIView {
    private let geoCoder = CLGeocoder()
    private var defaultRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 23.126906,
                                                                                  longitude: -102.257278),
                                                   latitudinalMeters: CLLocationDistance(2400000),
                                                   longitudinalMeters: CLLocationDistance(2400000))
    
    private var currentLocation: CLLocation?
    private var currentCoordinates: CLLocationCoordinate2D?
    private var showPin: Bool = true
    private var isMapInteractable: Bool = false
    private var animateTransition: Bool = false
    
    private var delegate: BAZ_AppleMapDelegate?
    
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.mapTapped(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        map.addGestureRecognizer(tapGestureRecognizer)
        
        return map
    }()
    
    private lazy var placeHolderUp: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.Poppins_Medium_14
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = BAZ_ColorManager.navyBlueDarkRW
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var helperText: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.Poppins_Medium_14
        label.numberOfLines = 0
        label.textAlignment = .right
        label.textColor = BAZ_ColorManager.navyBlueDarkRW
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public convenience init(titleText: String = "",
                            decorativeTitleText: NSMutableAttributedString? = nil,
                            titleTextFont: UIFont = UIFont.Poppins_Medium_14,
                            titleTextColor: UIColor = BAZ_ColorManager.greenDarkRW,
                            
                            isMapInteractable: Bool = false,
                            
                            helperText: String = "",
                            helperTextFont: UIFont = UIFont.Poppins_Medium_14,
                            helperTextColor: UIColor = BAZ_ColorManager.greenDarkRW,
                            
                            delegate: BAZ_AppleMapDelegate?){
        self.init()
        
        self.delegate = delegate
        
        self.isMapInteractable = isMapInteractable
        
        
        if !titleText.isEmpty {
            self.placeHolderUp.text = titleText
            self.placeHolderUp.font = titleTextFont
            self.placeHolderUp.textColor = titleTextColor
        } else if let nonNilDecorativeTitleText = decorativeTitleText, nonNilDecorativeTitleText.length > 0 {
            self.placeHolderUp.attributedText = nonNilDecorativeTitleText
        }
        
        self.helperText.text = helperText
        self.helperText.font = helperTextFont
        self.helperText.textColor = helperTextColor
        
        self.mapView.mapType = .mutedStandard
        
        self.buildUI()
        
        self.resetToDefaultRegion()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func buildUI(){
        self.addSubview(self.mapView)
        self.addSubview(self.placeHolderUp)
        self.addSubview(self.helperText)
        NSLayoutConstraint.activate([
            self.placeHolderUp.topAnchor.constraint(equalTo: self.topAnchor),
            self.placeHolderUp.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.placeHolderUp.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            self.mapView.topAnchor.constraint(equalTo: self.placeHolderUp.bottomAnchor, constant: 5),
            self.mapView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.mapView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.mapView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7),
            
            self.helperText.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 5),
            self.helperText.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.helperText.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.helperText.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    public func getCoordinatesFromAddress(with query: BAZ_AppleMapAddress,
                             success: @escaping (_ coordinates: CLLocationCoordinate2D?) -> (),
                             failure: @escaping (_ error: String?) -> ()){
        let address = "calle \(query.street ?? "") #\(query.number ?? ""), colonia \(query.suburb ?? ""), \(query.city ?? ""), \(query.state ?? ""), \(query.postalCode ?? "")"
        geoCoder.geocodeAddressString(address) { places, error in
            guard let places = places, error == nil else {
                failure("Error al obtener el mapa: \(error?.localizedDescription ?? "error desconocido.")")
                return
            }
            success(places.first?.location?.coordinate)
            return
        }
    }
    
    public func getAddressFromCoordinates(){
        ()
        // TODO: Terminar función para obtener la dirección a partir de coordenadas
    }
    
    public func resetToDefaultRegion(){
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.setRegion(self.defaultRegion, animated: true)
        self.currentLocation = nil
        self.currentCoordinates = nil
        self.isUserInteractionEnabled = false
    }
    
    
    public func goToAddress(address: BAZ_AppleMapAddress,
                            showPin: Bool = true,
                            animated: Bool = false,
                            distance latitudinalMeters: Int = 350,
                            distance longitudinalMeters: Int = 350,
                            found: @escaping (_ coordinates: BAZ_AppleCoordinates) -> (),
                            notFund: @escaping () -> (),
                            failure: @escaping (String) -> ()){
        self.getCoordinatesFromAddress(with: address) { coordinates in
            
            self.showPin = showPin
            self.animateTransition = animated
            
            guard let nonNilCoordinates = coordinates else {
                notFund()
                return
            }
            self.currentLocation = CLLocation(latitude: nonNilCoordinates.latitude,
                                              longitude: nonNilCoordinates.longitude)
            
            self.currentCoordinates = nonNilCoordinates
            
            self.isUserInteractionEnabled = self.isMapInteractable
 
            found(self.goToCoordinates(coordinates: nonNilCoordinates,
                                       showPin: showPin,
                                       animated: animated,
                                       distance: latitudinalMeters,
                                       distance: longitudinalMeters))
        } failure: { error in
            failure(error ?? "Ha ocurrido un error desconocido")
        }
    }
    
    
    public func goToCoordinates(coordinates: CLLocationCoordinate2D,
                                showPin: Bool = true,
                                animated: Bool = false,
                                distance latitudinalMeters: Int = 350,
                                distance longitudinalMeters: Int = 350) -> BAZ_AppleCoordinates {
        
        let region = MKCoordinateRegion(center: coordinates,
                                        latitudinalMeters: CLLocationDistance(latitudinalMeters),
                                        longitudinalMeters: CLLocationDistance(longitudinalMeters))
        
        if showPin {
            self.showPinAt(coordinates: coordinates)
        }
        
        self.mapView.setRegion(region,
                               animated: animated)
        
        return BAZ_AppleCoordinates(latitude: String(coordinates.latitude),
                                    longitude: String(coordinates.longitude))
    }
    
    public func goToCoordinates(coordinates: BAZ_AppleCoordinates,
                                showPin: Bool = true,
                                animated: Bool = false,
                                distance latitudinalMeters: Int = 350,
                                distance longitudinalMeters: Int = 350) {
        
        let latitude = Double(coordinates.latitude) ?? 0
        let longitude = Double(coordinates.longitude) ?? 0
        
        self.showPin = showPin
        self.animateTransition = animated
        
        let locationCoordinates = CLLocationCoordinate2D(latitude: latitude,
                                                         longitude: longitude)
        
        self.currentLocation = CLLocation(latitude: latitude,
                                          longitude: longitude)
        
        self.currentCoordinates = locationCoordinates
        
        _ = self.goToCoordinates(coordinates: locationCoordinates,
                                 showPin: showPin,
                                 animated: animated,
                                 distance: latitudinalMeters,
                                 distance: longitudinalMeters)
    }
    
    private func showPinAt(coordinates: CLLocationCoordinate2D,
                           eraseAll: Bool = true) {
        if eraseAll {
            self.mapView.removeAnnotations(self.mapView.annotations)
        }
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        self.mapView.addAnnotation(pin)
    }
    
    @objc func mapTapped(_ sender: UITapGestureRecognizer) {
        if let nonNilCurrentLocation = self.currentLocation {
            let point = sender.location(in: self.mapView)
            
            let coordinates = self.mapView.convert(point, toCoordinateFrom: self.mapView)
    
            let newLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
            
            let distance = nonNilCurrentLocation.distance(from: newLocation)

            guard distance <= 200 else {
                if let currCoordinates = self.currentCoordinates {
                    self.delegate?.coordinatesDidUpdate(coordinates: self.goToCoordinates(coordinates: currCoordinates,
                                                                                          showPin: self.showPin,
                                                                                          animated: self.animateTransition))
                }
                return
            }
            
            self.delegate?.coordinatesDidUpdate(coordinates: self.goToCoordinates(coordinates: coordinates,
                                                                                  showPin: self.showPin,
                                                                                  animated: self.animateTransition))
        }
    }
}
