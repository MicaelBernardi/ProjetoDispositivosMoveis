import 'package:projeto_dispositivos_moveis/core/database/app_database.dart';

import '../models/servico.dart';

class ServicoDAO {
  static const String table = 'servico';

  Future<int> insertServico(Servico servico) async {
    final db = await AppDatabase().database;

    return await db.insert(table, servico.toMap());
  }

  Future<int> updateServico(Servico servico) async {
    final db = await AppDatabase().database;

    return await db.update(
      table,
      servico.toMap(),
      where: 'id = ?',
      whereArgs: [servico.id],
    );
  }

  Future<int> deleteServico(int id) async {
    final db = await AppDatabase().database;

    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Servico>> findAllServicos() async {
    final db = await AppDatabase().database;

    final result = await db.query(table, orderBy: 'descricao ASC');

    return result.map((e) => Servico.fromMap(e)).toList();
  }
}
