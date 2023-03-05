//
//  BAZ_AlertTerminalCollectionCell.swift
//  SDKVUtilsCorresponsal
//
//  Created by Gustavo Tellez on 20/12/21.
//

import UIKit

internal class BAZ_AlertTerminalCollectionCell: UICollectionViewCell {
    
    public lazy var lbTerminalName: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = BAZ_ColorManager.navyBlueDarkRW
        label.font = UIFont.Poppins_Regular_13
        label.textAlignment = .left
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imgTerminal: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(bazNamed: "terminalIcon")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 20.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public static let identifier : String = "TerminalCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildUIElements()
        buildConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildUIElements() {
        self.contentView.addSubview(imgTerminal)
        self.contentView.addSubview(lbTerminalName)
    }
    
    private func buildConstraints() {
        
        NSLayoutConstraint.activate([
            
            imgTerminal.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            imgTerminal.widthAnchor.constraint(equalToConstant: 22.0),
            imgTerminal.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 50.0),
            imgTerminal.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            
            lbTerminalName.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            lbTerminalName.leadingAnchor.constraint(equalTo: imgTerminal.trailingAnchor, constant: 16.0),
            lbTerminalName.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5.0),
            lbTerminalName.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
}
