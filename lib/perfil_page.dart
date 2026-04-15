import 'package:flutter/material.dart';
import 'models/pedido.dart';
import 'models/usuario.dart';
import 'pedido_service.dart';
import 'produto_service.dart';
import 'usuario_service.dart';
import 'cliente_page.dart';
import 'welcome_page.dart';
import 'constants.dart';

class PerfilPage extends StatefulWidget {
  final Usuario usuario;
  final ProdutoService produtoService;
  final UsuarioService usuarioService;
  final PedidoService pedidoService;

  const PerfilPage({
    super.key,
    required this.usuario,
    required this.produtoService,
    required this.usuarioService,
    required this.pedidoService,
  });

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  bool _mostrarPendentes = false;
  bool _mostrarHistorico = false;

  String _formatarData(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    final ano = data.year;
    final hora = data.hour.toString().padLeft(2, '0');
    final minuto = data.minute.toString().padLeft(2, '0');
    return '$dia/$mes/$ano $hora:$minuto';
  }

  double _calcularTotalPedido(Pedido pedido) {
    return pedido.itens.fold(
      0.0,
      (soma, item) => soma + item.produto.preco * item.quantidade,
    );
  }

  Widget _buildPedidoTile(BuildContext context, Pedido pedido) {
    return Card(
      color: kSurfaceColor,
      margin: const EdgeInsets.symmetric(vertical: kSpacingSmall),
      child: ExpansionTile(
        collapsedBackgroundColor: kSurfaceColor,
        backgroundColor: kSurfaceColor,
        title: Text(
          'Pedido de ${_formatarData(pedido.criadoEm)}',
          style: kBodyTextStyle,
        ),
        subtitle: Text(
          'Total: AOA ${_calcularTotalPedido(pedido).toStringAsFixed(2)} • ${pedido.entregue ? 'Entregue' : 'Pendente'}',
          style: const TextStyle(color: kSecondaryColor),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(kPaddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Endereço: ${pedido.endereco}', style: kBodyTextStyle),
                const SizedBox(height: kSpacingSmall),
                Text('Telefone: ${pedido.telefone}', style: kBodyTextStyle),
                const SizedBox(height: kSpacingSmall),
                Text('Itens:', style: kSubtitleTextStyle),
                const SizedBox(height: kSpacingSmall),
                ...pedido.itens.map(
                  (item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      '${item.quantidade}x ${item.produto.nome} — AOA ${item.produto.preco.toStringAsFixed(2)}',
                      style: kBodyTextStyle.copyWith(fontSize: kSmallFontSize),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pedidos = widget.pedidoService.getPedidosPorEmail(
      widget.usuario.email,
    );
    final pedidosPendentes = widget.pedidoService.getPedidosPendentesPorEmail(
      widget.usuario.email,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Olá, ${widget.usuario.nome}'),
        backgroundColor: kBackgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => WelcomePage(
                    produtoService: widget.produtoService,
                    usuarioService: widget.usuarioService,
                    pedidoService: widget.pedidoService,
                  ),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(kPaddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                width: 120,
                height: 120,
              ),
            ),
            const SizedBox(height: kSpacingLarge),
            Card(
              color: kSurfaceColor,
              child: Padding(
                padding: const EdgeInsets.all(kPaddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nome: ${widget.usuario.nome}', style: kBodyTextStyle),
                    const SizedBox(height: kSpacingSmall),
                    Text(
                      'Email: ${widget.usuario.email}',
                      style: kBodyTextStyle,
                    ),
                    const SizedBox(height: kSpacingSmall),
                    Text(
                      'Telefone: ${widget.usuario.telefone}',
                      style: kBodyTextStyle,
                    ),
                  ],
                ),
              ),
            ),
            /*const SizedBox(height: kSpacingLarge),
            if (!_mostrarPendentes && !_mostrarHistorico)
              Expanded(
                child: Center(
                  child: Text(
                    'Use os botões flutuantes abaixo para ver seus pedidos ou acessar o cardápio.',
                    style: kBodyTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),*/
            if (_mostrarPendentes) ...[
              Text('Pedidos Pendentes', style: kTitleTextStyle),
              Expanded(
                child: pedidosPendentes.isEmpty
                    ? const Center(child: Text('Sem pedidos pendentes'))
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: pedidosPendentes.length,
                        itemBuilder: (context, index) {
                          return _buildPedidoTile(
                            context,
                            pedidosPendentes[index],
                          );
                        },
                      ),
              ),
            ],
            if (_mostrarHistorico) ...[
              Text('Histórico de Compras', style: kTitleTextStyle),
              Expanded(
                child: pedidos.isEmpty
                    ? const Center(child: Text('Nenhuma compra registrada'))
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: pedidos.length,
                        itemBuilder: (context, index) {
                          return _buildPedidoTile(context, pedidos[index]);
                        },
                      ),
              ),
            ],
            const SizedBox(height: kSpacingLarge),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kPaddingSmall),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton.extended(
              heroTag: 'pendentes',
              label: Text(_mostrarPendentes ? 'Ocultar' : 'Pendentes'),
              icon: const Icon(Icons.pending_actions),
              onPressed: () {
                setState(() {
                  _mostrarPendentes = !_mostrarPendentes;
                  if (_mostrarPendentes) {
                    _mostrarHistorico = false;
                  }
                });
              },
              backgroundColor: kPrimaryColor,
            ),
            FloatingActionButton.extended(
              heroTag: 'cardapio',
              label: const Text('Cardápio'),
              icon: const Icon(Icons.menu_book),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ClientePage(
                      produtoService: widget.produtoService,
                      pedidoService: widget.pedidoService,
                      usuarioService: widget.usuarioService,
                      usuario: widget.usuario,
                    ),
                  ),
                );
              },
              backgroundColor: kPrimaryColor,
            ),
            FloatingActionButton.extended(
              heroTag: 'historico',
              label: Text(_mostrarHistorico ? 'Ocultar' : 'Histórico'),
              icon: const Icon(Icons.history),
              onPressed: () {
                setState(() {
                  _mostrarHistorico = !_mostrarHistorico;
                  if (_mostrarHistorico) {
                    _mostrarPendentes = false;
                  }
                });
              },
              backgroundColor: kPrimaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
