import 'package:hive/hive.dart';
import 'models/produto.dart';

class ProdutoAdapter extends TypeAdapter<Produto> {
  @override
  final int typeId = 0;

  @override
  Produto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Produto(
      nome: fields[0] as String,
      descricao: fields[1] as String,
      preco: fields[2] as double,
      moeda: fields[3] as String,
      imagemPath: fields[4] as String,
      categoria: Categoria.values[fields[5] as int],
      quantidade: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Produto obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.nome)
      ..writeByte(1)
      ..write(obj.descricao)
      ..writeByte(2)
      ..write(obj.preco)
      ..writeByte(3)
      ..write(obj.moeda)
      ..writeByte(4)
      ..write(obj.imagemPath)
      ..writeByte(5)
      ..write(obj.categoria.index)
      ..writeByte(6)
      ..write(obj.quantidade);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProdutoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
