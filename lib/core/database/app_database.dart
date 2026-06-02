import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase _instance =
  AppDatabase._internal();

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
    final path = join(
      await getDatabasesPath(),
      'agendamento.db',
    );

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

        // Funcionários

        await db.insert('funcionario', {
          'nome': 'Administrador',
          'email': 'admin@admin.com',
          'senha': '123',
        });

        await db.insert('funcionario', {
          'nome': 'João Silva',
          'email': 'joao@empresa.com',
          'senha': '123',
        });

        await db.insert('funcionario', {
          'nome': 'Maria Oliveira',
          'email': 'maria@empresa.com',
          'senha': '123',
        });

        // Clientes

        await db.insert('cliente', {
          'nome': 'Pedro Almeida',
          'cpf': '123.456.789-00',
          'telefone': '(55) 99999-1111',
        });

        await db.insert('cliente', {
          'nome': 'Ana Costa',
          'cpf': '987.654.321-00',
          'telefone': '(55) 99999-2222',
        });

        await db.insert('cliente', {
          'nome': 'Lucas Ferreira',
          'cpf': '111.222.333-44',
          'telefone': '(55) 99999-3333',
        });

        // Serviços

        await db.insert('servico', {
          'descricao': 'Troca de Óleo',
          'valor': 120.00,
        });

        await db.insert('servico', {
          'descricao': 'Alinhamento',
          'valor': 80.00,
        });

        await db.insert('servico', {
          'descricao': 'Balanceamento',
          'valor': 60.00,
        });

        await db.insert('servico', {
          'descricao': 'Revisão Completa',
          'valor': 350.00,
        });

        // Agendamentos

        await db.insert('agendamento', {
          'data': '2026-06-15',
          'status': 'Agendado',
          'cliente_id': 1,
          'funcionario_id': 1,
          'servico_id': 1,
        });

        await db.insert('agendamento', {
          'data': '2026-06-16',
          'status': 'Agendado',
          'cliente_id': 2,
          'funcionario_id': 2,
          'servico_id': 4,
        });

        await db.insert('agendamento', {
          'data': '2026-06-17',
          'status': 'Finalizado',
          'cliente_id': 3,
          'funcionario_id': 3,
          'servico_id': 2,
        });
      },
    );
  }
}
