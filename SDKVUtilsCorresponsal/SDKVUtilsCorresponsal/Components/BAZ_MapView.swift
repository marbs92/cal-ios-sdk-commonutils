//
//  BAZ_MapView.swift
//  baz-ios-akpago-utils
//
//  Created by Jorge Cruz on 21/04/21.
//

import UIKit
import GoogleMaps


open class BAZ_MapView: UIView {

    private var mapManager: BAZ_GoogleMaps? = nil
    private lazy var placeHolderUp: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.Poppins_Medium_14
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = BAZ_ColorManager.navyBlueDarkRW
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var containerMap: UIView = {
        let view = UIView(frame: .zero)
        view.isUserInteractionEnabled = false
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    public convenience init(
        title: String,
        titleFont: UIFont = UIFont.Poppins_Medium_14,
        titleColor: UIColor = BAZ_ColorManager.navyBlueDarkRW,
        
        helperText: String,
        helperTextFont: UIFont = UIFont.Poppins_Medium_14,
        helperTextColor: UIColor = BAZ_ColorManager.navyBlueDarkRW) {
        self.init()
        
        self.placeHolderUp.text = title
        self.placeHolderUp.font = titleFont
        self.placeHolderUp.textColor = titleColor
        
        self.helperText.text = helperText
        self.helperText.font = helperTextFont
        self.helperText.textColor = helperTextColor
        
        GMSServices.provideAPIKey("AIzaSyBQBUwnIwMow86zVJas82rpYYI_SMkUKLk")
        buildUI()
        buildConstraint()
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func buildUI(){
        self.addSubview(placeHolderUp)
        self.addSubview(containerMap)
        self.addSubview(helperText)
        
        mapManager = BAZ_GoogleMaps(delegate: self)
        mapManager?.addMapToView(containerMap)
    }
    
    
    fileprivate func buildConstraint(){
        NSLayoutConstraint.activate([
        
            placeHolderUp.topAnchor.constraint(equalTo: self.topAnchor),
            placeHolderUp.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            placeHolderUp.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            containerMap.topAnchor.constraint(equalTo: placeHolderUp.bottomAnchor, constant: 5),
            containerMap.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerMap.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerMap.heightAnchor.constraint(equalTo: containerMap.widthAnchor, multiplier: 0.7, constant: 0),
            
            helperText.topAnchor.constraint(equalTo: containerMap.bottomAnchor, constant: 5),
            helperText.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            helperText.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            helperText.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
}

extension BAZ_MapView: GoogleMapsDelegate{
    func updatedMarker(information: BAZ_GoogleMaps.Marker?) {
        //TODO: Terminar funcionalidad
        ()
    }
}
