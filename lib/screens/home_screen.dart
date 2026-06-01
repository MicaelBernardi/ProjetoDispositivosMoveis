import 'package:flutter/material.dart';
import 'package:projeto_dispositivos_moveis/screens/agendamento_screen.dart';
import 'package:projeto_dispositivos_moveis/screens/funcionario_screen.dart';
import 'package:projeto_dispositivos_moveis/screens/servico_screen.dart';

import 'cliente_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema de Agendamento'),
        backgroundColor: Colors.blue,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ClienteScreen()),
                );
              },
              child: const Text('Clientes'),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FuncionarioScreen()),
                );
              },
              child: const Text('Funcionários'),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ServicoScreen()),
                );
              },
              child: const Text('Serviços'),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AgendamentoScreen()),
                );
              },
              child: const Text('Agendamentos'),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Sair'),
            ),
          ],
        ),
      ),
    );
  }
}
