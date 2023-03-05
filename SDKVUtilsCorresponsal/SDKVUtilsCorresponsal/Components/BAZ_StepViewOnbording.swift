//
//  BAZ_StepViewOnbording.swift
//  baz-ios-akpago-utils
//
//  Created by Jorge Cruz on 13/08/21.
//

import UIKit


open class BAZ_StepViewOnbording: UIView {

    private var step : Int?
    private var numberOfStep: Int?
    private let sectionInsets = UIEdgeInsets(
      top: 5.0,
      left: 12.0,
      bottom: 5.0,
      right: 12.0)
    
    lazy var stepMenu: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true
        collectionView.collectionViewLayout = UICollectionViewFlowLayout.init()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    public init(_ step:Int,
         _ numberOfStep: Int) {
        self.step = step
        self.numberOfStep = numberOfStep
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
        self.stepMenu.register(BAZ_StepCheckOnbordingCollectionCell.self, forCellWithReuseIdentifier: "BAZ_StepCheckOnbordingCollectionCell")
        self.stepMenu.register(BAZ_StepNumberOnbordingCollectionCell.self, forCellWithReuseIdentifier: "BAZ_StepNumberOnbordingCollectionCell")
        self.addSubview(stepMenu)
    }
    
    
    fileprivate func buildConstraint(){
        NSLayoutConstraint.activate([
            self.stepMenu.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.stepMenu.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            self.stepMenu.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            self.stepMenu.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            self.stepMenu.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    public func refreshStep(step: Int){
        self.step = step
        stepMenu.reloadData()
    }
}

extension BAZ_StepViewOnbording: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfStep ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(indexPath.row + 1 < step ?? 0){
            let cellCheck = collectionView.dequeueReusableCell(withReuseIdentifier: "BAZ_StepCheckOnbordingCollectionCell", for: indexPath) as! BAZ_StepCheckOnbordingCollectionCell
            cellCheck.buildCurrentStep()
            return cellCheck
        }else{
            let cellNumber = collectionView.dequeueReusableCell(withReuseIdentifier: "BAZ_StepNumberOnbordingCollectionCell", for: indexPath) as! BAZ_StepNumberOnbordingCollectionCell
            cellNumber.itemNumber.text = "\(indexPath.row + 1)"
            step == indexPath.row + 1 ? cellNumber.buildCurrentStep() : cellNumber.buildNextStep()
            return cellNumber
        }
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * CGFloat(numberOfStep ?? 0) + sectionInsets.right + sectionInsets.left
        let availableWidth = self.frame.width - paddingSpace
        let widthPerItem = availableWidth / CGFloat(numberOfStep ?? 0)
        return  CGSize(width: widthPerItem ,  height: widthPerItem )
    }
    
    public func collectionView( _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    
}
