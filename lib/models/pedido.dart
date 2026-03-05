import 'produto.dart';

class ItemPedido {
  final Produto produto;
  final int quantidade;

  ItemPedido({required this.produto, required this.quantidade});
}

class Pedido {
  final String clienteNome;
  final String telefone;
  final String endereco;
  final List<ItemPedido> itens;
  final DateTime criadoEm;
  bool entregue;

  Pedido({
    required this.clienteNome,
    required this.telefone,
    required this.endereco,
    required this.itens,
    DateTime? criadoEm,
    this.entregue = false,
  }) : criadoEm = criadoEm ?? DateTime.now();
}
