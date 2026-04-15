import 'package:flutter/material.dart';
import 'admin_page.dart';
import 'perfil_page.dart';
import 'models/usuario.dart';
import 'produto_service.dart';
import 'usuario_service.dart';
import 'pedido_service.dart';

class HomePage extends StatelessWidget {
  final bool isAdmin;
  final Usuario? usuario;
  final ProdutoService produtoService;
  final UsuarioService usuarioService;
  final PedidoService pedidoService;

  const HomePage({
    super.key,
    required this.isAdmin,
    required this.usuario,
    required this.produtoService,
    required this.usuarioService,
    required this.pedidoService,
  }) : assert(
         isAdmin || usuario != null,
         'Usuario deve ser fornecido quando não for administrador.',
       );

  @override
  Widget build(BuildContext context) {
    return isAdmin
        ? AdminPage(
            produtoService: produtoService,
            usuarioService: usuarioService,
            pedidoService: pedidoService,
          )
        : PerfilPage(
            usuario: usuario!,
            produtoService: produtoService,
            usuarioService: usuarioService,
            pedidoService: pedidoService,
          );
  }
}
