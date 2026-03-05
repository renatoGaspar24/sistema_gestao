// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sistema_gestao/main.dart';
import 'package:sistema_gestao/produto_service.dart';
import 'package:sistema_gestao/usuario_service.dart';
import 'package:sistema_gestao/pedido_service.dart';

void main() {
  setUpAll(() async {
    await Hive.initFlutter();
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final produtoService = ProdutoService();
    await produtoService.init();
    final usuarioService = UsuarioService();
    await usuarioService.init();
    final pedidoService = PedidoService(produtoService: produtoService);
    await pedidoService.init();
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MyApp(
        produtoService: produtoService,
        usuarioService: usuarioService,
        pedidoService: pedidoService,
      ),
    );

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
