import Foundation
import ACNetwork

// Recuperando el singleton de la instancia
let network = ACNetwork.shared

// URL de la API que devuelve el JSON de empleados
let url = URL(string: "https://api.example.com/empleados")!

// Creamos la petición de red
let getRequest = URLRequest.get(url: url, token: "YOUR_TOKEN_HERE")

// Tenemos definidos unos datos
struct Empleado: Codable {
    let id: Int
    let nombre: String
    let puesto: String
}