import 'package:flutter/material.dart';
import 'produto_service.dart';
import 'pedido_service.dart';
import 'models/pedido.dart';
import 'models/produto.dart';

class ClientePage extends StatefulWidget {
  final ProdutoService produtoService;
  final PedidoService pedidoService;

  const ClientePage({
    super.key,
    required this.produtoService,
    required this.pedidoService,
  });

  @override
  State<ClientePage> createState() => _ClientePageState();
}

class _ClientePageState extends State<ClientePage> {
  final List<ItemPedido> carrinho = [];

  @override
  Widget build(BuildContext context) {
    final produtos = widget.produtoService.getProdutos();

    return Scaffold(
      backgroundColor: const Color(0xFF8B1A10),
      appBar: AppBar(
        title: const Text('Cokylicious Menu'),
        backgroundColor: const Color(0xFF8B1A10),
      ),
      body: SafeArea(
        child: produtos.isEmpty
            ? const Center(
                child: Text(
                  'Nenhum produto disponível',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    ...produtos.map((p) => _buildProdutoCard(p)),
                    const SizedBox(height: 20),
                    if (carrinho.isNotEmpty)
                      ElevatedButton(
                        onPressed: _finalizarPedido,
                        child: Text('Finalizar Pedido (${carrinho.length})'),
                      ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildProdutoCard(Produto produto) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        // ignore: deprecated_member_use
        color: const Color(0xFFFFC107).withOpacity(0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ListTile(
          leading: produto.imagemPath.isNotEmpty
              ? Image.asset(produto.imagemPath, width: 50, height: 50, fit: BoxFit.cover)
              : const Icon(Icons.fastfood),
          title: Text(
            produto.nome,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('${produto.preco.toStringAsFixed(0)} ${produto.moeda}'),
          trailing: IconButton(
            icon: const Icon(Icons.add_shopping_cart),
            onPressed: () {
              setState(() {
                carrinho.add(ItemPedido(produto: produto, quantidade: 1));
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${produto.nome} adicionado ao carrinho')),
              );
            },
          ),
        ),
      ),
    );
  }

  void _finalizarPedido() async {
    if (carrinho.isEmpty) return;

    final pedido = Pedido(
      clienteNome: 'Cliente',
      telefone: '',
      endereco: '',
      itens: List.from(carrinho),
      criadoEm: DateTime.now(),
      entregue: false,
    );

    await widget.pedidoService.addPedido(pedido);

    setState(() {
      carrinho.clear();
    });

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pedido realizado com sucesso!')),
    );
  }
}