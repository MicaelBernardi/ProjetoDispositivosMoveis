class Funcionario {
  final int? id;
  final String nome;
  final String email;
  final String senha;

  Funcionario({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome, 'email': email, 'senha': senha};
  }

  factory Funcionario.fromMap(Map<String, dynamic> map) {
    return Funcionario(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      senha: map['senha'] ?? '',
    );
  }
}
