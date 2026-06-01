import 'package:projeto_dispositivos_moveis/core/database/app_database.dart';

import '../models/cliente.dart';

class ClienteDAO {
  static const String table = 'cliente';

  Future<int> insertCliente(Cliente cliente) async {
    final db = await AppDatabase().database;

    return await db.insert(table, cliente.toMap());
  }

  Future<int> updateCliente(Cliente cliente) async {
    final db = await AppDatabase().database;

    return await db.update(
      table,
      cliente.toMap(),
      where: 'id = ?',
      whereArgs: [cliente.id],
    );
  }

  Future<int> deleteCliente(int id) async {
    final db = await AppDatabase().database;

    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Cliente>> findAllClientes() async {
    final db = await AppDatabase().database;

    final result = await db.query(table, orderBy: 'nome ASC');

    return result.map((e) => Cliente.fromMap(e)).toList();
  }
}
