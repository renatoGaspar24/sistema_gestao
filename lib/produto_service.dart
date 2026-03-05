import 'package:hive/hive.dart';
import 'models/produto.dart';
import 'produto_adapter.dart';

class ProdutoService {
  static const String _boxName = 'produtos';

  Future<void> init() async {
    Hive.registerAdapter(ProdutoAdapter());
    await Hive.openBox<Produto>(_boxName);
  }

  Box<Produto> get _box => Hive.box<Produto>(_boxName);

  List<Produto> getProdutos() {
    // listar produtos
    return _box.values.toList();
  }

  Future<void> addProduto(Produto produto) async {
    //adicionar produtos
    await _box.add(produto);
  }

  /// reduce quantity of given product by [qtd], not below zero
  Future<void> decrementarQuantidade(Produto produto, int qtd) async {
    final index = _box.values.toList().indexOf(produto);
    if (index != -1) {
      final p = _box.getAt(index)!;
      p.quantidade = (p.quantidade - qtd).clamp(0, p.quantidade);
      await _box.putAt(index, p);
    }
  }

  /// update quantity directly
  Future<void> atualizarQuantidade(int index, int nova) async {
    final p = _box.getAt(index);
    if (p != null) {
      p.quantidade = nova;
      await _box.putAt(index, p);
    }
  }

  List<Produto> produtosAbaixo(int limite) {
    return _box.values.where((p) => p.quantidade <= limite).toList();
  }

  Future<void> removeProduto(int index) async {
    //remover produtos
    await _box.deleteAt(index);
  }

  Future<void> updateProduto(int index, Produto produto) async {
    await _box.putAt(index, produto);
  }
}
