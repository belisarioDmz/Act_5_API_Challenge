import SwiftUI

//Pantalla de detalle: muestra la info completa de UN personaje.
//Recibe el Character que la lista le pasa al tocar una fila
//(no hace otra llamada a la API; usa el objeto que ya tiene).
struct CharacterDetailView: View {

    //El personaje a mostrar. Se lo pasa la lista al navegar hasta aquí.
    let character: Character

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                //Imagen grande arriba.
                //AsyncImage descarga la foto; mientras llega, un spinner.
                AsyncImage(url: URL(string: character.image)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                        .frame(height: 240)
                        .frame(maxWidth: .infinity)
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))

                //Nombre del personaje.
                Text(character.name)
                    .font(.largeTitle)
                    .bold()

                //Filas de datos: cada una es una etiqueta + su valor.
                infoRow(titulo: "Estado", valor: character.status)
                infoRow(titulo: "Especie", valor: character.species)
                infoRow(titulo: "Género", valor: character.gender)
            }
            .padding()
        }
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    //Pequeña ayuda para no repetir el mismo HStack en cada dato.
    //Muestra el título en negrita a la izquierda y el valor a la derecha.
    private func infoRow(titulo: String, valor: String) -> some View {
        HStack {
            Text(titulo)
                .font(.headline)
            Spacer()
            Text(valor)
                .foregroundStyle(.secondary)
        }
    }
}

//El preview necesita un Character de ejemplo para dibujar la pantalla
//sin tener que llamar a la API. Lo envolvemos en NavigationStack para
//ver también el título de arriba.
#Preview {
    NavigationStack {
        CharacterDetailView(
            character: Character(
                id: 1,
                name: "Rick Sanchez",
                status: "Alive",
                species: "Human",
                gender: "Male",
                image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"
            )
        )
    }
}
