import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../utils/app_cores.dart';
import 'home_screen.dart';

/// Tela de cadastro de novo usuário.
class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _ehInstrutor = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthController>();
    final resultado = await auth.registrar(
      nome: _nomeController.text,
      email: _emailController.text,
      senha: _senhaController.text,
      ehInstrutor: _ehInstrutor,
    );

    if (!mounted) return;

    if (resultado.sucesso) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (rota) => false, // remove todas as telas anteriores
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resultado.mensagemErro ?? 'Erro ao cadastrar'),
          backgroundColor: AppCores.erro,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final carregando = context.watch<AuthController>().carregando;

    return Scaffold(
      appBar: AppBar(title: const Text('Criar conta')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nomeController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Nome completo',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (valor) {
                        if (valor == null || valor.trim().isEmpty) {
                          return 'Informe seu nome';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (valor) {
                        if (valor == null || valor.trim().isEmpty) {
                          return 'Informe o e-mail';
                        }
                        if (!valor.contains('@')) {
                          return 'E-mail inválido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _senhaController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      validator: (valor) {
                        if (valor == null || valor.length < 4) {
                          return 'A senha deve ter pelo menos 4 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),

                    // Opção de se cadastrar como instrutor
                    SwitchListTile(
                      value: _ehInstrutor,
                      onChanged: (valor) => setState(() => _ehInstrutor = valor),
                      title: const Text('Quero publicar cursos (instrutor)'),
                      subtitle: const Text(
                        'Você poderá vender seus próprios cursos',
                        style: TextStyle(color: AppCores.textoSuave, fontSize: 12),
                      ),
                      activeThumbColor: AppCores.primaria,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: carregando ? null : _cadastrar,
                      child: carregando
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Cadastrar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
