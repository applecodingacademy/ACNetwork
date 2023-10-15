import Foundation
import ACNetwork

// Recuperando el singleton de la instancia
let network = ACNetwork.shared

// URL de la API que devuelve el JSON de empleados
let url = URL(string: "https://api.example.com/empleados")!
