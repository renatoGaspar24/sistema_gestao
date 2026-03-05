import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Builder(
        builder: (context) {
          final tabController = DefaultTabController.of(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text("Admin"),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Produtos'),
                  Tab(text: 'Estoque'),
                  Tab(text: 'Funcionários'),
                  Tab(text: 'Pedidos'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _buildProdutosTab(),
                _buildEstoqueTab(),
                _buildUsuariosTab(),
                _buildPedidosTab(),
              ],
            ),
            floatingActionButton: Builder(
              builder: (context) {
                switch (tabController.index) {
                  case 0:
                    return FloatingActionButton(
                      child: const Icon(Icons.add),
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
                    );
                  case 2:
                    return FloatingActionButton(
                      child: const Icon(Icons.person_add),
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

  Widget _buildEstoqueTab() {
    final baixos = widget.produtoService.produtosAbaixo(5);
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _produtos.length,
      itemBuilder: (context, index) {
        final p = _produtos[index];
        return ListTile(
          title: Text(p.nome),
          subtitle: Text('Quantidade: ${p.quantidade}'),
          tileColor: baixos.contains(p)
              ? Colors.red.withAlpha((0.2 * 255).toInt())
              : null,
        );
      },
    );
  }

  Widget _buildUsuariosTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _usuarios.length,
      itemBuilder: (context, index) {
        final u = _usuarios[index];
        return ListTile(title: Text(u.nome), subtitle: Text(u.cargo));
      },
    );
  }

  Widget _buildPedidosTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _pedidos.length,
      itemBuilder: (context, index) {
        final ped = _pedidos[index];
        return ListTile(
          title: Text(ped.clienteNome),
          subtitle: Text(
            '${ped.itens.length} itens - ${ped.entregue ? 'Entregue' : 'Pendente'}',
          ),
          trailing: ped.entregue
              ? null
              : IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    widget.pedidoService.marcarEntregue(index);
                    _loadPedidos();
                  },
                ),
        );
      },
    );
  }
}
