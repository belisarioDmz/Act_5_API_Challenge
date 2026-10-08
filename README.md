# Rick and Morty — API Challenge

Mini app en SwiftUI para practicar el consumo de una API REST. Muestra una
lista de personajes de la serie Rick and Morty y, al tocar uno, abre una
pantalla de detalle con más información. Construida con el patrón **MVVM**.

## Qué hace la app

- Al abrir, hace una petición **GET** y carga una lista de personajes.
- Cada fila muestra la **imagen** y el **nombre** del personaje.
- Al tocar una fila, navega a una **vista de detalle** con imagen grande,
  nombre, estado (Alive / Dead / unknown), especie y género.
- Muestra un **indicador de carga** (`ProgressView`) mientras llega la respuesta.
- Maneja errores de forma robusta: si no hay conexión o la API falla,
  muestra un mensaje legible y **la app no se cae**.

## API que consume

- **API:** [Rick and Morty API](https://rickandmortyapi.com/) — pública y gratuita, no requiere API key.
- **Endpoint usado (GET):** <https://rickandmortyapi.com/api/character>
- **Documentación:** <https://rickandmortyapi.com/documentation>

La respuesta envuelve los personajes dentro de un campo `results`, que es lo
que la app decodifica para construir la lista.

## Arquitectura (MVVM)

| Capa | Archivo | Responsabilidad |
|------|---------|-----------------|
| **Model** | `Character.swift` | `Character` y `CharacterResponse` (modelos `Decodable`). |
| **Service** | `RickAndMortyService.swift` | Hace el GET con `URLSession` y decodifica el JSON. Define `ServiceError`. |
| **ViewModel** | `CharacterViewModel.swift` | Estado observable (`characters`, `isLoading`, `errorMessage`) y la lógica de carga. |
| **View** | `ContentView.swift` | Lista de personajes + estados de carga/error. |
| **View** | `CharacterRowView.swift` | Celda de la lista (imagen + nombre). |
| **View** | `CharacterDetailView.swift` | Pantalla de detalle de un personaje. |

Flujo: `ContentView` observa al `CharacterViewModel`, que pide los datos al
`RickAndMortyService`, que los decodifica a los modelos. La vista reacciona a
los cambios de estado del ViewModel.

## Manejo de errores

El `ServiceError` distingue tres casos y cada uno muestra un mensaje legible:

- **Sin conexión:** "No hay conexión. Revisa tu internet e intenta de nuevo."
- **Error del servidor:** "Error del servidor (código XXX). Intenta más tarde." (incluye el status HTTP real).
- **Datos inválidos:** "No se pudieron leer los datos recibidos."

Todos los fallos se atrapan con `do/catch`, por lo que la app nunca termina de forma abrupta.

## Cómo correr la app

**Requisitos**
- **Xcode:** 27
- **Target de iOS:** 17 o superior
- Conexión a internet (la app consume una API en línea)

**Pasos**
1. Clonar el repositorio:
   ```bash
   git clone https://github.com/belisarioDmz/Act_5_API_Challenge.git
   ```
2. Abrir `API_Challenge.xcodeproj` en Xcode.
3. Seleccionar un simulador de iPhone (iOS 17+) o un dispositivo físico.
4. Ejecutar con **Cmd + R**.

Al iniciar, la app carga automáticamente la lista de personajes. Toca
cualquiera para ver su detalle.
