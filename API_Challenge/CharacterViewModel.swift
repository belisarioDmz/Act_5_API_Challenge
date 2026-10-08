import Foundation

//@Observable -> hace que SwiftUI "observe" esta clase cuando cambia
//@MainActor -> garantiza que el estado se actualice en el hilo principal
//que es el de la interfaz, donde SwiftUI espera los cambios.

@Observable
@MainActor
class CharacterViewModel {

    //La lista de personajes cargados. Empieza vacía porque al inicio
    //todavía no hemos pedido nada a la API.
    var characters: [Character] = []

    //Bandera para saber si la petición está en curso.
    //La vista la usa para mostrar un spinner de "cargando".
    var isLoading = false

    //Mensaje de error para mostrarle al usuario. Opcional porque
    //normalmente no hay error (vale nil cuando todo va bien).
    var errorMessage: String?

    //El ViewModel usa el Service para hablar con la API.
    //'private' porque solo este ViewModel lo necesita.
    private let service = RickAndMortyService()


    //Trae la lista de personajes. Es 'async' porque por dentro espera la respuesta de la red.
    //Aquí los errores NO se lanzan hacia afuera, se atrapan con do/catch y se guardan en
    //'errorMessage' para que la vista los muestre.
    func cargarPersonajes() async {

        //Antes de empezar: prendemos la bandera "cargando" y limpiamos errores viejos.
        isLoading = true
        errorMessage = nil

        do {
            //Le pedimos al Service la lista de personajes.
            //'try await' porque la función del Service puede fallar y es async.
            //Si todo sale bien, guardamos el resultado en el estado.
            characters = try await service.fetchCharacters()
        } catch {
            //Si el Service lanzó un error (sin internet, respuesta inválida...) caemos aquí.
            //Guardamos un mensaje y vaciamos la lista para no mostrar datos viejos.
            errorMessage = "No se pudieron cargar los personajes. Revisa tu conexión e intenta de nuevo."
            characters = []
        }

        //Pase lo que pase (éxito o error), apagamos "cargando".
        isLoading = false
    }
}
