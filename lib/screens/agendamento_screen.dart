import 'package:flutter/material.dart';

import '../core/dao/agendamento_dao.dart';
import '../core/dao/cliente_dao.dart';
import '../core/dao/funcionario_dao.dart';
import '../core/dao/servico_dao.dart';

import '../core/models/agendamento.dart';
import '../core/models/cliente.dart';
import '../core/models/funcionario.dart';
import '../core/models/servico.dart';

class AgendamentoScreen extends StatefulWidget {
  const AgendamentoScreen({super.key});

  @override
  State<AgendamentoScreen> createState() => _AgendamentoScreenState();
}

class _AgendamentoScreenState extends State<AgendamentoScreen> {
  final _formKey = GlobalKey<FormState>();

  final AgendamentoDAO _agendamentoDAO = AgendamentoDAO();

  final ClienteDAO _clienteDAO = ClienteDAO();

  final FuncionarioDAO _funcionarioDAO = FuncionarioDAO();

  final ServicoDAO _servicoDAO = ServicoDAO();

  List<Agendamento> agendamentos = [];

  List<Cliente> clientes = [];
  List<Funcionario> funcionarios = [];
  List<Servico> servicos = [];

  Cliente? clienteSelecionado;
  Funcionario? funcionarioSelecionado;
  Servico? servicoSelecionado;

  DateTime dataSelecionada = DateTime.now();

  String status = "Agendado";

