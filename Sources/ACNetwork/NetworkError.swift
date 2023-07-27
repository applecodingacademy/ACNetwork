//
//  NetworkError.swift
//  
//
//  Created by Julio César Fernández Muñoz on 26/7/23.
//

import Foundation

public enum NetworkError:Error {
    case general(Error)
    case status(Int)
    case json(Error)
    case dataNotValid
    case noHTTP
    case vapor(String, Int)
    case unknown
    
    public var description:String {
        switch self {
        case .general(let error):
            return "Error general \(error.localizedDescription)"
        case .status(let int):
            return "Error de Status: \(int)"
        case .json(let error):
            return "Error en el JSON: \(error)"
        case .dataNotValid:
            return "Dato no válido"
        case .noHTTP:
            return "No es una conexión HTTP"
        case .vapor(let reason, _):
            return reason
        case .unknown:
            return "Error desconocido"
        }
    }
}
