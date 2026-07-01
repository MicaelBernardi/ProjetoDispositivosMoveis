import 'package:flutter/material.dart';

import '../core/models/funcionario.dart';
import '../core/services/agendamento_service.dart';
import '../core/services/funcionario_service.dart';

class FuncionarioScreen extends StatefulWidget {
  const FuncionarioScreen({super.key});

  @override
  State<FuncionarioScreen> createState() => _FuncionarioScreenState();
}

class _FuncionarioScreenState extends State<FuncionarioScreen> {
  final _formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();

  final emailController = TextEditingController();

  final senhaController = TextEditingController();

  final FuncionarioService _funcionarioService = FuncionarioService();

  final AgendamentoService _agendamentoService = AgendamentoService();

  List<Funcionario> funcionarios = [];

  Funcionario? funcionarioEditando;

  @override
  void initState() {
    super.initState();
    carregarFuncionarios();
  }

  Future<bool> funcionarioPossuiAgendamento(int funcionarioId) async {
    final agendamentos = await _agendamentoService.getAgendamentos();

    return agendamentos.any((a) => a.funcionario.id == funcionarioId);
  }

  Future<void> carregarFuncionarios() async {
    final lista = await _funcionarioService.getFuncionarios();

    setState(() {
      funcionarios = lista;
    });
  }

  Future<void> salvarFuncionario() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (funcionarioEditando == null) {
      await _funcionarioService.salvarFuncionario(
        Funcionario(
          nome: nomeController.text,
          email: emailController.text,
          senha: senhaController.text,
        ),
      );
    } else {
      await _funcionarioService.atualizarFuncionario(
        Funcionario(
          id: funcionarioEditando!.id,
          nome: nomeController.text,
          email: emailController.text,
          senha: senhaController.text,
        ),
      );
    }

    limparCampos();

    await carregarFuncionarios();
  }

  void editarFuncionario(Funcionario funcionario) {
    setState(() {
      funcionarioEditando = funcionario;

      nomeController.text = funcionario.nome;

      emailController.text = funcionario.email;

      senhaController.text = funcionario.senha;
    });
  }

  Future<void> excluirFuncionario(int id) async {
    final possuiAgendamento = await funcionarioPossuiAgendamento(id);

    if (possuiAgendamento) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não é possível excluir um funcionário que possui agendamentos.',
          ),
        ),
      );

      return;
    }

    if (funcionarioEditando?.id == id) {
      limparCampos();
    }

    await _funcionarioService.excluirFuncionario(id);

    await carregarFuncionarios();
  }

  Future<void> confirmarExclusao(Funcionario funcionario) async {
    final confirmar = await showDialog<bool>(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),

          content: Text('Deseja realmente excluir ${funcionario.nome}?'),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },

              child: const Text('Cancelar'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },

              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      await excluirFuncionario(funcionario.id!);
    }
  }

  void limparCampos() {
    nomeController.clear();
    emailController.clear();
    senhaController.clear();

    funcionarioEditando = null;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Funcionários')),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            Form(
              key: _formKey,

              child: Column(
                children: [
                  TextFormField(
                    controller: nomeController,

                    decoration: const InputDecoration(labelText: 'Nome'),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o nome';
                      }

                      return null;
                    },
                  ),

                  TextFormField(
                    controller: emailController,

                    keyboardType: TextInputType.emailAddress,

                    decoration: const InputDecoration(labelText: 'Email'),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o email';
                      }

                      return null;
                    },
                  ),

                  TextFormField(
                    controller: senhaController,

                    obscureText: true,

                    decoration: const InputDecoration(labelText: 'Senha'),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe a senha';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: salvarFuncionario,

                          child: Text(
                            funcionarioEditando == null
                                ? 'Salvar'
                                : 'Atualizar',
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: ElevatedButton(
                          onPressed: limparCampos,

                          child: Text(
                            funcionarioEditando == null
                                ? 'Limpar'
                                : 'Cancelar edição',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Divider(),

            Expanded(
              child: ListView.builder(
                itemCount: funcionarios.length,

                itemBuilder: (context, index) {
                  final funcionario = funcionarios[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),

                    child: ExpansionTile(
                      title: Text(
                        funcionario.nome,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      childrenPadding: const EdgeInsets.all(16),

                      children: [
                        Row(
                          children: [
                            const Text(
                              'Email: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),

                            Expanded(child: Text(funcionario.email)),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,

                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                editarFuncionario(funcionario);
                              },

                              icon: const Icon(Icons.edit),

                              label: const Text('Editar'),
                            ),

                            const SizedBox(width: 10),

                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),

                              onPressed: () {
                                confirmarExclusao(funcionario);
                              },

                              icon: const Icon(Icons.delete),
                              label: const Text('Excluir'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
