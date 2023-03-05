//
//  StepView.swift
//  cal_ios_sdk_commonutils
//
//  Created by Jorge Cruz on 09/04/21.
//

import UIKit

open class BAZ_StepView: UIView {

    private var step : Int?
    private var numberOfStep: Int?
    private var titleSection: String?
    private let sectionInsets = UIEdgeInsets(
      top: 5.0,
      left: 12.0,
      bottom: 5.0,
      right: 12.0)
    
    lazy var stepMenu: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        let layout  = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 100, height: 36)
        collectionView.collectionViewLayout = layout
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    public init(_ step:Int,
         _ numberOfStep: Int,
         _ titleSection: String = "") {
        self.step = step
        self.numberOfStep = numberOfStep
        self.titleSection = titleSection
        super.init(frame: .zero)
        buildUI()
        buildConstraint()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func buildUI(){
        self.stepMenu.delegate = self
        self.stepMenu.dataSource = self
        self.stepMenu.register(BAZ_StepCheckCollectionCell.self, forCellWithReuseIdentifier: "bAZ_StepCheckCollectionCell")
        self.stepMenu.register(BAZ_StepNumberCollectionCell.self, forCellWithReuseIdentifier: "bAZ_StepNumberCollectionCell")
        self.addSubview(stepMenu)
    }
    
    
    fileprivate func buildConstraint(){
        NSLayoutConstraint.activate([
            self.stepMenu.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.stepMenu.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.stepMenu.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            self.stepMenu.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            self.stepMenu.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    public func refreshStep(step: Int){
        self.step = step
        stepMenu.reloadData()
    }
}

extension BAZ_StepView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ((numberOfStep ?? 0) - ((step ?? 0 ) - 1))
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellNumber = collectionView.dequeueReusableCell(withReuseIdentifier: "bAZ_StepNumberCollectionCell", for: indexPath) as! BAZ_StepNumberCollectionCell
        cellNumber.itemNumber.text = "\(indexPath.row + (step ?? 0))"
        cellNumber.titleSection.text = step == (indexPath.row + (step ?? 0)) ? titleSection : ""
        step == (indexPath.row + (step ?? 0)) ? cellNumber.buildCurrentStep() : cellNumber.buildNextStep()
        return cellNumber
        
    }
    
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let paddingSpace = sectionInsets.left * CGFloat(numberOfStep ?? 0) + sectionInsets.right + sectionInsets.left
//        let availableWidth = self.frame.width - paddingSpace
//        let widthPerItem = availableWidth / CGFloat(numberOfStep ?? 0)
//        return  CGSize(width: widthPerItem ,  height: widthPerItem )
//    }
    
    public func collectionView( _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    
}
