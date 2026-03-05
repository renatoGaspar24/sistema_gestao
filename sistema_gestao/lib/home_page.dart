import 'package:flutter/material.dart';
import 'admin_page.dart';
import 'cliente_page.dart';
import 'produto_service.dart';
import 'usuario_service.dart';
import 'pedido_service.dart';

class HomePage extends StatelessWidget {
  final bool isAdmin;
  final ProdutoService produtoService;
  final UsuarioService usuarioService;
  final PedidoService pedidoService;
  const HomePage({
    super.key,
    required this.isAdmin,
    required this.produtoService,
    required this.usuarioService,
    required this.pedidoService,
  });

  @override
  Widget build(BuildContext context) {
    return isAdmin
        ? AdminPage(
            produtoService: produtoService,
            usuarioService: usuarioService,
            pedidoService: pedidoService,
          )
        : ClientePage(
            produtoService: produtoService,
            pedidoService: pedidoService,
          );
  }
}
