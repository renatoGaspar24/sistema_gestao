import 'package:flutter/material.dart';
import 'home_page.dart';
import 'produto_service.dart';
import 'usuario_service.dart';
import 'pedido_service.dart';
import 'models/usuario.dart';
import 'constants.dart';

class CadastroUsuarioPage extends StatefulWidget {
  final ProdutoService produtoService;
  final UsuarioService usuarioService;
  final PedidoService pedidoService;
  const CadastroUsuarioPage({
    super.key,
    required this.produtoService,
    required this.usuarioService,
    required this.pedidoService,
  });

  @override
  State<CadastroUsuarioPage> createState() => _CadastroUsuarioPageState();
}

class _CadastroUsuarioPageState extends State<CadastroUsuarioPage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();

  void _cadastrar() {
    if (_nomeController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _senhaController.text.isEmpty ||
        _telefoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (widget.usuarioService.emailExiste(_emailController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email já cadastrado!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final novo = Usuario(
      nome: _nomeController.text.trim(),
      cargo: 'Cliente',
      telefone: _telefoneController.text.trim(),
      email: _emailController.text.trim(),
      senha: _senhaController.text,
      turno: '',
      salario: 0,
      dataAdmissao: DateTime.now(),
    );
    widget.usuarioService.addUsuario(novo);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(
          isAdmin: false,
          produtoService: widget.produtoService,
          usuarioService: widget.usuarioService,
          pedidoService: widget.pedidoService,
          usuario: novo,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "CokyLicius",
          textAlign: TextAlign.center,
          style: kTitleTextStyle,
        ),
        elevation: kAppBarElevation,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(kPaddingLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/logo.png', //logotipo na pagina de boas-vindas
                width: kLogoWidth,
                height: kLogoHeight,
              ),
              Text('Criar conta', style: kSubtitleTextStyle),
              TextField(
                controller: _nomeController,
                decoration: kTextFieldDecoration("Nome"),
              ),
              const SizedBox(height: kSpacingLarge),
              TextField(
                controller: _emailController,
                decoration: kTextFieldDecoration("Email"),
              ),
              const SizedBox(height: kSpacingLarge),
              TextField(
                controller: _senhaController,
                obscureText: true,
                decoration: kTextFieldDecoration("Senha"),
              ),
              const SizedBox(height: kSpacingLarge),
              TextField(
                controller: _telefoneController,
                decoration: kTextFieldDecoration("Telefone"),
              ),
              const SizedBox(height: kSpacingExtraLarge),
              ElevatedButton(
                onPressed: _cadastrar,
                child: const Text("Cadastrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
