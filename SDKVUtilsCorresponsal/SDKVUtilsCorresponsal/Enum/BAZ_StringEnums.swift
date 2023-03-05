//
//  ActivitiesType.swift
//  cal_ios_sdk_commonutils
//
//  Created by Jorge Cruz on 30/03/21.
//

import UIKit

public enum BAZ_ShareActionType: String{
    case Email = "Correo"
    case Share = "Compartir"
    case Print = "Reimprimir"
    case SMS = "Compartir vía SMS"
}

public enum BAZ_ActivitiesType: String{
    case Buy = "Compras"
    case Config = "Configurar"
}

public enum  BAZ_OptionsMenuType: String{
    case Test = "Evalua"
    case Afiliar = "Afilia"
    case Validate = "Valida"
    case Setting = "Configurar"

    case MobileService = "Tiempo Aire"
    case GifCard = "Tarjeta Regalo"
    
    
    case Abono = "Abono a cuenta"
    
    case ConsultaSaldo = "Consulta de saldo"
    case ConsultaMovimiento = "Consulta de movimientos"
    case Deposit = "Depósito Tarjeta/Cuenta"
    case DepositTarjeta = "Depósito Tarjeta"
    case DepositCuenta = "Depósito Cuenta"
    case Withdraw = "Retiro de efectivo"
    
    case PrestaPrenda = "PrestaPrenda"
    case Services = "Servicios"
    case Credite = "Crédito"
    case CrediteCard = "Tarjeta de Crédito"
    
    case Cash = "Efectivo"
    case Card = "Tarjeta"
    case AcccountNumber = "Número de cuenta"
    case QR = "QR"
    
    case OperationHistory = "Detalle de Operaciones"
}

public enum BAZ_VerificationCodeType:String{
    case StatusEmail = "Validate Email Estatus"
    case Email = "Correo electrónico"
    case PhoneNumber = "Teléfono celular"
}
public enum BAZ_AgreementDocumentType: String{
    case FromSerialNumber = "FromSerialNumber"
    case FromPersonalInformation = "FromPersonalInformation"
}

public enum BAZ_AlertViewType: String{
    case Successfuly = "Successfuly"
    case Failure = "Failure"
    case Consult = "Consult"
}

public enum BAZ_UserLoginType: String{
    case Corresponsal = "Corresponsal"
    case Adquirente = "Adquirente"
}

public enum BAZ_TypeInputMode: String{
    case NormalEntity = "NormalEntity"
    case DateEntity = "DateEntity"
    case OptionEntity = "OptionEntity"
    case SelectEntity = "SelectEntity"
    case MultiOptionEntity = "MultiOptionEntity"
}

public enum BAZ_AcpUserStatus: String{
    case WrongCredentials   =   "4"
    case Inactive           =   "7"
    case ChangeCredential   =   "8"
    case Locked             =   "9"
}

public enum BAZ_Keys: String{
    case updateProductList = "updateProductList"
}
