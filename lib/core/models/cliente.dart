class Cliente {
  final int? id;
  final String nome;
  final String cpf;
  final String? telefone;

  Cliente({this.id, required this.nome, required this.cpf, this.telefone});

  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome, 'cpf': cpf, 'telefone': telefone};
  }

  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      id: map['id'],
      nome: map['nome'],
      cpf: map['cpf'],
      telefone: map['telefone'],
    );
  }
}
