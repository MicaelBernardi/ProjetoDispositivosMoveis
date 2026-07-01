import 'cliente.dart';
import 'funcionario.dart';
import 'servico.dart';

class Agendamento {
  final int? id;

  final String data;

  final String status;

  final Cliente cliente;

  final Funcionario funcionario;

  final Servico servico;

  Agendamento({
    this.id,

    required this.data,

    required this.status,

    required this.cliente,

    required this.funcionario,

    required this.servico,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,

      "data": data,

      "status": status,

      "cliente": cliente.toMap(),

      "funcionario": funcionario.toMap(),

      "servico": servico.toMap(),
    };
  }

  factory Agendamento.fromMap(Map<String, dynamic> map) {
    return Agendamento(
      id: map["id"],

      data: map["data"],

      status: map["status"],

      cliente: Cliente.fromMap(map["cliente"]),

      funcionario: Funcionario.fromMap(map["funcionario"]),

      servico: Servico.fromMap(map["servico"]),
    );
  }
}
