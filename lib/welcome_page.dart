import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'cliente_page.dart';
import 'produto_service.dart';
import 'usuario_service.dart';
import 'pedido_service.dart';

class WelcomePage extends StatelessWidget {
  final ProdutoService produtoService;
  final UsuarioService usuarioService;
  final PedidoService pedidoService;

  const WelcomePage({
    super.key,
    required this.produtoService,
    required this.usuarioService,
    required this.pedidoService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',//logotipo na pagina de boas-vindas
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 20),
              Text(
                'Cokylicius', 
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Visite o nosso cardápio',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
                ),
              ),
              const SizedBox(height: 40),
              // Se o aplicativo for aberto na web, permitimos acesso ao cardápio
              // mas também oferecemos um botão para login de administrador
              if (kIsWeb) ...[
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ClientePage(
                          produtoService: produtoService,
                          pedidoService: pedidoService,
                        ),
                      ),
                    );
                  },
                  child: const Text('Ver cardápio'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LoginPage(
                          produtoService: produtoService,
                          usuarioService: usuarioService,
                          pedidoService: pedidoService,
                        ),
                      ),
                    );
                  },
                  child: const Text('Login de administrador'),
                ),
              ] else ...[
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LoginPage(
                          produtoService: produtoService,
                          usuarioService: usuarioService,
                          pedidoService: pedidoService,
                        ),
                      ),
                    );
                  },
                  child: const Text('Entrar'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CadastroUsuarioPage(
                          produtoService: produtoService,
                          usuarioService: usuarioService,
                          pedidoService: pedidoService,
                        ),
                      ),
                    );
                  },
                  child: const Text('Criar conta'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
