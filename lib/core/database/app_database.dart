import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();

  static Database? _db;

  factory AppDatabase() => _instance;

  AppDatabase._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;

    _db = await _initDatabase();

    print('Database opened!');

    return _db!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'agendamento.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE cliente(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            cpf TEXT NOT NULL,
            telefone TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE funcionario(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            email TEXT NOT NULL,
            senha TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE servico(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            descricao TEXT NOT NULL,
            valor REAL NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE agendamento(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            data TEXT NOT NULL,
            status TEXT NOT NULL,
            cliente_id INTEGER NOT NULL,
            funcionario_id INTEGER NOT NULL,
            servico_id INTEGER NOT NULL
          )
        ''');

        // Funcionario padrao para login
        await db.insert('funcionario', {
          'nome': 'adm',
          'email': 'admin@admin.com',
          'senha': '123',
        });
      },
    );
  }
}
