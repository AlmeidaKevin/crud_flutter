# 🎮 CRUD Videojuegos - Flutter

Aplicación móvil desarrollada en Flutter para gestionar un catálogo de videojuegos, conectada a una base de datos MongoDB Atlas.

## ✨ Funcionalidades

- Ver listado de videojuegos (más recientes primero)
- Agregar nuevos videojuegos
- Editar videojuegos existentes
- Eliminar videojuegos
- Ver detalle completo de cada videojuego

## 🛠️ Tecnologías

- [Flutter](https://flutter.dev/)
- [MongoDB Atlas](https://www.mongodb.com/atlas) con el paquete `mongo_dart`
- `uuid` para generación de IDs únicos


---
## 📸 Capturas de pantalla




<p align="center">[LA APLICACION MOVIL]</p>



<p align="center">

  <img width="45%" height="1600" alt="Crud_flutter_1" src="https://github.com/user-attachments/assets/9e08bb69-70e1-4b12-a6f0-11136a896934" />
  <img width="45%" height="1600" alt="Crud_flutter_2" src="https://github.com/user-attachments/assets/6a4212fb-fa28-4112-ab10-88c99b609bac" />
  <img width="45%" height="1600" alt="Crud_flutter_3" src="https://github.com/user-attachments/assets/69d181ad-35cf-4624-b6e5-66385bd3b0b1" />
  

</p>

<div align="center">


https://github.com/user-attachments/assets/3bbf6aba-e0d0-4df2-a6e1-262a75aab755



</div>

<p align="center">
  <a href="https://github.com/user-attachments/assets/3bbf6aba-e0d0-4df2-a6e1-262a75aab755">
    Ver demo
  </a>
</p>


---
## 🚀 Cómo ejecutar

1. Clona el repositorio:
   ```bash
   git clone https://github.com/AlmeidaKevin/crud_flutter.git
   ```

2. Instala las dependencias:
   ```bash
   flutter pub get
   ```

3. Ejecuta la app:
   ```bash
   flutter run
   ```

## 📁 Estructura del proyecto

```
lib/
├── db/
│   └── mongo_database.dart   # Conexión y operaciones con MongoDB
├── models/
│   └── videojuego.dart       # Modelo de datos
├── pages/
│   ├── home_page.dart        # Listado de videojuegos
│   ├── detail_page.dart      # Detalle del videojuego
│   └── form_page.dart        # Formulario agregar/editar
└── main.dart
```
