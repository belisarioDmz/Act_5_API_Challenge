import Foundation

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
        guard let url = URL(string: "https://rickandmortyapi.com/api/character") else {
            throw URLError(.badURL)
        }

        //2. Crear el URLRequest
        let urlRequest = URLRequest(url: url)

        //3. Hacer la llamada a la API
        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        //4. Verificar que el servidor respondió correctamente
        //El código 200 significa "OK". Si algo salió mal, el código será
        //otro (ej. 404) y lanzamos un error en vez de intentar decodificar
        //una respuesta inválida.
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        //5. Decodificar el JSON a nuestro contenedor y devolver la lista.
        //La API envuelve los personajes dentro de "results", por eso
        //decodificamos a CharacterResponse y luego sacamos .results.
        let respuesta = try JSONDecoder().decode(CharacterResponse.self, from: data)
        return respuesta.results
    }
}
