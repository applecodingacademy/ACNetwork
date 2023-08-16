# Primeros Pasos con ACNetwork

Guía de primeros pasos en las llamadas de red usando la clave ACNetwork.

@Metadata {
    @PageImage(purpose: icon,
               source: "iconACNetwork",
               alt: "Icono sobre red")
    @PageImage(purpose: card, source: "GettingStarted", alt: "Pasos para iniciar")
}

## ¿Qué se puede hacer con ACNetwork?

Con esta librería vamos a poder **realizar llamadas de red** de una manera más simple que permitirá que cualquier desarrollador se tenga que olvidar de los controles de errores que van asociados a esta funcionalidad. 

![Banner de trabajo de red](ACNetworkOverview.png)


### Ejemplo de uso de getJSON

Si queremos usar la función ``ACNetwork/getJSON(request:type:decoder:)`` entonces tendremos que proporcionar los valores apropiados de parámetros para conseguir su funcionamiento.

Dada una estructura de ejemplo de un dato de Empleado podríamos tener el siguiente `struct`.

```swift 
struct Empleado: Codable {
    let id: Int
    let nombre: String
    let puesto: String
}
```

Con este JSON `Empleado` ya disponible, la carga se haría de la siguiente manera:

```swift 
// Suponiendo que tienes una instancia de ACNetwork
let network = ACNetwork.shared

// URL de la API que devuelve el JSON de empleados
let url = URL(string: "https://api.example.com/empleados")!
let request = URLRequest(url: url)

// Llamada asincrónica usando Task
Task {
    do {
        let empleados: [Empleado] = try await network.getJSON(request: request, type: [Empleado].self)
        // Procesa la lista de empleados
        for empleado in empleados {
            print(empleado.nombre)
        }
    } catch {
        // Maneja el error
        print("Error al obtener los empleados: \(error)")
    }
}
```

De esta manera podemos llamar a la función y obtener la respuesta apropiada.
