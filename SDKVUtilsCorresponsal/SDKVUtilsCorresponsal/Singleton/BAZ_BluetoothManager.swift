//
//  BAZ_BluetoothManager.swift
//  SDKVUtilsCorresponsal
//
//  Created by Gustavo Tellez on 07/02/22.
//

import Foundation
import CoreBluetooth

public protocol BAZ_BluetoothManagerProtocol: AnyObject{
    func notifySuccessfulBluetoothPermission()
    func notifyDenniedBluetoothPermission(message: String, state: CBManagerState)
}

open class BAZ_BluetoothManager: NSObject, CBCentralManagerDelegate{
    
    public var bluetoohPermissionWasRecovery: Bool = false
    private var bluetoohManager: CBCentralManager?
    public weak var delegate: BAZ_BluetoothManagerProtocol?
    
    public func getPermissionStatus(){
        bluetoohManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state{
        case .poweredOn:
            delegate?.notifySuccessfulBluetoothPermission()
            break
            
        case .poweredOff:
            delegate?.notifyDenniedBluetoothPermission(message: "El bluetooth se encuentra apagado. Por favor activelo", state: .poweredOff)
            break
            
        case .unauthorized:
            delegate?.notifyDenniedBluetoothPermission(message: "La comunicación bluetooth está inhabilitada en las configuraciones del iPhone. Por favor active el permiso bluetooth para esta app", state: .unauthorized)
            break
            
        case .unsupported:
            delegate?.notifyDenniedBluetoothPermission(message: "El dispositivo no soporta bluetooth", state: .unsupported)
            break
            
        case .resetting:
            delegate?.notifyDenniedBluetoothPermission(message: "Se necesita resetar", state: .resetting)
            break
            
        case .unknown:
            delegate?.notifyDenniedBluetoothPermission(message: "EL estatus es desconocido", state: .unknown)
            break
            
        @unknown default:
            //fatalError()
            delegate?.notifyDenniedBluetoothPermission(message: "Ocurrió un error inesparado con la comunicación bluetooh.", state: .unknown)
            break
        }
    }
}
