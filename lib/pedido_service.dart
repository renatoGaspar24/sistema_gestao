import 'package:hive/hive.dart';
import 'models/pedido.dart';
import 'pedido_adapter.dart';
import 'produto_service.dart';

class PedidoService {
  static const String _boxName = 'pedidos';
  final ProdutoService produtoService;

  PedidoService({required this.produtoService});

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(ItemPedidoAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(PedidoAdapter());
    }
    await Hive.openBox<Pedido>(_boxName);
  }

  Box<Pedido> get _box => Hive.box<Pedido>(_boxName);

  List<Pedido> getPedidos() => _box.values.toList();

  Future<void> addPedido(Pedido pedido) async {
    await _box.add(pedido);
    await _atualizarEstoque(pedido);
  }

  Future<void> _atualizarEstoque(Pedido pedido) async {
    for (var item in pedido.itens) {
      await produtoService.decrementarQuantidade(item.produto, item.quantidade);
    }
  }

  Future<void> marcarEntregue(int index) async {
    final p = _box.getAt(index);
    if (p != null) {
      p.entregue = true;
      await _box.putAt(index, p);
    }
  }
}
