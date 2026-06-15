import 'package:mongo_dart/mongo_dart.dart';

import '../models/videojuego.dart';

class MongoDatabase {
  static const String mongoUrl =
      'mongodb+srv://usuario2026a:usuario2026a@cluster0.xzffuex.mongodb.net/clase_flutter?retryWrites=true&w=majority';

  static const String collectionName = 'videojuegos';

  static late Db db;
  static late DbCollection collection;

  static Future<void> connect() async {
    db = await Db.create(mongoUrl);
    await db.open();
    collection = db.collection(collectionName);
  }

  static Future<List<Videojuego>> getVideojuegos() async {
    final List<Map<String, dynamic>> data = await collection.find().toList();

    return data.map((item) {
      return Videojuego.fromMap(item);
    }).toList();
  }

  static Future<void> insertVideojuego(Videojuego videojuego) async {
    await collection.insertOne(videojuego.toMap());
  }

  static Future<void> updateVideojuego(Videojuego videojuego) async {
    await collection.updateOne(
      where.eq('id', videojuego.id),
      modify
          .set('titulo', videojuego.titulo)
          .set('plataforma', videojuego.plataforma)
          .set('precio', videojuego.precio)
          .set('stock', videojuego.stock)
          .set('imagen', videojuego.imagen)
          .set('descripcion', videojuego.descripcion),
    );
  }

  static Future<void> deleteVideojuego(String id) async {
    await collection.deleteOne(
      where.eq('id', id),
    );
  }
}