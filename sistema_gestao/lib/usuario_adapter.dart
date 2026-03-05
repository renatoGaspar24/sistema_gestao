import 'package:hive/hive.dart';
import 'models/usuario.dart';

class UsuarioAdapter extends TypeAdapter<Usuario> {
  @override
  final int typeId = 1;

  @override
  Usuario read(BinaryReader reader) {
    final fields = <int, dynamic>{};
    final numOfFields = reader.readByte();
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return Usuario(
      nome: fields[0] as String,
      cargo: fields[1] as String,
      telefone: fields[2] as String,
      turno: fields[3] as String,
      salario: fields[4] as double,
      dataAdmissao: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Usuario obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.nome)
      ..writeByte(1)
      ..write(obj.cargo)
      ..writeByte(2)
      ..write(obj.telefone)
      ..writeByte(3)
      ..write(obj.turno)
      ..writeByte(4)
      ..write(obj.salario)
      ..writeByte(5)
      ..write(obj.dataAdmissao);
  }
}
