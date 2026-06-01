import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/dao/agendamento_dao.dart';
import '../core/dao/servico_dao.dart';
import '../core/models/servico.dart';

class ServicoScreen extends StatefulWidget {
  const ServicoScreen({super.key});

  @override
  State<ServicoScreen> createState() => _ServicoScreenState();
}

class _ServicoScreenState extends State<ServicoScreen> {
  final _formKey = GlobalKey<FormState>();

  final descricaoController = TextEditingController();

  final valorController = TextEditingController();

  final ServicoDAO _servicoDAO = ServicoDAO();

  final AgendamentoDAO _agendamentoDAO = AgendamentoDAO();

  List<Servico> servicos = [];

  Servico? servicoEditando;

  @override
  void initState() {
    super.initState();
    carregarServicos();
  }

  Future<bool> servicoPossuiAgendamento(int servicoId) async {
    final agendamentos = await _agendamentoDAO.findAllAgendamentos();

    return agendamentos.any((a) => a.servicoId == servicoId);
  }

  Future<void> carregarServicos() async {
    final lista = await _servicoDAO.findAllServicos();

    setState(() {
      servicos = lista;
    });
  }

  double converterValor() {
    return double.parse(valorController.text.replaceAll(',', '.'));
  }

  Future<void> salvarServico() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (servicoEditando == null) {
      await _servicoDAO.insertServico(
        Servico(descricao: descricaoController.text, valor: converterValor()),
      );
    } else {
      await _servicoDAO.updateServico(
        Servico(
          id: servicoEditando!.id,
          descricao: descricaoController.text,
          valor: converterValor(),
        ),
      );
    }

    limparCampos();

    await carregarServicos();
  }

  void editarServico(Servico servico) {
    setState(() {
      servicoEditando = servico;

      descricaoController.text = servico.descricao;

      valorController.text = servico.valor
          .toStringAsFixed(2)
          .replaceAll('.', ',');
    });
  }

  Future<void> excluirServico(int id) async {
    final agendamentos = await _agendamentoDAO.findAllAgendamentos();

    final possuiAgendamento = agendamentos.any((a) => a.servicoId == id);

    if (possuiAgendamento) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não é possível excluir um serviço que possui agendamentos.',
          ),
        ),
      );

      return;
    }

    if (servicoEditando?.id == id) {
      limparCampos();
    }

    await _servicoDAO.deleteServico(id);

    await carregarServicos();
  }

  Future<void> confirmarExclusao(Servico servico) async {
    final confirmar = await showDialog<bool>(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),

          content: Text('Deseja realmente excluir "${servico.descricao}"?'),

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
      await excluirServico(servico.id!);
    }
  }

  void limparCampos() {
    descricaoController.clear();
    valorController.clear();

    servicoEditando = null;

    setState(() {});
  }

  @override
  void dispose() {
    descricaoController.dispose();
    valorController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Serviços')),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            Form(
              key: _formKey,

              child: Column(
                children: [
                  TextFormField(
                    controller: descricaoController,

                    decoration: const InputDecoration(labelText: 'Descrição'),

                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Informe a descrição';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 10),

                  TextFormField(
                    controller: valorController,

                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),

                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                    ],

                    decoration: const InputDecoration(
                      labelText: 'Valor',
                      prefixText: 'R\$ ',
                    ),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o valor';
                      }

                      try {
                        double.parse(value.replaceAll(',', '.'));
                      } catch (_) {
                        return 'Valor inválido';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: salvarServico,

                          child: Text(
                            servicoEditando == null ? 'Salvar' : 'Atualizar',
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: ElevatedButton(
                          onPressed: limparCampos,

                          child: Text(
                            servicoEditando == null
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
                itemCount: servicos.length,

                itemBuilder: (context, index) {
                  final servico = servicos[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),

                    child: ExpansionTile(
                      title: Text(
                        servico.descricao,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      childrenPadding: const EdgeInsets.all(16),

                      children: [
                        Row(
                          children: [
                            const Text(
                              'Valor: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),

                            Text(
                              'R\$ ${servico.valor.toStringAsFixed(2).replaceAll('.', ',')}',
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,

                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                editarServico(servico);
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
                                confirmarExclusao(servico);
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
