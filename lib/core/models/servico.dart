class Servico {
  final int? id;
  final String descricao;
  final double valor;

  Servico({this.id, required this.descricao, required this.valor});

  Map<String, dynamic> toMap() {
    return {'id': id, 'descricao': descricao, 'valor': valor};
  }

  factory Servico.fromMap(Map<String, dynamic> map) {
    return Servico(
      id: map['id'],
      descricao: map['descricao'],
      valor: (map['valor'] as num).toDouble(),
    );
  }
}
