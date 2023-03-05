//
//  ASAP_MigrationLoginValidationViewUI.swift
//  GSSAAceptaPago
//
//  Created by phinder on 02/11/22.
//

import Foundation
import UIKit

protocol ASAP_MigrationLoginValidationViewUIDelegate {
    
}

class ASAP_MigrationLoginValidationViewUI: UIView{
    var delegate: ASAP_MigrationLoginValidationViewUIDelegate?
    var navigationController: UINavigationController?
    
    public convenience init(
        navigation: UINavigationController,
        delegate: ASAP_MigrationLoginValidationViewUIDelegate){
            self.init()
            self.delegate = delegate
            self.navigationController = navigation
            
            setUI()
            setConstraints()
        }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUI(){
        
    }
    
    func setConstraints(){
        NSLayoutConstraint.activate([
            
        ])
    }
}
