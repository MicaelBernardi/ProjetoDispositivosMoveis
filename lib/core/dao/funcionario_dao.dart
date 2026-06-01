import 'package:projeto_dispositivos_moveis/core/database/app_database.dart';

import '../models/funcionario.dart';

class FuncionarioDAO {
  static const String table = 'funcionario';

  Future<int> insertFuncionario(Funcionario funcionario) async {
    final db = await AppDatabase().database;

    return await db.insert(table, funcionario.toMap());
  }

  Future<Funcionario?> getFuncionario(String email, String senha) async {
    final db = await AppDatabase().database;

    final result = await db.query(
      table,
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
    );

    return result.isNotEmpty ? Funcionario.fromMap(result.first) : null;
  }

  Future<int> updateFuncionario(Funcionario funcionario) async {
    final db = await AppDatabase().database;

    return await db.update(
      table,
      funcionario.toMap(),
      where: 'id = ?',
      whereArgs: [funcionario.id],
    );
  }

  Future<int> deleteFuncionario(int id) async {
    final db = await AppDatabase().database;

    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Funcionario>> findAllFuncionarios() async {
    final db = await AppDatabase().database;

    final result = await db.query(table, orderBy: 'nome ASC');

    return result.map((e) => Funcionario.fromMap(e)).toList();
  }
}
