import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../core/dao/agendamento_dao.dart';
import '../core/dao/cliente_dao.dart';
import '../core/models/cliente.dart';

class ClienteScreen extends StatefulWidget {
  const ClienteScreen({super.key});

  @override
  State<ClienteScreen> createState() => _ClienteScreenState();
}

class _ClienteScreenState extends State<ClienteScreen> {
  final _formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();

  final cpfController = TextEditingController();

  final telefoneController = TextEditingController();

  final ClienteDAO _clienteDAO = ClienteDAO();

  final AgendamentoDAO _agendamentoDAO = AgendamentoDAO();

  final cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final telefoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  List<Cliente> clientes = [];

  Cliente? clienteEditando;

  @override
  void initState() {
    super.initState();
    carregarClientes();
  }

  Future<bool> clientePossuiAgendamento(int clienteId) async {
    final agendamentos = await _agendamentoDAO.findAllAgendamentos();

    return agendamentos.any((a) => a.clienteId == clienteId);
  }

  Future<void> carregarClientes() async {
    final lista = await _clienteDAO.findAllClientes();

    setState(() {
      clientes = lista;
    });
  }

  Future<void> salvarCliente() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (clienteEditando == null) {
      await _clienteDAO.insertCliente(
        Cliente(
          nome: nomeController.text,
          cpf: cpfController.text,
          telefone: telefoneController.text,
        ),
      );
    } else {
      await _clienteDAO.updateCliente(
        Cliente(
          id: clienteEditando!.id,
          nome: nomeController.text,
          cpf: cpfController.text,
          telefone: telefoneController.text,
        ),
      );
    }

    limparCampos();

    await carregarClientes();
  }

  void editarCliente(Cliente cliente) {
    setState(() {
      clienteEditando = cliente;

      nomeController.text = cliente.nome;

      cpfController.text = cliente.cpf;

      telefoneController.text = cliente.telefone ?? '';
    });
  }

  Future<void> excluirCliente(int id) async {
    final possuiAgendamento = await clientePossuiAgendamento(id);

    if (possuiAgendamento) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não é possível excluir um cliente que possui agendamentos.',
          ),
        ),
      );

      return;
    }

    if (clienteEditando?.id == id) {
      limparCampos();
    }

    await _clienteDAO.deleteCliente(id);

    await carregarClientes();
  }

  Future<void> confirmarExclusao(Cliente cliente) async {
    final confirmar = await showDialog<bool>(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),

          content: Text('Deseja realmente excluir ${cliente.nome}?'),

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
      await excluirCliente(cliente.id!);
    }
  }

  void limparCampos() {
    nomeController.clear();
    cpfController.clear();
    telefoneController.clear();

    clienteEditando = null;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clientes')),


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
                    controller: cpfController,

                    inputFormatters: [cpfMask],

                    keyboardType: TextInputType.number,

                    decoration: const InputDecoration(labelText: 'CPF'),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o CPF';
                      }

                      return null;
                    },
                  ),

                  TextFormField(
                    controller: telefoneController,

                    inputFormatters: [telefoneMask],

                    keyboardType: TextInputType.phone,

                    decoration: const InputDecoration(labelText: 'Telefone'),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: salvarCliente,

                          child: Text(
                            clienteEditando == null ? 'Salvar' : 'Atualizar',
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: ElevatedButton(
                          onPressed: limparCampos,

                          child: Text(
                            clienteEditando == null
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
                itemCount: clientes.length,

                itemBuilder: (context, index) {
                  final cliente = clientes[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),

                    child: ExpansionTile(
                      title: Text(
                        cliente.nome,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      childrenPadding: const EdgeInsets.all(16),

                      children: [
                        Row(
                          children: [
                            const Text(
                              'CPF: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),

                            Text(cliente.cpf),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            const Text(
                              'Telefone: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),

                            Text(cliente.telefone ?? '-'),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,

                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                editarCliente(cliente);
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
                                confirmarExclusao(cliente);
                              },

                              icon: const Icon(Icons.delete),
                              label: const Text('Excluir'),
                            )
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
