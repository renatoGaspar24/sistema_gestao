import 'package:flutter/material.dart';
import 'produto_service.dart';
import 'pedido_service.dart';
import 'usuario_service.dart';
import 'models/pedido.dart';
import 'models/produto.dart';
import 'models/usuario.dart';
import 'dart:convert'; // Necessário para decodificar o Base64
import 'carrinho_page.dart'; // Import da nova página do carrinho
import 'welcome_page.dart';
import 'constants.dart'; // Import das constantes

class ClientePage extends StatefulWidget {
  final ProdutoService produtoService;
  final PedidoService pedidoService;
  final UsuarioService usuarioService;
  final Usuario usuario;

  const ClientePage({
    super.key,
    required this.produtoService,
    required this.pedidoService,
    required this.usuarioService,
    required this.usuario,
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
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Cokylicious Menu',
          style: TextStyle(
            color: Colors.white,
            height: 1.2,
            fontWeight: FontWeight.bold,
            fontSize: kBodyFontSize,
          ),
        ),
        backgroundColor: kBackgroundColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: kAppBarElevation,
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
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CarrinhoPage(
                        carrinho: carrinho,
                        usuario: widget.usuario,
                        pedidoService: widget.pedidoService,
                        onCarrinhoAlterado: () => setState(() {}),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.shopping_cart),
              ),
              if (carrinho.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${carrinho.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: produtos.isEmpty
            ? const Center(child: Text('Nenhum produto disponível'))
            : Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 100,
                    height: 100,
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final int colunas =
                            constraints.maxWidth > kGridBreakpointLarge
                            ? kGridColumnsLarge
                            : (constraints.maxWidth > kGridBreakpointMedium
                                  ? kGridColumnsMedium
                                  : kGridColumnsSmall);
                        return GridView.builder(
                          padding: const EdgeInsets.all(kPaddingMedium),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: colunas,
                                crossAxisSpacing: kGridCrossAxisSpacing,
                                mainAxisSpacing: kGridMainAxisSpacing,
                                childAspectRatio: kGridChildAspectRatio,
                              ),
                          itemCount: produtos.length,
                          itemBuilder: (context, index) =>
                              _buildProdutoCard(produtos[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
      /*bottomNavigationBar: carrinho.isNotEmpty
          ? SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.all(kPaddingMedium),
                color: kBackgroundColor,
                child: ElevatedButton(
                  style: kElevatedButtonStyle(Colors.orange),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CarrinhoPage(
                          carrinho: carrinho,
                          usuario: widget.usuario,
                          pedidoService: widget.pedidoService,
                          onCarrinhoAlterado: () => setState(() {}),
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Ver Carrinho (${carrinho.length} itens)',
                    style: kBodyTextStyle,
                  ),
                ),
              ),
            )
          : null,*/
    );
  }

  // Função que decide como carregar a imagem (Base64 ou Asset)
  Widget _buildImagem(String imagemPath) {
    if (imagemPath.isEmpty) {
      return Icon(Icons.fastfood, size: kIconSizeSmall, color: kSecondaryColor);
    }

    // Se a string for muito longa, tratamos como Base64 (Web/Novo Cadastro)
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

    // Caso contrário, tratamos como um caminho de Asset do projeto
    return Image.asset(
      imagemPath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          Icon(Icons.fastfood, size: kIconSizeSmall),
    );
  }

  Widget _buildProdutoCard(Produto produto) {
    return Card(
      elevation: kProductCardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kProductCardBorderRadius),
      ),
      color: kSurfaceColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Área da Imagem
          Expanded(
            flex: kCardImageHeightRatio.toInt(),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(kProductCardBorderRadius),
              ),
              child: Container(
                color: const Color.fromARGB(57, 252, 255, 252),
                child: _buildImagem(produto.imagemPath),
              ),
            ),
          ),
          // Informações do Produto
          Expanded(
            flex: kCardInfoHeightRatio.toInt(),
            child: Padding(
              padding: const EdgeInsets.all(kProductCardPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    produto.nome,
                    style: kSmallTextStyle.copyWith(fontSize: kSmallFontSize),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${produto.preco.toStringAsFixed(0)} ${produto.moeda}',
                    style: TextStyle(
                      color: kSecondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: kBodyFontSize,
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
                          duration: kSnackBarDuration,
                        ),
                      );
                    },
                    child: Icon(
                      Icons.add_circle,
                      color: kSecondaryColor,
                      size: kIconSizeMedium,
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
}
