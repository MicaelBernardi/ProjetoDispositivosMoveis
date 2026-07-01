import 'package:flutter/material.dart';

import '../core/authentication/auth_service.dart';
import 'agendamento_screen.dart';
import 'cliente_screen.dart';
import 'funcionario_screen.dart';
import 'login_screen.dart';
import 'servico_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema de Agendamentos'),

        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(Icons.logout),

            onPressed: () async {
              final sair = await showDialog<bool>(
                context: context,

                builder: (context) {
                  return AlertDialog(
                    title: const Text('Sair'),

                    content: const Text('Deseja encerrar a sessão?'),

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

                        child: const Text('Sair'),
                      ),
                    ],
                  );
                },
              );

              if (sair == true) {
                await AuthService().logout();

                if (!context.mounted) return;

                Navigator.pushAndRemoveUntil(
                  context,

                  MaterialPageRoute(builder: (_) => LoginScreen()),

                  (route) => false,
                );
              }
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: ListView(
          children: [
            _menuCard(
              context,
              icon: Icons.fact_check,
              titulo: 'Lista de agendamentos',
              descricao: 'Consulte e crie novos agendamentos',
              tela: const AgendamentoScreen(),
            ),

            const SizedBox(height: 15),

            _menuCard(
              context,
              icon: Icons.person_add_alt_1,
              titulo: 'Cadastro de clientes',
              descricao: 'Adicione e gerencie os dados dos clientes',
              tela: const ClienteScreen(),
            ),

            const SizedBox(height: 15),

            _menuCard(
              context,
              icon: Icons.build,
              titulo: 'Serviços oferecidos',
              descricao: 'Configure os tipos de serviços disponíveis',
              tela: const ServicoScreen(),
            ),

            const SizedBox(height: 15),

            _menuCard(
              context,
              icon: Icons.groups,
              titulo: 'Cadastro de funcionários',
              descricao: 'Inclua e edite responsáveis pelos agendamentos',
              tela: const FuncionarioScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuCard(
    BuildContext context, {
    required IconData icon,
    required String titulo,
    required String descricao,
    required Widget tela,
  }) {
    return Card(
      elevation: 4,

      color: Colors.blue.shade200,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

      child: InkWell(
        borderRadius: BorderRadius.circular(8),

        splashColor: Colors.white24,
        highlightColor: Colors.white10,

        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => tela));
        },

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Row(
            children: [
              Icon(icon, size: 55, color: Colors.white),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      titulo,

                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(descricao, style: const TextStyle(fontSize: 15)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
