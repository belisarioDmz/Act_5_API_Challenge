import SwiftUI


struct ContentView: View {

    //El ViewModel que tiene el estado y habla con el Service.
    //Como es @Observable, se guarda con @State y SwiftUI se encarga
    //de redibujar la vista cuando cambian sus propiedades.
    @State private var viewModel = CharacterViewModel()

    var body: some View {
        //NavigationStack permite navegar de la lista al detalle.
        NavigationStack {

            //Mostramos una cosa u otra según el estado del ViewModel.
            if viewModel.isLoading {
                //Mientras carga: spinner centrado.
                ProgressView("Cargando personajes...")

            } else if let error = viewModel.errorMessage {
                //Si hubo error: mensaje para el usuario.
                ContentUnavailableView(
                    "Algo salió mal",
                    systemImage: "exclamationmark.triangle",
                    description: Text(error)
                )

            } else {
                //Si todo salió bien: la lista de personajes.
                List(viewModel.characters) { character in
                    //Cada fila lleva al detalle de ese personaje.
                    //Le pasamos el Character completo (sin otra llamada).
                    NavigationLink(destination: CharacterDetailView(character: character)) {
                        CharacterRowView(character: character)
                    }
                }
            }
        }
        //.task se ejecuta una vez cuando la vista aparece.
        //Aquí pedimos la lista de personajes al abrir la app.
        .task {
            await viewModel.cargarPersonajes()
        }
    }
}

#Preview {
    ContentView()
}
