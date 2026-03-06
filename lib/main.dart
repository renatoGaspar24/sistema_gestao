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
      title: 'Cokylicious',
      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 141, 38, 29),
          primary: const Color(0xFFF9BC15),
          secondary: const Color.fromARGB(255, 175, 58, 44),
          surface: const Color.fromARGB(255, 163, 39, 28),
          brightness: Brightness.dark,
        ),

        scaffoldBackgroundColor: const Color.fromARGB(255, 141, 28, 17),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF9BC15),
            foregroundColor: Colors.black,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      home: WelcomePage(
        produtoService: produtoService,
        usuarioService: usuarioService,
        pedidoService: pedidoService,
      ),
    );
  }
}
