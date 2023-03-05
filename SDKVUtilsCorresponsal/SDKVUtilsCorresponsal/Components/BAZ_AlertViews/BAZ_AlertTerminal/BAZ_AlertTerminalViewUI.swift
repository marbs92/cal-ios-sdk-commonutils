//
//  BAZ_AlertTerminalViewUI.swift
//  SDKVUtilsCorresponsal
//
//  Created by Gustavo Tellez  on 06/11/21.
//

import UIKit
import Lottie

internal class BAZ_AlertTerminalViewUI: UIView {
    
    private lazy var headerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0.0
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var lbTitle: UILabel = {
        let lb = UILabel()
        lb.text = "Conecte su dispositivo"
        lb.textAlignment = NSTextAlignment.center
        lb.textColor = BAZ_ColorManager.navyBlueDarkRW
        lb.font = UIFont.Poppins_Medium_15
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    private lazy var lbSubTitle: UILabel = {
        let lb = UILabel()
        lb.text = "Seleccione una terminal"
        lb.textAlignment = NSTextAlignment.center
        lb.textColor = BAZ_ColorManager.greenHightDarkRW
        lb.font = UIFont.Poppins_Regular_13
        lb.isHidden = true
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    private lazy var btnClose: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.clear
        btn.tintColor = BAZ_ColorManager.violet
        btn.addTarget(self, action: #selector(btnClosePressed), for: .touchUpInside)
        btn.setImage(UIImage(bazNamed: "closeIcon"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var imgTerminalStatus: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.isHidden = true
        imgView.image = UIImage(bazNamed: "alertSuccessIcon")
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    private lazy var animationConexionTerminalSuccess: AnimationView = {
        let lottie = AnimationView(animation: Animation.named("conexionTerminalAc", bundle: Bundle.local_ak_utils, subdirectory: nil, animationCache: nil))
        lottie.isHidden = true
        lottie.contentMode = .scaleAspectFill
        lottie.clipsToBounds = true
        lottie.backgroundBehavior = .pauseAndRestore
        lottie.loopMode = LottieLoopMode.loop
        lottie.translatesAutoresizingMaskIntoConstraints = false
        return lottie
    }()
    
    private lazy var animationTerminal: AnimationView = {
        let lottie = AnimationView(animation: Animation.named("connection_tvp", bundle: Bundle.local_ak_utils, subdirectory: nil, animationCache: nil))
        lottie.contentMode = .scaleAspectFill
        lottie.clipsToBounds = true
        lottie.backgroundBehavior = .pauseAndRestore
        lottie.loopMode = LottieLoopMode.loop
        lottie.translatesAutoresizingMaskIntoConstraints = false
        return lottie
    }()
    
    private lazy var animationConexionTerminalFailure: AnimationView = {
        let lottie = AnimationView(animation: Animation.named("ConexionTerminalFailureAc", bundle: Bundle.local_ak_utils, subdirectory: nil, animationCache: nil))
        lottie.isHidden = true
        lottie.contentMode = .scaleAspectFill
        lottie.clipsToBounds = true
        lottie.backgroundBehavior = .pauseAndRestore
        lottie.loopMode = LottieLoopMode.loop
        lottie.translatesAutoresizingMaskIntoConstraints = false
        return lottie
    }()
    
    public lazy var lbStatus: UILabel = {
        let lb = UILabel()
        lb.text = "Buscando terminal..."
        lb.textAlignment = NSTextAlignment.center
        lb.textColor = BAZ_ColorManager.navyBlueDarkRW
        lb.font = UIFont.Poppins_Medium_15
        lb.minimumScaleFactor = 0.6
        lb.adjustsFontSizeToFitWidth = true
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    public lazy var btnRetry: BAZ_UpdatedButtonView = {
        let btn = BAZ_UpdatedButtonView(titleText: "Reintentar", textAlignment: .Center, showIcon: false)
        btn.addTarget(self, action: #selector(btnRetryPressed), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    public lazy var terminalCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collection.backgroundColor = .clear
        collection.isPagingEnabled = false
        collection.delegate = self
        collection.dataSource = self
        collection.collectionViewLayout = UICollectionViewFlowLayout.init()
        collection.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: spacingCollection, right: 0)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(BAZ_AlertTerminalCollectionCell.self, forCellWithReuseIdentifier: BAZ_AlertTerminalCollectionCell.identifier)
        return collection
    }()
    
    private var sectionInsets : UIEdgeInsets{
        get{
            return UIEdgeInsets(top: spacingCollection, left: 15.0, bottom: 0.0, right: 15.0)
        }
    }
    
    private var spacingCollection : CGFloat {
        get{
            return UIScreen.main.bounds.height > 667 ? 30.0 : 10.0
        }
    }
    
    public var terminalList: [String] = [] {
        didSet{
            terminalCollection.reloadData()
        }
    }
    
    private let screen              =   UIScreen.main.bounds
    private var terminalSelected    =   ""
    private var parentFlow          :   BAZ_ParentFlowTerminal?
    public weak var delegate        :   BAZ_AlertTerminalViewDelegate?
    
    public init(parentFlow: BAZ_ParentFlowTerminal){
        let heightView = screen.height < 667 ? screen.height * 0.6 : screen.height * 0.5
        let frame = CGRect(x: 0.0, y: screen.height, width: screen.width, height: heightView)
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.roundCorners(corners: [.topLeft, .topRight], radius: 26)
        self.parentFlow = parentFlow
        
        setupComponents()
        setupLayoutComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupComponents(){
        
        changeStatusTerminal(to: .searching, terminal: "", terminalList: [])
        
        headerStack.addArrangedSubview(lbTitle)
        headerStack.addArrangedSubview(lbSubTitle)
        
        [headerStack, btnClose, imgTerminalStatus, animationConexionTerminalSuccess, animationConexionTerminalFailure,
         terminalCollection, animationTerminal, lbStatus, btnRetry].forEach { component in
            self.addSubview(component)
        }
    }
    
    private func setupLayoutComponents(){
        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 22.0),
            headerStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            headerStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            lbTitle.heightAnchor.constraint(equalToConstant: 40.0),
            lbSubTitle.heightAnchor.constraint(equalToConstant: 20.0),
            
            btnClose.topAnchor.constraint(equalTo: self.topAnchor, constant: 20.0),
            btnClose.heightAnchor.constraint(equalToConstant: 40.0),
            btnClose.widthAnchor.constraint(equalToConstant: 40.0),
            btnClose.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10.0),
            
            imgTerminalStatus.topAnchor.constraint(equalTo: headerStack.bottomAnchor),
            imgTerminalStatus.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imgTerminalStatus.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imgTerminalStatus.bottomAnchor.constraint(equalTo: lbStatus.topAnchor),
            
            animationConexionTerminalSuccess.topAnchor.constraint(equalTo: headerStack.bottomAnchor),
            animationConexionTerminalSuccess.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            animationConexionTerminalSuccess.heightAnchor.constraint(equalTo: animationTerminal.heightAnchor),
            animationConexionTerminalSuccess.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            animationConexionTerminalFailure.topAnchor.constraint(equalTo: headerStack.bottomAnchor),
            animationConexionTerminalFailure.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            animationConexionTerminalFailure.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            animationConexionTerminalFailure.heightAnchor.constraint(equalTo: animationTerminal.heightAnchor),
            
            terminalCollection.topAnchor.constraint(equalTo: headerStack.bottomAnchor),
            terminalCollection.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            terminalCollection.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            terminalCollection.heightAnchor.constraint(equalTo: animationTerminal.heightAnchor),
            
            animationTerminal.topAnchor.constraint(equalTo: headerStack.bottomAnchor),
            animationTerminal.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            animationTerminal.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            btnRetry.topAnchor.constraint(equalTo: animationTerminal.bottomAnchor, constant: 5.0),
            btnRetry.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 60.0),
            btnRetry.heightAnchor.constraint(equalToConstant: 50.0),
            btnRetry.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -60.0),
            
            lbStatus.topAnchor.constraint(equalTo: btnRetry.bottomAnchor, constant: 8.0),
            lbStatus.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20.0),
            lbStatus.heightAnchor.constraint(equalToConstant: 40.0),
            lbStatus.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20.0),
            lbStatus.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -32.0)
        ])
    }
    
    @objc func btnRetryPressed(){
        delegate?.retryConnection()
    }
    
    @objc func btnClosePressed(){
        delegate?.cancelConnection()
    }
    
    public func changeStatusTerminal(to status: BAZ_AlertTerminalStatus, terminal: String, terminalList: [String]){
        switch status {
        case .searching:
            
            if self.parentFlow == .AceptaPago{
                animationConexionTerminalSuccess.stop()
                animationConexionTerminalSuccess.isHidden = true
                animationConexionTerminalFailure.stop()
                animationConexionTerminalFailure.isHidden = true
            }else{
                imgTerminalStatus.isHidden = true
            }
            
            terminalCollection.isHidden = true
            animationTerminal.alpha = 0.0
            animationTerminal.play()
            animationTerminal.isHidden = false
            lbStatus.text = "Buscando terminal..."
            lbSubTitle.isHidden = true
            btnRetry.setEnableButton(enable: false)
            
            UIView.animate(withDuration: 1.0) {
                self.animationTerminal.alpha = 1.0
            }
            
            break
            
        case .connecting:
            if self.parentFlow == .AceptaPago{
                animationConexionTerminalSuccess.stop()
                animationConexionTerminalSuccess.isHidden = true
                animationConexionTerminalFailure.stop()
                animationConexionTerminalFailure.isHidden = true
            }else{
                imgTerminalStatus.isHidden = true
            }
            
            terminalSelected = terminal
            terminalCollection.isHidden = true
            animationTerminal.alpha = 0.0
            animationTerminal.play()
            animationTerminal.isHidden = false
            lbStatus.text = "Conectando con terminal..."
            lbSubTitle.isHidden = true
            btnRetry.setEnableButton(enable: false)
            
            UIView.animate(withDuration: 1.0) {
                self.animationTerminal.alpha = 1.0
            }
            
            break
            
        case .selectingTerminal:
            if self.parentFlow == .AceptaPago{
                animationConexionTerminalSuccess.stop()
                animationConexionTerminalSuccess.isHidden = true
                animationConexionTerminalFailure.stop()
                animationConexionTerminalFailure.isHidden = true
            }else{
                imgTerminalStatus.isHidden = true
            }
            
            animationTerminal.isHidden = true
            animationTerminal.stop()
            terminalCollection.alpha = 0.0
            self.terminalList = terminalList
            terminalCollection.isHidden = false
            lbStatus.text = ""
            lbSubTitle.isHidden = false
            btnRetry.setEnableButton(enable: false)
            
            UIView.animate(withDuration: 1.0) {
                self.terminalCollection.alpha = 1.0
            }
            
            break
            
        case .connected:
            animationTerminal.isHidden = true
            animationTerminal.stop()
            terminalCollection.isHidden = true
            lbSubTitle.isHidden = true
            
            lbStatus.text = "Terminal \(terminalSelected) conectada"
            btnRetry.setEnableButton(enable: false)
            
            if self.parentFlow == .AceptaPago{
                animationConexionTerminalSuccess.play()
                animationConexionTerminalSuccess.isHidden = false
                animationConexionTerminalFailure.stop()
                animationConexionTerminalFailure.isHidden = true
                
            }else{
                imgTerminalStatus.alpha = 0.0
                imgTerminalStatus.image = UIImage(bazNamed: "alertSuccessIcon")
                imgTerminalStatus.isHidden = false
                
                UIView.animate(withDuration: 1.0) {
                    self.imgTerminalStatus.alpha = 1.0
                }
            }
            
            break
            
        case .FailedConnection:
            animationTerminal.isHidden = true
            terminalCollection.isHidden = true
            lbSubTitle.isHidden = true
            
            lbStatus.text = "No se pudo conectar a terminal"
            btnRetry.setEnableButton(enable: true)
            
            if self.parentFlow == .AceptaPago{
                animationConexionTerminalFailure.play()
                animationConexionTerminalFailure.isHidden = false
                animationConexionTerminalSuccess.stop()
                animationConexionTerminalSuccess.isHidden = true
                
            }else{
                imgTerminalStatus.alpha = 0.0
                imgTerminalStatus.image = UIImage(bazNamed: "alertErrorIcon")
                imgTerminalStatus.isHidden = false
                
                UIView.animate(withDuration: 1.0) {
                    self.imgTerminalStatus.alpha = 1.0
                }
            }
            
            break
        }
    }
    
    private func hideComponents(){
        animationConexionTerminalSuccess.isHidden = true
        animationTerminal.isHidden = true
        imgTerminalStatus.isHidden = true
        lbStatus.isHidden = true
    }
}

extension BAZ_AlertTerminalViewUI: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return terminalList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthItem = collectionView.frame.width
        let heightItem : CGFloat = 36.0
        
        return  CGSize(width: widthItem,  height: heightItem)
    }
    
    func collectionView( _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 17
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BAZ_AlertTerminalCollectionCell.identifier, for: indexPath) as! BAZ_AlertTerminalCollectionCell
        
        cell.lbTerminalName.text = terminalList[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.sendTerminalSelected(terminalList[indexPath.row], position: indexPath.row)
    }
}
