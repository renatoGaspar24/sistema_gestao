import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'models/produto.dart';
import 'models/pedido.dart';
import 'produto_service.dart';
import 'pedido_service.dart';

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
  List<Produto> _produtos = [];
  final List<ItemPedido> _cart = []; // itens selecionados

  @override
  void initState() {
    super.initState();
    _loadProdutos();
  }

  void _loadProdutos() {
    setState(() {
      _produtos = widget.produtoService.getProdutos();
    });
  }

  void _addToCart(Produto produto) {
    setState(() {
      final existing = _cart.indexWhere((i) => i.produto == produto);
      if (existing != -1) {
        _cart[existing] = ItemPedido(
          produto: produto,
          quantidade: _cart[existing].quantidade + 1,
        );
      } else {
        _cart.add(ItemPedido(produto: produto, quantidade: 1));
      }
    });
  }

  Future<void> _placeOrder() async {
    final nomeCtl = TextEditingController();
    final telCtl = TextEditingController();
    final endCtl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final resultado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Finalize o pedido'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nomeCtl,
                decoration: const InputDecoration(labelText: 'Nome completo'),
                validator: (v) => v == null || v.isEmpty ? 'Obrigatório' : null,
              ),
              TextFormField(
                controller: telCtl,
                decoration: const InputDecoration(labelText: 'Telefone'),
                validator: (v) => v == null || v.isEmpty ? 'Obrigatório' : null,
              ),
              TextFormField(
                controller: endCtl,
                decoration: const InputDecoration(labelText: 'Endereço'),
                validator: (v) => v == null || v.isEmpty ? 'Obrigatório' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.pop(context, true);
              }
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );

    if (resultado == true) {
      final pedido = Pedido(
        clienteNome: nomeCtl.text,
        telefone: telCtl.text,
        endereco: endCtl.text,
        itens: List.from(_cart),
      );
      await widget.pedidoService.addPedido(pedido);
      setState(() {
        _cart.clear();
      });
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pedido registrado')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Produtos Disponíveis"),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: _produtos.isEmpty
          ? const Center(child: Text("Nenhum produto disponível"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _produtos.length,
              itemBuilder: (context, index) {
                final p = _produtos[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: p.imagemPath.isNotEmpty && !kIsWeb
                        ? Image.file(
                            File(p.imagemPath),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.fastfood),
                    title: Text(p.nome),
                    subtitle: Text(
                      "${p.descricao}\nPreço: ${p.preco} ${p.moeda}",
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      onPressed: () => _addToCart(p),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: _cart.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _placeOrder,
              icon: const Icon(Icons.shopping_cart_checkout),
              label: Text('${_cart.length} itens'),
            )
          : null,
    );
  }
}
