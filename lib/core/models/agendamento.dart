class Agendamento {
  final int? id;
  final String data;
  final String status;

  final int clienteId;
  final int funcionarioId;
  final int servicoId;

  Agendamento({
    this.id,
    required this.data,
    required this.status,
    required this.clienteId,
    required this.funcionarioId,
    required this.servicoId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data': data,
      'status': status,
      'cliente_id': clienteId,
      'funcionario_id': funcionarioId,
      'servico_id': servicoId,
    };
  }

  factory Agendamento.fromMap(Map<String, dynamic> map) {
    return Agendamento(
      id: map['id'],
      data: map['data'],
      status: map['status'],
      clienteId: map['cliente_id'],
      funcionarioId: map['funcionario_id'],
      servicoId: map['servico_id'],
    );
  }
}
