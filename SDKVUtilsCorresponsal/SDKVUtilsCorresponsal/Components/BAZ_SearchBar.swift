//
//  BAZ_SearchBar.swift
//  SDKVUtilsCorresponsal
//
//  Created by Dsi Soporte Tecnico on 02/02/22.
//

import UIKit


public protocol BAZ_SearchBarDelegate{
    func getFilterString(filter: String)
}

open class BAZ_SearchBar: UIView {
    
    private lazy var searchButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(searchInfo), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var searchTextField: UITextField = {
        let txt = UITextField()
        txt.textColor = BAZ_ColorManager.navyBlueDarkRW
        txt.font = .Poppins_Medium_16
        txt.placeholder  = "Buscar"
        txt.keyboardType = .asciiCapable
        txt.backgroundColor = UIColor.clear
        txt.addTarget(self, action: #selector(searchInfo), for: .editingChanged)
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    private var delegate: BAZ_SearchBarDelegate?
    
    public init(delegate: BAZ_SearchBarDelegate, imageName: String = "accessibilitySearchIcon", imageColor: UIColor = BAZ_ColorManager.purpleToolBarRW){
        super.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        setupUIElements(delegate: delegate, imageName: imageName, imageColor: imageColor)
        setupContraints()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUIElements(delegate: BAZ_SearchBarDelegate, imageName: String, imageColor: UIColor){
        
        self.delegate = delegate
        
        let imgButton = UIImage(bazNamed: imageName)
        searchButton.setImage(imgButton, for: .normal)
        searchButton.tintColor = imageColor
        
        self.addSubview(searchButton)
        self.addSubview(searchTextField)
    }
    
    private func setupContraints(){
        NSLayoutConstraint.activate([
            searchButton.topAnchor.constraint(equalTo: self.topAnchor),
            searchButton.heightAnchor.constraint(equalToConstant: 61.0),
            searchButton.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1.0),
            searchButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            searchButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            searchTextField.topAnchor.constraint(equalTo: self.topAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: searchButton.trailingAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10.0),
            searchTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    @objc func searchInfo(){
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchInfoWithDelay), object: nil)
        self.perform(#selector(searchInfoWithDelay), with: nil, afterDelay: 0.5)
    }
    
    @objc func searchInfoWithDelay() {
        delegate?.getFilterString(filter: searchTextField.text ?? "")
    }
}
