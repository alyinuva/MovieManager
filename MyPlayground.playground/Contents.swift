import UIKit
import Foundation

struct Person: Codable {
    // Una estructura que será usada para almacenar data y luego convertirla en JSON usando encode.
    let name: String
    let age: Int
    
    // Si en caso el JSON tiene keys que no se conforman con el estilo swift, como por ejemplo Nombres o nombres_asi, entonces creamos un enum de CodingKeys
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case age = "Age"
    }
}

// Simplemente creamos una instancia
let alfredo = Person(name: "Alfredo", age: 25)

// Creamos un encode object
let enconder = JSONEncoder()

// Finalmente hacemos el encode (similar al decode)
let json = try! enconder.encode(alfredo) // Es este JSON el cual enviaremos al HTTP Body


// Minitarea

// 1. Crearé una clase para ocuparme del API
class JSONPlaceholder {
    
    enum Endpoints {
        static let baseURL = "https://jsonplaceholder.typicode.com"
        static let point = "/posts"
        
        case post
        
        var stringValue: String {
            switch self {
            case .post:
                return Endpoints.baseURL + Endpoints.point
            }
    }
        var url: URL {
            switch self {
            case .post:
                return URL(string: Endpoints.post.stringValue)!
            }
        }
    }
}

// 2. Crearemos un struct para encargarnos de la data que enviaremos al API
struct requestBody: Codable {
    let userId: Int
    let title: String
    let body: String
}

// 3. Crearé una instancia de requestBody
let ejemploData = requestBody(userId: 1, title: "Titulo", body: "But my bodyyyy, my bodyyyy")

// 4. Encapsularé lo resto en una función
func postRequest() {
    
    var request = URLRequest(url: JSONPlaceholder.Endpoints.post.url)

    request.httpMethod = "POST"
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type") // definimos el formato de la data que mandaremos. Por cierto, podríamos haber definido esto después de request.httpBody; el resultado sería el mismo.
    
    let encoder = JSONEncoder()
    let dataFromrequestBody = try! encoder.encode(ejemploData)

    request.httpBody = dataFromrequestBody
            
    // continuamos con lo de siempre
    let task = URLSession.shared.dataTask(with: request) {data, response, error in
        guard let data = data else {
            print("error", error!)
            return
        }
        print(String(data: data, encoding: .utf8))
    }
    task.resume()
}

postRequest()


