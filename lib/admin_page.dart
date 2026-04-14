import 'dart:convert';
import 'package:flutter/material.dart';
import 'models/produto.dart';
import 'cadastro_produto_page.dart';
import 'produto_service.dart';
import 'usuario_service.dart';
import 'pedido_service.dart';
import 'cadastro_funcionario_page.dart';
import 'models/usuario.dart';
import 'models/pedido.dart';

class AdminPage extends StatefulWidget {
  final ProdutoService produtoService;
  final UsuarioService usuarioService;
  final PedidoService pedidoService;

  const AdminPage({
    super.key,
    required this.produtoService,
    required this.usuarioService,
    required this.pedidoService,
  });

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<Produto> _produtos = [];
  List<Usuario> _usuarios = [];
  List<Pedido> _pedidos = [];

  @override
  void initState() {
    super.initState();
    _loadProdutos();
    _loadUsuarios();
    _loadPedidos();
  }

  void _loadUsuarios() {
    setState(() {
      _usuarios = widget.usuarioService.getUsuarios();
    });
  }

  void _loadPedidos() {
    setState(() {
      _pedidos = widget.pedidoService.getPedidos();
    });
  }

  void _loadProdutos() {
    setState(() {
      _produtos = widget.produtoService.getProdutos();
    });
  }

  void _deletarProduto(int index) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Tem certeza que deseja deletar este produto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Deletar'),
          ),
        ],
      ),
    );
    if (confirmar == true) {
      await widget.produtoService.removeProduto(index);
      _loadProdutos();
    }
  }

  void _atualizarProdutos(Produto novo) async {
    await widget.produtoService.addProduto(novo);
    _loadProdutos();
  }

  void _adicionarUsuario(Usuario u) async {
    await widget.usuarioService.addUsuario(u);
    _loadUsuarios();
  }

  // ignore: unused_element
  void _atualizarPedido(Pedido i) async {
    await widget.pedidoService.atualizarPedido(i);
    _loadPedidos();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Builder(
        builder: (context) {
          final tabController = DefaultTabController.of(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text("Admin"),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Produtos/Estoque'),
                  Tab(text: 'Funcionários'),
                  Tab(text: 'Pedidos'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _buildProdutosTab(),
                _buildUsuariosTab(),
                _buildPedidosTab(),
              ],
            ),
            // botoes fluantes de atualizacao de stock,funcionarios e produtos
            floatingActionButton: AnimatedBuilder(
              // foi adicionado pq ao mudar de aba o botao nao atualizava e causa bugs na pagina
              animation:
                  tabController, // está funcao recontroi o botao para cada aba sempre que mudo
              builder: (context, child) {
                switch (tabController.index) {
                  case 0:
                    return FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CadastroProdutoPage(
                              onSalvar: _atualizarProdutos,
                            ),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.add,
                      ), //botao para adicionar produtos
                    );

                  case 1:
                    return FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CadastroFuncionarioPage(
                              onSalvar: _adicionarUsuario,
                            ),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.person_add,
                      ), // botao na aba de funcionarios
                    );

                  case 2:
                    return FloatingActionButton(
                      onPressed: _loadPedidos,
                      child: const Icon(
                        Icons.refresh,
                      ), //botao na na aba de pedido
                    );

                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
          );
        },
      ),
    );
  }

  // contrucao da aba onde sao apresentados os produtos,mostrando os seus detalhes.´
  // listView.builder para mostrar os em forma de lista.
  Widget _buildProdutosTab() {
    return ListView.builder(
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
            leading: _buildProdutoImagem(p),
            title: Text(p.nome),
            subtitle: Text(
              "${p.descricao}\nPreço: ${p.preco} ${p.moeda} | Cat: ${p.categoria.name} | Qtde: ${p.quantidade}",
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deletarProduto(index),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProdutoImagem(Produto p) {
    if (p.imagemPath.isEmpty) {
      return const Icon(Icons.fastfood, size: 50);
    }

    if (p.imagemPath.startsWith('assets/')) {
      return Image.asset(
        p.imagemPath,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, size: 50),
      );
    }
    // esta funcao serve para descodificar as imagens que sao adicionadas quando for cadastrado um produtos
    if (p.imagemPath.length > 100) {
      try {
        return Image.memory(
          base64Decode(p.imagemPath),
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.broken_image, size: 50),
        );
      } catch (_) {
        return const Icon(Icons.broken_image, size: 50);
      }
    }

    return const Icon(Icons.fastfood, size: 50);
  }

  Widget _buildUsuariosTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _usuarios.length,
      itemBuilder: (context, index) {
        final u = _usuarios[index];
        return ExpansionTile(
          title: Text(u.nome),
          subtitle: Text(u.cargo),
          children: [
            Image.asset(
              'assets/images/logo.png', //logotipo na pagina de boas-vindas
              width: 150,
              height: 150,
            ),
            ListTile(title: const Text("Telefone"), subtitle: Text(u.telefone)),
            ListTile(title: const Text("Cargo"), subtitle: Text(u.cargo)),
          ],
        );
      },
    );
  }

  Widget _buildPedidosTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _pedidos.length,
      itemBuilder: (context, index) {
        final ped = _pedidos[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ExpansionTile(
            // ExpansionTile permite ver os itens ao clicar
            title: Text(
              ped.clienteNome,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.phone, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(ped.telefone.isEmpty ? "Não informado" : ped.telefone),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        ped.endereco.isEmpty
                            ? "Retirada no local"
                            : ped.endereco,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Status: ${ped.entregue ? '✅ Entregue' : '⏳ Pendente'}',
                  style: TextStyle(
                    color: ped.entregue ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            trailing: ped.entregue
                ? IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Deletar pedido entregue',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirmar exclusão'),
                          content: const Text(
                            'Tem certeza que deseja deletar este pedido entregue?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                widget.pedidoService.deletarPedido(index);
                                _loadPedidos();
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Deletar',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : IconButton(
                    icon: const Icon(
                      Icons.delivery_dining,
                      color: Color(0xFF8B1A10),
                    ),
                    tooltip: 'Marcar como entregue',
                    onPressed: () {
                      widget.pedidoService.marcarEntregue(index);
                      _loadPedidos();
                    },
                  ),
            children: [
              const Divider(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Itens do Pedido:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              // Lista os itens dentro do pedido
              ...ped.itens.map(
                (item) => ListTile(
                  title: Text(item.produto.nome),
                  trailing: Text("x${item.quantidade}"),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