  Agendamento? agendamentoEditando;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> confirmarExclusao(Agendamento agendamento) async {
    final confirmar = await showDialog<bool>(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),

          content: Text(
            'Deseja realmente excluir o agendamento de ${getNomeCliente(agendamento.clienteId)}?',
          ),

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
      await excluirAgendamento(agendamento.id!);
    }
  }

  Future<void> finalizarAgendamento(Agendamento agendamento) async {
    final atualizado = Agendamento(
      id: agendamento.id,
      data: agendamento.data,
      status: 'Finalizado',
      clienteId: agendamento.clienteId,
      funcionarioId: agendamento.funcionarioId,
      servicoId: agendamento.servicoId,
    );

    await _agendamentoDAO.updateAgendamento(atualizado);

    await carregarDados();
  }

  Future<void> carregarDados() async {
    clientes = await _clienteDAO.findAllClientes();

    funcionarios = await _funcionarioDAO.findAllFuncionarios();

    servicos = await _servicoDAO.findAllServicos();

    agendamentos = await _agendamentoDAO.findAllAgendamentos();

    setState(() {});
  }

  Future<void> selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: dataSelecionada,
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );

    if (data != null) {
      setState(() {
        dataSelecionada = data;
      });
    }
  }

  Future<void> salvarAgendamento() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (clienteSelecionado == null ||
        funcionarioSelecionado == null ||
        servicoSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione cliente, funcionário e serviço'),
        ),
      );

      return;
    }

    final agendamento = Agendamento(
      id: agendamentoEditando?.id,
      data: dataSelecionada.toIso8601String(),
      status: status,
      clienteId: clienteSelecionado!.id!,
      funcionarioId: funcionarioSelecionado!.id!,
      servicoId: servicoSelecionado!.id!,
    );

    if (agendamentoEditando == null) {
      await _agendamentoDAO.insertAgendamento(agendamento);
    } else {
      await _agendamentoDAO.updateAgendamento(agendamento);
    }

    limparFormulario();

    await carregarDados();
  }

  Future<void> excluirAgendamento(int id) async {
    await _agendamentoDAO.deleteAgendamento(id);

    await carregarDados();
  }

  void editarAgendamento(Agendamento agendamento) {
    clienteSelecionado = clientes.firstWhere(
      (c) => c.id == agendamento.clienteId,
    );

    funcionarioSelecionado = funcionarios.firstWhere(
      (f) => f.id == agendamento.funcionarioId,
    );

    servicoSelecionado = servicos.firstWhere(
      (s) => s.id == agendamento.servicoId,
    );

    dataSelecionada = DateTime.parse(agendamento.data);

    status = agendamento.status;

    agendamentoEditando = agendamento;

    setState(() {});
  }

  void limparFormulario() {
    clienteSelecionado = null;
    funcionarioSelecionado = null;
    servicoSelecionado = null;

    dataSelecionada = DateTime.now();

    status = "Agendado";

    agendamentoEditando = null;

    setState(() {});
  }

  String getNomeCliente(int clienteId) {
    return clientes.firstWhere((c) => c.id == clienteId).nome;
  }

  String getNomeFuncionario(int funcionarioId) {
    return funcionarios.firstWhere((f) => f.id == funcionarioId).nome;
  }

  String getNomeServico(int servicoId) {
    return servicos.firstWhere((s) => s.id == servicoId).descricao;
  }

  double getValorServico(int servicoId) {
    return servicos.firstWhere((s) => s.id == servicoId).valor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agendamentos')),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            Form(
              key: _formKey,

              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      "${dataSelecionada.day}/${dataSelecionada.month}/${dataSelecionada.year}",
                    ),

                    trailing: IconButton(
                      icon: const Icon(Icons.calendar_month),
                      onPressed: selecionarData,
                    ),
                  ),

                  DropdownButtonFormField<Cliente>(
                    value: clienteSelecionado,

                    decoration: const InputDecoration(labelText: 'Cliente'),

                    items: clientes
                        .map(
                          (c) =>
                              DropdownMenuItem(value: c, child: Text(c.nome)),
                        )
                        .toList(),

                    onChanged: (value) {
                      setState(() {
                        clienteSelecionado = value;
                      });
                    },
                  ),

                  DropdownButtonFormField<Funcionario>(
                    value: funcionarioSelecionado,

                    decoration: const InputDecoration(labelText: 'Funcionário'),

                    items: funcionarios
                        .map(
                          (f) =>
                              DropdownMenuItem(value: f, child: Text(f.nome)),
                        )
                        .toList(),

                    onChanged: (value) {
                      setState(() {
                        funcionarioSelecionado = value;
                      });
                    },
                  ),

                  DropdownButtonFormField<Servico>(
                    value: servicoSelecionado,

                    decoration: const InputDecoration(labelText: 'Serviço'),

                    items: servicos
                        .map(
                          (s) => DropdownMenuItem(
                            value: s,
                            child: Text(s.descricao),
                          ),
                        )
                        .toList(),

                    onChanged: (value) {
                      setState(() {
                        servicoSelecionado = value;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: salvarAgendamento,

                    child: Text(
                      agendamentoEditando == null ? 'Salvar' : 'Atualizar',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: agendamentos.length,

                itemBuilder: (context, index) {
                  final a = agendamentos[index];

                  return Card(
                    child: ExpansionTile(
                      title: Text(getNomeCliente(a.clienteId)),

                      subtitle: Text(a.data.split('T').first),

                      children: [
                        ListTile(
                          title: Text(
                            'Funcionário: ${getNomeFuncionario(a.funcionarioId)}',
                          ),
                        ),

                        ListTile(
                          title: Text(
                            'Serviço: ${getNomeServico(a.servicoId)}',
                          ),
                        ),

                        ListTile(
                          title: Text(
                            'Valor: R\$ ${getValorServico(a.servicoId).toStringAsFixed(2)}',
                          ),
                        ),

                        ListTile(
                          title: Text(
                            'Status: ${a.status}',
                            style: TextStyle(
                              color: a.status == 'Finalizado'
                                  ? Colors.green
                                  : Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                            children: [
                              ElevatedButton.icon(
                                onPressed: a.status == 'Finalizado'
                                    ? null
                                    : () {
                                        editarAgendamento(a);
                                      },

                                icon: const Icon(Icons.edit),

                                label: const Text('Editar'),
                              ),

                              ElevatedButton.icon(
                                onPressed:
                                    a.status == 'Finalizado' ||
                                        agendamentoEditando?.id == a.id
                                    ? null
                                    : () {
                                        finalizarAgendamento(a);
                                      },

                                icon: const Icon(Icons.check_circle),

                                label: const Text('Finalizar'),
                              ),

                              ElevatedButton.icon(
                                onPressed: agendamentoEditando?.id == a.id
                                    ? null
                                    : () {
                                        confirmarExclusao(a);
                                      },

                                icon: const Icon(Icons.delete),

                                label: const Text('Excluir'),
                              ),
                            ],
                          ),
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
