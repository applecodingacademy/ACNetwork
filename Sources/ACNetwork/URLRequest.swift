//
//  URLRequest.swift
//  
//
//  Created by Julio César Fernández Muñoz on 26/7/23.
//

import Foundation

/**
 Enumeración que representa los principales métodos HTTP utilizados en las solicitudes web.
 */
public enum HTTPMethods: String {
    
    /// Método utilizado para solicitar datos de un recurso. No debe ser utilizado para operaciones que causen efectos secundarios.
    case get = "GET"
    
    /// Método utilizado para enviar datos para ser procesados a un recurso. Es comúnmente utilizado cuando se envía información de formularios.
    case post = "POST"
    
    /// Método utilizado para actualizar un recurso existente o crearlo si no existe.
    case put = "PUT"
    
    /// Método utilizado para aplicar modificaciones parciales a un recurso.
    case patch = "PATCH"
    
    /// Método utilizado para eliminar un recurso especificado.
    case delete = "DELETE"
}

/**
 Enumeración que representa los principales métodos de autorización utilizados en las cabeceras HTTP de las solicitudes web.
 */
public enum AuthorizationMethod: String {
    
    /// Método de autorización que utiliza un token, comúnmente asociado con la autenticación JWT (JSON Web Token).
    case token = "Bearer"
    
    /// Método de autorización que utiliza credenciales codificadas en base64, típicamente "username:password".
    case basic = "Basic"
}

/**
 Estructura que representa un error devuelto por el servidor Vapor.

 Vapor utiliza esta estructura para enviar respuestas de error en formato JSON, incluyendo un indicador de error y la razón del mismo.
 */
struct VaporError: Codable {
    
    /// Indicador que muestra si la respuesta es un error. Si es `true`, significa que la respuesta contiene un error.
    let error: Bool
    
    /// Descripción detallada del error proporcionada por el servidor.
    let reason: String
}

public extension URLRequest {
    /**
     Crea y devuelve una solicitud `URLRequest` con el método HTTP GET.
     
     - Parameters:
        - url: El `URL` al que se realizará la solicitud GET.
        - token: Token opcional para la autorización. Si se proporciona, se añadirá al encabezado de la solicitud.
        - authMethod: Método de autorización a utilizar. Por defecto es `.token`.
     
     - Returns: Una solicitud `URLRequest` configurada con el método GET y los encabezados correspondientes.
     
     ### Ejemplo de uso:
     ```swift
     let url = URL(string: "https://api.example.com/data")!
     let request = URLRequest.get(url: url, token: "YOUR_TOKEN_HERE")
     ```
     */
    static func get(url:URL, token:String? = nil, authMethod:AuthorizationMethod = .token) -> URLRequest {
        var request = URLRequest(url: url)
        if let token {
            request.setValue("\(authMethod.rawValue) \(token)",
                             forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = HTTPMethods.get.rawValue
        request.timeoutInterval = 30
        request.setValue("application/json",
                         forHTTPHeaderField: "Accept")
        return request
    }
    
    /**
     Crea y devuelve una solicitud `URLRequest` con el método HTTP especificado, comúnmente POST, y un cuerpo JSON.
     
     - Parameters:
        - url: El `URL` al que se realizará la solicitud.
        - data: Datos `JSON` que se enviarán en el cuerpo de la solicitud.
        - method: Método HTTP a utilizar. Por defecto es `.post`.
        - token: Token opcional para la autorización. Si se proporciona, se añadirá al encabezado de la solicitud.
        - authMethod: Método de autorización a utilizar. Por defecto es `.token`.
        - encoder: Instancia del `encoder` que puede ser sobrecargada para cambiar cualquier configuración.
     
     - Returns: Una solicitud `URLRequest` configurada con el método HTTP especificado, los encabezados correspondientes y el cuerpo JSON.
     
     ### Ejemplo de uso:
     ```swift
     struct UserData: Codable {
     let name: String
     let age: Int
     }
     
     let url = URL(string: "https://api.example.com/user")!
     let userData = UserData(name: "John", age: 30)
     let request = URLRequest.post(url: url, data: userData, token: "YOUR_TOKEN_HERE")
     ```
     */
    static func post<JSON:Codable>(url: URL, data: JSON, method: HTTPMethods = .post,
                                   token: String? = nil, authMethod: AuthorizationMethod = .token,
                                   encoder: JSONEncoder = JSONEncoder()) -> URLRequest {
        var request = URLRequest(url: url)
        if let token {
            request.setValue("\(authMethod.rawValue) \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = method.rawValue
        request.timeoutInterval = 30
        request.setValue("application/json; charset=utf8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try? encoder.encode(data)
        return request
    }
}

