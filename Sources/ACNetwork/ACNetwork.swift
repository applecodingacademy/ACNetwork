//
//  ACNetwork.swift
//  
//
//  Created by Julio César Fernández Muñoz on 26/7/23.
//

import SwiftUI

/**
 Clase principal de la **interfaz de red** para la librería `ACNetwork`.
 
 Esta clase sirve para invocar las distintas funciones que nos permitirán utilizar la interfaz de red de una manera más productiva.
 */
public final class ACNetwork {
    
    /// Variable de tipo *singleton* que almacena la clase persistida de `ACNetwork`.
    public static let shared = ACNetwork()
    
    /// Función `getJSON` que recuperará cualquier `JSON` de manera genérica usando el protocolo `Codable`.
    ///
    ///  La llamada a la función `getJSON` nos devolverá el resultado de forma genérica para cualquier tipo de elemento `JSON` que se quiera recuperar. Por ejemplo, si queremos recuperar el *array* de `Empleados` solo hay que hacer una llamada como esta:
    ///  ```swift
    ///     getJSON(request: req, type: [Empleados].self)
    ///  ```
    ///
    ///  - Parameters:
    ///     - request: Ttipo `URLRequest` utilizado para la petición.
    ///     - type: Tipo del `JSON` que vamos a devolver.
    ///     - decoder: Instancia del `decoder` que puede ser sobrecargada para cambiar cualquier configuración.
    ///
    ///  - Returns: El tipo genérico del `JSON` en el tipo `type` que será decodificado.
    ///  - Throws: El tipo ``NetworkError`` que nos informará del error que haya podido darse en la llamada. Si estamos usando un servidor de *Vapor* podremos acceder al tipo de error específico para saber cómo recuperarlo aquí: ``NetworkError/vapor(_:_:)``.
    public func getJSON<JSON:Codable>(request:URLRequest,
                                      type:JSON.Type,
                                      decoder:JSONDecoder = JSONDecoder()) async throws -> JSON {
        let (data, response) = try await URLSession.shared.dataRequest(for: request)
        guard let response = response as? HTTPURLResponse else { throw NetworkError.noHTTP }
        if response.statusCode == 200 {
            do {
                return try decoder.decode(JSON.self, from: data)
            } catch {
                throw NetworkError.json(error)
            }
        } else {
            throw NetworkError.status(response.statusCode)
        }
    }
    
    /// Función `getJSONV` que recupera cualquier `JSON` de manera genérica usando el protocolo `Codable`.
    ///
    /// Esta función está diseñada específicamente para trabajar con respuestas `HTTPURLResponse` proporcionadas por el servidor de Swift, Vapor. Vapor compone un JSON si hubo un error (código `Bool`) y una razón (error como `String` enviado por el servidor).
    ///
    /// - Parameters:
    ///     - request: Tipo `URLRequest` utilizado para la petición.
    ///     - type: Tipo del `JSON` que vamos a devolver.
    ///     - decoder: Instancia del `decoder` que puede ser sobrecargada para cambiar cualquier configuración.
    ///     - statusOK: Código de estado HTTP que se considera exitoso. Por defecto es 200.
    ///
    /// - Returns: El tipo genérico del `JSON` en el tipo `type` que será decodificado.
    /// - Throws: El tipo ``NetworkError`` que nos informará del error que haya podido darse en la llamada.
    public func getJSONV<JSON:Codable>(request:URLRequest, type:JSON.Type,
                                       decoder:JSONDecoder = JSONDecoder(),
                                       statusOK:Int = 200) async throws -> JSON {
        let (data, response) = try await URLSession.shared.dataRequest(for: request)
        guard let response = response as? HTTPURLResponse else { throw NetworkError.noHTTP }
        if response.statusCode == statusOK {
            do {
                return try decoder.decode(JSON.self, from: data)
            } catch {
                throw NetworkError.json(error)
            }
        } else {
            throw NetworkError.vapor(try JSONDecoder().decode(VaporError.self, from: data).reason, response.statusCode)
        }
    }
    
    /// Función `post` que realiza una solicitud POST.
    ///
    /// - Parameters:
    ///     - request: Tipo `URLRequest` utilizado para la petición.
    ///     - statusOK: Código de estado HTTP que se considera exitoso. Por defecto es 200.
    ///
    /// - Throws: El tipo ``NetworkError`` que nos informará del error que haya podido darse en la llamada.
    public func post(request:URLRequest, statusOK:Int = 200) async throws {
        let (_, response) = try await URLSession.shared.dataRequest(for: request)
        guard let response = response as? HTTPURLResponse else { throw NetworkError.noHTTP }
        if response.statusCode != statusOK {
            throw NetworkError.status(response.statusCode)
        }
    }
    
    /// Función `postV` que realiza una solicitud POST y está diseñada para trabajar con respuestas `HTTPURLResponse` proporcionadas por Vapor.
    ///
    /// - Parameters:
    ///     - request: Tipo `URLRequest` utilizado para la petición.
    ///     - statusOK: Código de estado HTTP que se considera exitoso. Por defecto es 200.
    ///
    /// - Throws: El tipo ``NetworkError`` que nos informará del error que haya podido darse en la llamada.       
    public func postV(request:URLRequest, statusOK:Int = 200) async throws {
        let (data, response) = try await URLSession.shared.dataRequest(for: request)
        guard let response = response as? HTTPURLResponse else { throw NetworkError.noHTTP }
        if response.statusCode != statusOK {
            throw NetworkError.vapor(try JSONDecoder().decode(VaporError.self, from: data).reason, response.statusCode)
        }
    }
    
    #if os(iOS)
    /// Función `getImage` que recupera una imagen desde una URL.
    ///
    /// - Parameter url: URL desde donde se recuperará la imagen.
    ///
    /// - Returns: Una imagen de tipo `UIImage`.
    /// - Throws: El tipo ``NetworkError`` que nos informará del error que haya podido darse en la llamada.
    public func getImage(url:URL) async throws -> UIImage {
        let (data, response) = try await URLSession.shared.dataRequest(from: url)
        guard let response = response as? HTTPURLResponse else { throw NetworkError.noHTTP }
        if response.statusCode == 200 {
            if let image = UIImage(data: data) {
                return image
            } else {
                throw NetworkError.dataNotValid
            }
        } else {
            throw NetworkError.status(response.statusCode)
        }
    }
    #endif
}
