import 'package:flutter/material.dart';
import 'home_page.dart';
import 'produto_service.dart';
import 'usuario_service.dart';
import 'pedido_service.dart';
import 'constants.dart';

class LoginPage extends StatefulWidget {
  final ProdutoService produtoService;
  final UsuarioService usuarioService;
  final PedidoService pedidoService;

  const LoginPage({
    super.key,
    required this.produtoService,
    required this.usuarioService,
    required this.pedidoService,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  void _login() {
    if (_emailController.text.isEmpty || _senhaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final email = _emailController.text.trim();
    final senha = _senhaController.text;

    final bool isAdmin = email == 'admin@empresa.com' && senha == 'admin123';
    final usuario = isAdmin
        ? null
        : widget.usuarioService.autenticar(email, senha);

    if (!isAdmin && usuario == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email ou senha incorretos!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(
          isAdmin: isAdmin,
          produtoService: widget.produtoService,
          usuarioService: widget.usuarioService,
          pedidoService: widget.pedidoService,
          usuario: usuario,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CokyLicius',
          textAlign: TextAlign.center,
          style: kTitleTextStyle,
        ),
        elevation: kAppBarElevation,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(kPaddingLarge),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 540),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/logo.png', //logotipo na pagina de boas-vindas
                    width: kLogoWidth,
                    height: kLogoHeight,
                  ),
                  Text('Entrar', style: kSubtitleTextStyle),

                  TextField(
                    controller: _emailController,
                    decoration: kTextFieldDecoration('Email'),
                  ),
                  const SizedBox(height: kSpacingMedium),
                  TextField(
                    controller: _senhaController,
                    decoration: kTextFieldDecoration('Senha'),
                    obscureText: true,
                  ),
                  const SizedBox(height: kSpacingExtraLarge),
                  ElevatedButton(
                    onPressed: _login,
                    child: const Text('Entrar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
