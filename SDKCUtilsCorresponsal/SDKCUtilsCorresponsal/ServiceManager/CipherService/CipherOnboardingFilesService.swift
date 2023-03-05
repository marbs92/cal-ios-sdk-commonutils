//
//  CipherOnboardingFilesService.swift
//  SDKCUtilsCorresponsal
//
//  Created by Luis Grano on 13/04/22.
//

import Foundation
import CommonCrypto


internal class CipherOnboardingFilesKeys {
    internal static let shared = CipherOnboardingFilesKeys()
    private var keyAES: String = ""
    private var keyHMAC: String = ""
    
    internal func setKeys(keyAES: String, keyHMAC: String) {
        self.keyAES = keyAES
        self.keyHMAC = keyHMAC
    }
    
    internal func getKeys(data: @escaping ((_ aes: String, _ hmac: String) -> ())) {
        data(self.keyAES, self.keyHMAC)
    }
    
    internal func deleteKeys() {
        self.keyAES = ""
        self.keyHMAC = ""
    }
}

open class CipherOnboardingFilesService {
    private let ivSize: Int = 16
    private var keyAES: String = ""
    private var keyHMAC: String = ""
    private var currentIV: Array<UInt8>? = nil

    public init() {
        CipherOnboardingFilesKeys.shared.getKeys { aes, hmac in
            self.keyAES = aes
            self.keyHMAC = hmac
        }
    }

    private func getIV(forceNew: Bool = false) -> Array<UInt8> {
        if  forceNew {
            let newIV = AES.randomIV(self.ivSize)
            self.currentIV = newIV
            return newIV
        } else {
            if let nonNilIV = self.currentIV {
                return nonNilIV
            } else {
                let newIV = AES.randomIV(self.ivSize)
                self.currentIV = newIV
                return newIV
            }
        }
    }
    
    public func encryptAES(_ str: String,
                           encrypted: @escaping (_ encrypted: String) -> ()) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard !self.keyAES.isEmpty, !self.keyHMAC.isEmpty else {
                encrypted("")
                return
            }
            
            do  {
                let aesInstance = try AES(key: self.getBytesArrayFromBase64(self.keyAES),
                                          blockMode: CBC(iv: self.getIV(forceNew: true)),
                                          padding: .pkcs5)
                
                let hmacInstance = HMAC(key: self.getBytesArrayFromBase64(self.keyHMAC),
                                        variant: .sha256)
                
                do {
                    let encryptedAES = try aesInstance.encrypt(self.getBytesArrayFromString(str))
                    
                    let concatIVEncryptedAES = self.concatenateArr(self.getIV(), encryptedAES)
                    
                    do {
                        let hmac = try hmacInstance.authenticate(concatIVEncryptedAES)
                        let concatIVEncryptedAESHMAC = self.concatenateArr(concatIVEncryptedAES, hmac)
                        encrypted(self.getBase64FromArray(concatIVEncryptedAESHMAC))
                        return
                    }
                    catch {
                        encrypted("")
                        return
                    }
                }
                catch {
                    encrypted("")
                    return
                }
            }
            catch {
                encrypted("")
                return
            }
        }
    }
    
    public func decryptAES(_ str: String,
                            decrypted: @escaping (_ decrypted: String) -> ()) {
        DispatchQueue.main.async {
            guard !self.keyAES.isEmpty, !self.keyHMAC.isEmpty else {
                decrypted("")
                return
            }
            
            let hmacInstance = HMAC(key: self.getBytesArrayFromBase64(self.keyHMAC),
                                    variant: .sha256)
            
            let completeBytesArr = self.getBytesArrayFromBase64(str)
            
            let cipherTextLenght = completeBytesArr.count - SHA2.Variant.sha256.digestLength
            
            guard completeBytesArr.count >= self.ivSize, completeBytesArr.count >= cipherTextLenght else {
                decrypted("")
                return
            }
            
            let receivedIV = Array(completeBytesArr[..<self.ivSize])
            
            let encryptedAES = Array(completeBytesArr[self.ivSize..<cipherTextLenght])
            
            let concatIVEncryptedAES = self.concatenateArr(receivedIV, encryptedAES)
            
            let recievedHMAC = Array(completeBytesArr[cipherTextLenght..<completeBytesArr.count])
            
            do {
                let hmac = try hmacInstance.authenticate(concatIVEncryptedAES)
                if hmac == recievedHMAC {
                    do {
                        let aesInstance = try AES(key: self.getBytesArrayFromBase64(self.keyAES),
                                                  blockMode: CBC(iv: receivedIV),
                                                  padding: .pkcs5)
                        do {
                            let decryptedArr = try aesInstance.decrypt(encryptedAES)
                            decrypted(self.getStringFromArray(decryptedArr))
                            return
                        }
                        catch {
                            decrypted("")
                            return
                        }
                    }
                    catch {
                        decrypted("")
                        return
                    }
                } else {
                    decrypted("")
                    return
                }
            }
            catch  {
                decrypted("")
                return
            }
        }
    }
    
    
    public func deleteKeys() {
        self.keyAES = ""
        self.keyHMAC = ""
    }
    
    
    private func getBytesArrayFromBase64(_ str: String) -> Array<UInt8> {
        return [UInt8].init(base64: str)
    }
    
    private func getBytesArrayFromString(_ str: String) -> Array<UInt8> {
        return Array(str.utf8)
    }
    
    private func getBase64FromArray(_ arr: Array<UInt8>) -> String{
        return arr.toBase64() ?? ""
    }
    
    private func getStringFromBase64(_ b64: String) -> String{
        let decodedBase64 = Data(base64Encoded: b64)
        return  String(data : decodedBase64 ?? Data(), encoding: .utf8) ?? ""
    }
    
    private func getStringFromArray(_ arr: Array<UInt8>) -> String {
        return self.getStringFromBase64(self.getBase64FromArray(arr))
    }
    
    private func concatenateArr(_ first: Array<UInt8>, _ second: Array<UInt8>) -> Array<UInt8> {
        var newArr = first
        newArr.append(contentsOf: second)
        return newArr
    }
}
