import 'package:hive/hive.dart';
import 'models/pedido.dart';
import 'models/produto.dart';

/// We assume ProdutoAdapter already registered and handles Produto serializing.
class ItemPedidoAdapter extends TypeAdapter<ItemPedido> {
  @override
  final int typeId = 2;

  @override
  ItemPedido read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return ItemPedido(
      produto: fields[0] as Produto,
      quantidade: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ItemPedido obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.produto)
      ..writeByte(1)
      ..write(obj.quantidade);
  }
}

class PedidoAdapter extends TypeAdapter<Pedido> {
  @override
  final int typeId = 3;

  @override
  Pedido read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return Pedido(
      clienteNome: fields[0] as String,
      telefone: fields[1] as String,
      endereco: fields[2] as String,
      itens: (fields[3] as List).cast<ItemPedido>(),
      criadoEm: fields[4] as DateTime,
      entregue: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Pedido obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.clienteNome)
      ..writeByte(1)
      ..write(obj.telefone)
      ..writeByte(2)
      ..write(obj.endereco)
      ..writeByte(3)
      ..write(obj.itens)
      ..writeByte(4)
      ..write(obj.criadoEm)
      ..writeByte(5)
      ..write(obj.entregue);
  }
}
