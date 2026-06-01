import 'package:projeto_dispositivos_moveis/core/database/app_database.dart';

import '../models/agendamento.dart';

class AgendamentoDAO {
  static const String table = 'agendamento';

  Future<int> insertAgendamento(Agendamento agendamento) async {
    final db = await AppDatabase().database;

    return await db.insert(table, agendamento.toMap());
  }

  Future<int> updateAgendamento(Agendamento agendamento) async {
    final db = await AppDatabase().database;

    return await db.update(
      table,
      agendamento.toMap(),
      where: 'id = ?',
      whereArgs: [agendamento.id],
    );
  }

  Future<int> deleteAgendamento(int id) async {
    final db = await AppDatabase().database;

    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Agendamento>> findAllAgendamentos() async {
    final db = await AppDatabase().database;

    final result = await db.query(table, orderBy: 'data ASC');

    return result.map((e) => Agendamento.fromMap(e)).toList();
  }
}
