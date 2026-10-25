import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Usuário',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const CadastroPage(),
    );
  }
}

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmaSenhaController = TextEditingController();

  bool _ocultarSenha = true;
  bool _ocultarConfirmaSenha = true;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _telefoneController.dispose();
    _senhaController.dispose();
    _confirmaSenhaController.dispose();
    super.dispose();
  }

  // ---------- Validadores ----------

  String? _validarNome(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe o nome completo';
    }
    return null;
  }

  String? _validarEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe o e-mail';
    }
    if (!value.contains('@')) {
      return 'O e-mail deve conter @';
    }
    // Validação mais robusta (desafio extra)
    final regex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,}$');
    if (!regex.hasMatch(value.trim())) {
      return 'Informe um e-mail válido';
    }
    return null;
  }

  String? _validarCpf(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe o CPF';
    }
    if (value.length != 11) {
      return 'O CPF deve ter 11 dígitos';
    }
    return null;
  }

  String? _validarTelefone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe o telefone';
    }
    if (value.length < 10) {
      return 'Telefone inválido (mín. 10 dígitos com DDD)';
    }
    return null;
  }

  String? _validarSenha(String? value) {
    if (value == null || value.isEmpty) {
      return 'Informe a senha';
    }
    if (value.length < 6) {
      return 'A senha deve ter no mínimo 6 caracteres';
    }
    return null;
  }

  String? _validarConfirmaSenha(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirme a senha';
    }
    if (value != _senhaController.text) {
      return 'As senhas não coincidem';
    }
    return null;
  }

  // ---------- Ação do botão ----------

  void _cadastrar() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cadastro realizado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Desafio extra: SnackBar de erro
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Corrija os campos inválidos.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Usuário')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Nome
              TextFormField(
                controller: _nomeController,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Nome completo',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: _validarNome,
              ),
              const SizedBox(height: 16),

              // E-mail
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: _validarEmail,
              ),
              const SizedBox(height: 16),

              // CPF
              TextFormField(
                controller: _cpfController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                decoration: const InputDecoration(
                  labelText: 'CPF',
                  hintText: 'Somente números',
                  prefixIcon: Icon(Icons.badge),
                  border: OutlineInputBorder(),
                ),
                validator: _validarCpf,
              ),
              const SizedBox(height: 16),

              // Telefone
              TextFormField(
                controller: _telefoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                  hintText: 'DDD + número',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                validator: _validarTelefone,
              ),
              const SizedBox(height: 16),

              // Senha
              TextFormField(
                controller: _senhaController,
                obscureText: _ocultarSenha,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_ocultarSenha
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () =>
                        setState(() => _ocultarSenha = !_ocultarSenha),
                  ),
                ),
                validator: _validarSenha,
              ),
              const SizedBox(height: 16),

              // Confirmação de senha (desafio extra)
              TextFormField(
                controller: _confirmaSenhaController,
                obscureText: _ocultarConfirmaSenha,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: 'Confirmar senha',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_ocultarConfirmaSenha
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () => setState(
                        () => _ocultarConfirmaSenha = !_ocultarConfirmaSenha),
                  ),
                ),
                validator: _validarConfirmaSenha,
              ),
              const SizedBox(height: 24),

              // Botão
              ElevatedButton(
                onPressed: _cadastrar,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('CADASTRAR'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}