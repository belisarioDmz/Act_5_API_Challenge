import Foundation

//Errores posibles al hablar con la API, cada uno con su mensaje legible.
//Conformar LocalizedError hace que error.localizedDescription devuelva
//el texto de errorDescription, así el mensaje vive junto al error.
enum ServiceError: LocalizedError {
    case sinConexion            //falló la red (sin internet, timeout...)
    case servidor(codigo: Int)  //el servidor respondió con un status != 200
    case datosInvalidos         //la respuesta no se pudo decodificar

    var errorDescription: String? {
        switch self {
        case .sinConexion:
            return "No hay conexión. Revisa tu internet e intenta de nuevo."
        case .servidor(let codigo):
            return "Error del servidor (código \(codigo)). Intenta más tarde."
        case .datosInvalidos:
            return "No se pudieron leer los datos recibidos."
        }
    }
}

struct RickAndMortyService {

    //Función que trae la LISTA de personajes de la API.

    //"async" -> es asíncrona porque pedir datos por internet toma tiempo
    //y no queremos congelar la app mientras esperamos.

    //"throws" -> puede fallar (URL mala, sin internet, etc.),
    //y en vez de resolverlo aquí, "lanza" el error hacia arriba.

    //"[Character]" -> si todo sale bien, devuelve un arreglo de personajes.

    func fetchCharacters() async throws -> [Character] {

        //1. Crear el objeto URL
        //URL(string:) puede devolver nil si el texto no es una URL válida,
        //por eso usamos guard let: si falla, lanzamos un error y cortamos.
        //Endpoint oficial de la Rick and Morty API.
        guard let url = URL(string: "https://rickandmortyapi.com/api/character") else {
            throw URLError(.badURL)
        }

        //2. Crear el URLRequest
        let urlRequest = URLRequest(url: url)

        //3. Hacer la llamada a la API.
        //Si la red falla (sin internet, timeout...), URLSession lanza un error;
        //lo atrapamos y lo convertimos en nuestro error claro .sinConexion.
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await URLSession.shared.data(for: urlRequest)
        } catch {
            throw ServiceError.sinConexion
        }

        //4. Verificar que el servidor respondió correctamente.
        //El código 200 significa "OK". Si es otro (ej. 404, 500), lanzamos
        //.servidor con el código real para poder mostrárselo al usuario.
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
        guard statusCode == 200 else {
            throw ServiceError.servidor(codigo: statusCode)
        }

        //5. Decodificar el JSON a nuestro contenedor y devolver la lista.
        //La API envuelve los personajes dentro de "results", por eso
        //decodificamos a CharacterResponse y luego sacamos .results.
        //Si el decode falla, lanzamos .datosInvalidos en vez de reventar.
        do {
            let respuesta = try JSONDecoder().decode(CharacterResponse.self, from: data)
            return respuesta.results
        } catch {
            throw ServiceError.datosInvalidos
        }
    }
}
