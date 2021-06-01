//
//  CreateCacaoAccountRequest.swift
//  Hugo
//
//  Created by Jose Francisco Rosales Hernandez on 19/02/21.
//  Copyright © 2021 Clever Mobile Apps. All rights reserved.
//

import Foundation

struct CreateCacaoAccountRequest: APIRequest {

    public typealias Response = CreateCacaoAccountResponse

    public var resourceName: String {

        return "api/v1/cacao/account"
    }

    public let client_id: String
    public let tipoManufactura: String = "V"
    public let nombre: String = "Alejandro"
    public let primerApellido: String = "Perez"
    public let segundoApellido: String = "Martinez"
    public let nombreEmbozado: String = "Mi primer tajeta hugo"
    public let correo: String = "alejandro@hugoapp.com"
    public let telefono: String = "50363138396"
    public let rfc: String = "XAXX010101001"
    public let fechaNacimiento: String = "1988-11-02"
    public let genero: String = "M"
    public let entidadNacimiento: String = "15"
    public let ocupacion: String = "Empleado"
    public let profesion: String = "Ingeniero"
    public let giroNegocio: String = "Medios de Pago"
    public let latitud: String = "1.000"
    public let longitud: String = "1.000"
    public let ciudad: String = "NombreCiudad"
    public let calle: String = "Calle"
    public let numExterior: String = "6"
    public let colonia: String = "Colonia"
    public let delegacion: String = "Delegacion"
    public let claveMunicipio: String = "106"
    public let claveEstado: String = "15"
    public let cp: String = "50130"
}
