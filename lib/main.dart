import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'welcome_page.dart';
import 'produto_service.dart';
import 'usuario_service.dart';
import 'pedido_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final produtoService = ProdutoService();
  await produtoService.init();
  final usuarioService = UsuarioService();
  await usuarioService.init();
  final pedidoService = PedidoService(produtoService: produtoService);
  await pedidoService.init();
  runApp(
    MyApp(
      produtoService: produtoService,
      usuarioService: usuarioService,
      pedidoService: pedidoService,
    ),
  );
}

class MyApp extends StatelessWidget {
  final ProdutoService produtoService;
  final UsuarioService usuarioService;
  final PedidoService pedidoService;

  const MyApp({
    super.key,
    required this.produtoService,
    required this.usuarioService,
    required this.pedidoService,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sistema de Gestão',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.purple,
        brightness: Brightness.dark,
      ),
      home: WelcomePage(
        produtoService: produtoService,
        usuarioService: usuarioService,
        pedidoService: pedidoService,
      ),
    );
  }
}
                  