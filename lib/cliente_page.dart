import 'package:flutter/material.dart';
import 'produto_service.dart';
import 'pedido_service.dart';
import 'models/pedido.dart';
import 'models/produto.dart';
import 'dart:convert'; // Necessário para decodificar o Base64

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

  // Controllers para capturar os dados do cliente
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final produtos = widget.produtoService.getProdutos();

    return Scaffold(
      backgroundColor: const Color(0xFF8B1A10),
      appBar: AppBar(
        title: const Text(
          'Cokylicious Menu',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF8B1A10),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: produtos.isEmpty
            ? const Center(
                child: Text(
                  'Nenhum produto disponível',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Responsividade: muda o número de colunas conforme a largura
                        int colunas = constraints.maxWidth > 900
                            ? 4
                            : (constraints.maxWidth > 600 ? 3 : 2);

                        return GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: colunas,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio:
                                0.75, // Ajustado para acomodar melhor os elementos
                          ),
                          itemCount: produtos.length,
                          itemBuilder: (context, index) =>
                              _buildProdutoCard(produtos[index]),
                        );
                      },
                    ),
                  ),
                  // Barra inferior só aparece se houver itens
                  if (carrinho.isNotEmpty) _buildBottomBar(),
                ],
              ),
      ),
    );
  }

  // Função que decide como carregar a imagem (Base64 ou Asset)
  Widget _buildImagem(String imagemPath) {
    if (imagemPath.isEmpty) {
      return const Icon(Icons.fastfood, size: 40, color: Color(0xFF8B1A10));
    }

    // Se a string for muito longa, tratamos como Base64 (Web/Novo Cadastro)
    if (imagemPath.length > 200) {
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

    // Caso contrário, tratamos como um caminho de Asset do projeto
    return Image.asset(
      imagemPath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.fastfood, size: 40),
    );
  }

  Widget _buildProdutoCard(Produto produto) {
    return Card(
      elevation: 4,
      color: const Color(0xFFFFC107).withValues(alpha: 0.95),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Área da Imagem
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
              child: Container(
                color: Colors.white24,
                child: _buildImagem(produto.imagemPath),
              ),
            ),
          ),
          // Informações do Produto
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    produto.nome,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${produto.preco.toStringAsFixed(0)} ${produto.moeda}',
                    style: const TextStyle(
                      color: Color(0xFF8B1A10),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        carrinho.add(
                          ItemPedido(produto: produto, quantidade: 1),
                        );
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${produto.nome} adicionado!'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.add_circle,
                      color: Color(0xFF8B1A10),
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8B1A10),
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: _exibirFormularioPedido,
        child: Text(
          'Finalizar Pedido (${carrinho.length} itens)',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _exibirFormularioPedido() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                decoration: const InputDecoration(
                  labelText: 'Seu Nome',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _telefoneController,
                decoration: const InputDecoration(
                  labelText: 'Telefone / WhatsApp',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _enderecoController,
                decoration: const InputDecoration(
                  labelText: 'Endereço Completo',
                  prefixIcon: Icon(Icons.location_on),
                ),
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
            onPressed: _finalizarPedido,
            child: const Text('Confirmar Agora'),
          ),
        ],
      ),
    );
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
      telefone: _telefoneController.text,
      endereco: _enderecoController.text,
      itens: List.from(carrinho),
      criadoEm: DateTime.now(),
      entregue: false,
    );

    await widget.pedidoService.addPedido(pedido);

    setState(() {
      carrinho.clear();
      _nomeController.clear();
      _telefoneController.clear();
      _enderecoController.clear();
    });

    if (!mounted) return;
    Navigator.pop(context); // Fecha o Dialog

    // Exibicao da finalizacao do pedido
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sucesso!'),
        content: const Text('Pedido Feito!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}