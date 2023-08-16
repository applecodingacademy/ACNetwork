//
//  NetworkError.swift
//  
//
//  Created by Julio César Fernández Muñoz on 26/7/23.
//

import Foundation

/// Enumeración con los distintos posibles tipos de error que pueden darse en las llamadas de la librería.
///
/// Dependiendo del tipo de error que nos de la librería, tenemos distintos `case` que nos devolverán mediante valores asociados información relacionada con los errores, así como una propiedad `description` que nos proporcionará el error como `string` para poder saber o informar al usuario de qué ha sucedido en caso de error.
public enum NetworkError:Error {
    /// Caso de error general con el tipo `Error` como valor asociado.
    case general(Error)
    /// Caso de error de estado HTTP que tendrá embebido el valor de estado devuelto en un `Int`
    case status(Int)
    /// Error en la decodificación del JSON (o codificación) por algún error en el mismo. Lleva el tipo `Error` porque al imprimir el tipo completo tendremos una descripción más larga con el error concreto que ha habido.
    case json(Error)
    /// Tipo de dato no válido a lo que se esperaba. Por ejemplo: una imagen que no es imagen.
    case dataNotValid
    /// Error que ha sido devuelto porque el `URLResponse` que se ha devuelto no es el del tipo `HTTPURLResponse`
    case noHTTP
    /// Error dado por un *server* en **Vapor**, que contiene la cadena `reason` con el error que envía el servidor
    case vapor(String, Int)
    /// Error desconocido
    case unknown
    
    /// Permite saber de una manera textual y extrayendo los tipos asociados de la enumeración, qué ha pasado, preparado para ser mostrado al usuario en algún tipo de alerta dentro la UI.
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
