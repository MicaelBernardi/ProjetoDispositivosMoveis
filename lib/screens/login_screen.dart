import 'package:flutter/material.dart';

import '../core/authentication/auth_service.dart';
import '../core/models/funcionario.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(title: const Text('Login'), backgroundColor: Colors.blue),

      body: SingleChildScrollView(
        child: Form(
          key: _formKey,

          child: Column(
            children: [
              const SizedBox(height: 60),

              const FlutterLogo(size: 150),

              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),

                child: TextFormField(
                  controller: emailController,

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '* Campo obrigatório';
                    }

                    return null;
                  },

                  decoration: InputDecoration(
                    labelText: 'Email',

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),

                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '* Campo obrigatório';
                    }

                    return null;
                  },

                  decoration: InputDecoration(
                    labelText: 'Senha',

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: 50,
                width: 250,

                child: ElevatedButton(
                  onPressed: () async {
                    bool valido = _formKey.currentState!.validate();

                    if (!valido) {
                      return;
                    }

                    final Funcionario? funcionario = await AuthService().login(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );

                    if (funcionario != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Email ou senha inválidos'),
                        ),
                      );
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),

                  child: const Text('Entrar', style: TextStyle(fontSize: 24)),
                ),
              ),

              const SizedBox(height: 40),

              const Text(
                'Sistema de Agendamento',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
