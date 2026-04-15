import 'package:flutter/material.dart';
import 'models/pedido.dart';
import 'models/usuario.dart';
import 'pedido_service.dart';
import 'dart:convert';
import 'constants.dart';

class CarrinhoPage extends StatefulWidget {
  final List<ItemPedido> carrinho;
  final Usuario usuario;
  final PedidoService pedidoService;
  final VoidCallback onCarrinhoAlterado;

  const CarrinhoPage({
    super.key,
    required this.carrinho,
    required this.usuario,
    required this.pedidoService,
    required this.onCarrinhoAlterado,
  });

  @override
  State<CarrinhoPage> createState() => _CarrinhoPageState();
}

class _CarrinhoPageState extends State<CarrinhoPage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nomeController.text = widget.usuario.nome;
    _telefoneController.text = widget.usuario.telefone;
  }

  double get _total => widget.carrinho.fold(
    0.0,
    (sum, item) => sum + (item.produto.preco * item.quantidade),
  );

  void _removerItem(int index) {
    setState(() {
      widget.carrinho.removeAt(index);
      widget.onCarrinhoAlterado();
    });
  }

  void _alterarQuantidade(int index, int novaQuantidade) {
    if (novaQuantidade <= 0) {
      _removerItem(index);
      return;
    }
    setState(() {
      widget.carrinho[index] = ItemPedido(
        produto: widget.carrinho[index].produto,
        quantidade: novaQuantidade,
      );
      widget.onCarrinhoAlterado();
    });
  }

  void _finalizarPedido() async {
    if (_nomeController.text.isEmpty || _enderecoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha nome e endereço!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final pedido = Pedido(
      clienteNome: _nomeController.text,
      clienteEmail: widget.usuario.email,
      telefone: _telefoneController.text,
      endereco: _enderecoController.text,
      itens: List.from(widget.carrinho),
      criadoEm: DateTime.now(),
      entregue: false,
    );

    await widget.pedidoService.addPedido(pedido);

    widget.carrinho.clear();
    widget.onCarrinhoAlterado();

    if (!mounted) return;
    Navigator.pop(context); // Fecha a página do carrinho

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sucesso!'),
        content: const Text('Pedido realizado com sucesso!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Carrinho',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: kBodyFontSize,
          ),
        ),
        backgroundColor: kBackgroundColor,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: kAppBarElevation,
      ),
      body: widget.carrinho.isEmpty
          ? const Center(
              child: Text(
                'Carrinho vazio',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(kPaddingMedium),
                    itemCount: widget.carrinho.length,
                    itemBuilder: (context, index) {
                      final item = widget.carrinho[index];
                      return Card(
                        color: kSurfaceColor,
                        margin: const EdgeInsets.only(bottom: kSpacingSmall),
                        child: Padding(
                          padding: const EdgeInsets.all(kPaddingMedium),
                          child: Row(
                            children: [
                              // Imagem do produto
                              Container(
                                width: kProductImageWidth,
                                height: kProductImageHeight,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    kBorderRadiusSmall,
                                  ),
                                  color: Colors.white,
                                ),
                                child: _buildImagem(item.produto.imagemPath),
                              ),
                              const SizedBox(width: 12),
                              // Detalhes
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.produto.nome,
                                      style: kBodyTextStyle.copyWith(
                                        fontSize: kBodyFontSize,
                                      ),
                                    ),
                                    Text(
                                      '${item.produto.preco.toStringAsFixed(0)} ${item.produto.moeda}',
                                      style: TextStyle(
                                        color: kSecondaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: kBodyFontSize,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Controles de quantidade
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => _alterarQuantidade(
                                      index,
                                      item.quantidade - 1,
                                    ),
                                    icon: Icon(
                                      Icons.remove_circle,
                                      color: kSecondaryColor,
                                    ),
                                  ),
                                  Text(
                                    '${item.quantidade}',
                                    style: kBodyTextStyle.copyWith(
                                      fontSize: kBodyFontSize,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => _alterarQuantidade(
                                      index,
                                      item.quantidade + 1,
                                    ),
                                    icon: Icon(
                                      Icons.add_circle,
                                      color: kSecondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              // Botão remover
                              IconButton(
                                onPressed: () => _removerItem(index),
                                icon: const Icon(
                                  Icons.delete,
                                  color: kErrorColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Total e botão finalizar
                Container(
                  padding: const EdgeInsets.all(kPaddingMedium),
                  color: Colors.orange,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total:',
                            style: kBodyTextStyle.copyWith(
                              fontSize: kBodyFontSize,
                            ),
                          ),
                          Text(
                            'AOA\$ ${_total.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: kBodyFontSize,
                              fontWeight: FontWeight.bold,
                              color: kSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: kSpacingLarge),
                      ElevatedButton(
                        onPressed: () => _mostrarFormularioEntrega(context),
                        style: kElevatedButtonStyle(kBackgroundColor).copyWith(
                          minimumSize: const WidgetStatePropertyAll(
                            Size(double.infinity, kButtonHeight),
                          ),
                        ),
                        child: Text(
                          'Finalizar Pedido',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: kBodyFontSize,
                            fontWeight: FontWeight.bold,
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

  void _mostrarFormularioEntrega(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
        ),
        title: const Text(
          'Dados para Entrega',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomeController,
                decoration: kTextFieldDecoration(
                  'Seu Nome',
                ).copyWith(prefixIcon: const Icon(Icons.person)),
              ),
              const SizedBox(height: kSpacingMedium),
              TextField(
                controller: _telefoneController,
                decoration: kTextFieldDecoration(
                  'Telefone / WhatsApp',
                ).copyWith(prefixIcon: const Icon(Icons.phone)),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: kSpacingMedium),
              TextField(
                controller: _enderecoController,
                decoration: kTextFieldDecoration(
                  'Endereço Completo',
                ).copyWith(prefixIcon: const Icon(Icons.location_on)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Voltar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Fecha o dialog
              _finalizarPedido();
            },
            child: const Text('Confirmar Pedido'),
          ),
        ],
      ),
    );
  }

  Widget _buildImagem(String imagemPath) {
    if (imagemPath.isEmpty) {
      return Icon(
        Icons.fastfood,
        size: kIconSizeMedium,
        color: kSecondaryColor,
      );
    }

    if (imagemPath.length > 100) {
      try {
        return Image.memory(
          base64Decode(imagemPath),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.broken_image),
        );
      } catch (e) {
        return const Icon(Icons.broken_image);
      }
    }

    return Image.asset(
      imagemPath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          Icon(Icons.fastfood, size: kIconSizeMedium),
    );
  }
}
