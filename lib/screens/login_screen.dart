import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../utils/app_cores.dart';
import 'home_screen.dart';
import 'registro_screen.dart';

/// Tela de login. Usa um Form com validação dos campos.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // chave do formulário, usada para validar os campos
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _senhaVisivel = false;

  @override
  void dispose() {
    // sempre limpar os controllers para não vazar memória
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    // valida o formulário; se algo estiver errado, para por aqui
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final resultado = await auth.login(
      _emailController.text,
      _senhaController.text,
    );

    if (!mounted) return;

    if (resultado.sucesso) {
      // vai para a tela principal e remove o login da pilha
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      // mostra o erro em um SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resultado.mensagemErro ?? 'Erro ao entrar'),
          backgroundColor: AppCores.erro,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final carregando = context.watch<AuthProvider>().carregando;

    return Scaffold(
      body: SafeArea(
        child: Center(
          // SingleChildScrollView evita erro de "overflow" quando o teclado abre
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              // largura máxima deixa o layout bonito em tablets também (responsivo)
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.play_circle_fill,
                        size: 72, color: AppCores.primaria),
                    const SizedBox(height: 16),
                    const Text(
                      'CursoStream',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Entre para continuar aprendendo',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppCores.textoSuave),
                    ),
                    const SizedBox(height: 32),

                    // Campo de e-mail
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

                    // Campo de senha
                    TextFormField(
                      controller: _senhaController,
                      obscureText: !_senhaVisivel,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_senhaVisivel
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() => _senhaVisivel = !_senhaVisivel);
                          },
                        ),
                      ),
                      validator: (valor) {
                        if (valor == null || valor.isEmpty) {
                          return 'Informe a senha';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Botão entrar (mostra spinner enquanto carrega)
                    ElevatedButton(
                      onPressed: carregando ? null : _entrar,
                      child: carregando
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Entrar'),
                    ),
                    const SizedBox(height: 16),

                    // Link para a tela de cadastro
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const RegistroScreen()),
                        );
                      },
                      child: const Text('Não tem conta? Cadastre-se'),
                    ),

                    const SizedBox(height: 8),
                    // dica com a conta de demonstração
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppCores.card,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Conta de teste:\nprofessor@cursostream.com\nSenha: 123456',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppCores.textoSuave, fontSize: 12),
                      ),
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
