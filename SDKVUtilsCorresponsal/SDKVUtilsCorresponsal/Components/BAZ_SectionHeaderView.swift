//
//  BAZ_SectionHeaderView.swift
//  SDKVUtilsCorresponsal
//
//  Created by Gustavo Tellez on 20/05/22.
//

import UIKit

public class BAZ_SectionHeaderView: UIView {
    
    public lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = BAZ_ColorManager.purpleToolBarRW
        view.layer.cornerRadius = 8.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public lazy var lbTitle: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    public init(title: String,
                titleColor: UIColor = BAZ_ColorManager.navyBlueDarkRW,
                titleFont: UIFont = UIFont.Poppins_Bold_16){
        
        super.init(frame: CGRect.zero)
        
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.buildUIElements(title: title, titleColor: titleColor, titleFont: titleFont)
        self.buildContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUIElements(title: String, titleColor: UIColor, titleFont: UIFont){
        
        lbTitle.text = title
        lbTitle.textColor = titleColor
        lbTitle.font = titleFont
        
        self.addSubview(indicatorView)
        self.addSubview(lbTitle)
    }
    
    private func buildContraints(){
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 40.0),
            
            indicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            indicatorView.heightAnchor.constraint(equalToConstant: 16.0),
            indicatorView.widthAnchor.constraint(equalToConstant: 16.0),
            indicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -8.0),
            
            lbTitle.topAnchor.constraint(equalTo: self.topAnchor),
            lbTitle.leadingAnchor.constraint(equalTo: indicatorView.trailingAnchor, constant: 20.0),
            lbTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10.0),
            lbTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
