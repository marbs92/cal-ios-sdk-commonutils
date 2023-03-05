//
//  BAZ_MicroblinkOCR.swift
//  SDKVUtilsCorresponsal
//
//  Created by Luis Grano on 11/05/22.
//

import UIKit
import Microblink
 
private enum BAZ_MicroblinkOCRStep {
    case frontSide
    case backSide
}

open class BAZ_MicroblinkOCR: NSObject {
    public static let shared = BAZ_MicroblinkOCR()
    var recognizerRunner: MBRecognizerRunner?
    var blinkIdCombinedReconginzer: MBBlinkIdCombinedRecognizer?

    private var isScanningImage = false
    
    private var isMicroblinkStarted = false
    
    private var currentStep: BAZ_MicroblinkOCRStep = .frontSide
    
    private var firstStepSuccessCompletion: (()->())?
    private var firstStepFailureCompletion: (()->())?
    private var secondStepSuccessCompletion: ((_ data: BAZ_MicroblinkOCREntity) -> ())?
    private var secondStepFailureCompletion: (() -> ())?
    
    public func startMicroblink() {
        var recognizers = [MBRecognizer]()
        self.blinkIdCombinedReconginzer = MBBlinkIdCombinedRecognizer()
        recognizers.append(blinkIdCombinedReconginzer!)
        
        let recognizerCollection = MBRecognizerCollection(recognizers: recognizers)
        self.recognizerRunner = MBRecognizerRunner(recognizerCollection: recognizerCollection)
        self.recognizerRunner?.scanningRecognizerRunnerDelegate = self
        self.recognizerRunner?.metadataDelegates.firstSideFinishedRecognizerRunnerDelegate = self
        
        self.isMicroblinkStarted = true
    }
    
    public func stopMicroblink() {
        self.resetOCR()
        
        self.recognizerRunner?.scanningRecognizerRunnerDelegate = nil
        self.recognizerRunner?.metadataDelegates.firstSideFinishedRecognizerRunnerDelegate = nil
        self.blinkIdCombinedReconginzer = nil
        self.recognizerRunner = nil
        
        self.isMicroblinkStarted = false
    }
    
    public func resetOCR() {
        self.firstStepSuccessCompletion = nil
        self.firstStepFailureCompletion = nil
        self.secondStepSuccessCompletion = nil
        self.secondStepFailureCompletion = nil
        
        self.isScanningImage = false
        
        self.currentStep = .frontSide
        
        self.recognizerRunner?.resetState(true)
    }
    
    public func scanFrontSide(image: MBImage,
                              success: @escaping () -> (),
                              failure: @escaping () -> ()) {
        if !self.isMicroblinkStarted {
            self.startMicroblink()
        }
        
        if !self.isScanningImage {
            self.isScanningImage = true
            
            self.firstStepSuccessCompletion = success
            self.firstStepFailureCompletion = failure
            
            self.recognizerRunner?.processImage(image)
        }
    }
    
    public func scanBackSide(image: MBImage,
                             success: @escaping (_ data: BAZ_MicroblinkOCREntity) -> (),
                             failure: @escaping () -> ()) {
        if !self.isMicroblinkStarted {
            self.startMicroblink()
        }
        
        if !self.isScanningImage {
            self.isScanningImage = true
            
            self.currentStep = .backSide
            
            self.secondStepSuccessCompletion = success
            self.secondStepFailureCompletion = failure
            
            self.recognizerRunner?.processImage(image)
        }
    }
}


extension BAZ_MicroblinkOCR: MBFirstSideFinishedRecognizerRunnerDelegate, MBScanningRecognizerRunnerDelegate{
    public func recognizerRunnerDidFinishRecognition(ofFirstSide recognizerRunner: MBRecognizerRunner) { () }
    
    public func recognizerRunner(_ recognizerRunner: MBRecognizerRunner, didFinishScanningWith state: MBRecognizerResultState) {
        self.isScanningImage = false
        
        if state == MBRecognizerResultState.stageValid && self.currentStep == .frontSide {
            self.firstStepSuccessCompletion?()
            
            self.firstStepFailureCompletion = nil
            self.firstStepSuccessCompletion = nil
        } else if state == MBRecognizerResultState.uncertain {
            if self.currentStep == .frontSide {
                self.firstStepFailureCompletion?()
                
                self.firstStepFailureCompletion = nil
                self.firstStepSuccessCompletion = nil
            } else if self.currentStep == .backSide {
                self.secondStepFailureCompletion?()
                
                self.secondStepFailureCompletion = nil
                self.secondStepSuccessCompletion = nil
            }
        } else if state == MBRecognizerResultState.empty {
            if self.currentStep == .frontSide {
                self.firstStepFailureCompletion?()
                
                self.firstStepFailureCompletion = nil
                self.firstStepSuccessCompletion = nil
            } else if self.currentStep == .backSide {
                self.secondStepFailureCompletion?()
                
                self.secondStepFailureCompletion = nil
                self.secondStepSuccessCompletion = nil
            }
        } else if state == MBRecognizerResultState.valid && self.currentStep == .backSide {
            var data = BAZ_MicroblinkOCREntity()
            DispatchQueue.main.async { [self] in
                let blinkResult = blinkIdCombinedReconginzer?.result
                data.name = blinkResult?.fullName
                data.fatherLastname = blinkResult?.fathersName
                data.motherLastname = blinkResult?.mothersName
                data.birthDate = blinkResult?.dateOfBirth?.originalDateString
                data.curp = blinkResult?.personalIdNumber?.uppercased()
                data.rfc = blinkResult?.personalIdNumber?.prefix(10).uppercased()
                data.gender = blinkResult?.sex == "H" ? "M" : "F"
                data.ocr = blinkResult?.mrzResult?.opt1.replacingOccurrences(of: "<", with: "")
                if let arrayAddres = blinkIdCombinedReconginzer?.result.address?.split(separator: "\n"),
                      arrayAddres.count == 3 {
                      let arrayAddresMutable = arrayAddres
                      let cp = arrayAddres[1].suffix(5).lowercased()
                      let streetComponent = arrayAddresMutable[0].split(separator: " ")
                      let extNumber = streetComponent.last?.lowercased()
                      var streetComponentMutable = streetComponent
                      streetComponentMutable.removeLast()
                      let street = streetComponentMutable.joined(separator:  " ")
                    data.address = BAZ_MicroblinkOCREntity._Address()
                    data.address?.street = street
                    data.address?.externalNumber = extNumber
                    data.address?.zipCode = cp
                }
                
                self.secondStepSuccessCompletion?(data)
                
                self.resetOCR()
            }
        } else {
            if self.currentStep == .frontSide {
                self.firstStepFailureCompletion?()
                
                self.firstStepFailureCompletion = nil
                self.firstStepSuccessCompletion = nil
            } else if self.currentStep == .backSide {
                self.secondStepFailureCompletion?()
                
                self.secondStepFailureCompletion = nil
                self.secondStepSuccessCompletion = nil
            }
        }
    }
}
