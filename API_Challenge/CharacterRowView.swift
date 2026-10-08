import SwiftUI

//Celda de la lista: una fila con la imagen pequeña del personaje,
//su nombre y su estado (Alive / Dead / unknown).
struct CharacterRowView: View {

    //El personaje que esta fila va a mostrar.
    //Se lo pasa la lista cuando crea cada celda.
    let character: Character

    var body: some View {
        HStack(spacing: 12) {

            //Imagen pequeña a la izquierda.
            //AsyncImage descarga la foto desde la URL por su cuenta.
            //Mientras llega, mostramos un ProgressView (spinner).
            AsyncImage(url: URL(string: character.image)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 56, height: 56)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            //Nombre y estado, uno debajo del otro.
            VStack(alignment: .leading, spacing: 4) {
                Text(character.name)
                    .font(.headline)
            }
        }
        .padding(.vertical, 4)
    }
}

//El preview necesita un Character de ejemplo para poder dibujar la fila
//sin tener que llamar a la API.
#Preview {
    CharacterRowView(
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
