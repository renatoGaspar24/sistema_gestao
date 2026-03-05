import 'package:hive/hive.dart';
import 'models/usuario.dart';
import 'usuario_adapter.dart';

class UsuarioService {
  static const String _boxName = 'usuarios';

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UsuarioAdapter());
    }
    await Hive.openBox<Usuario>(_boxName);
  }

  Box<Usuario> get _box => Hive.box<Usuario>(_boxName);

  List<Usuario> getUsuarios() => _box.values.toList();

  Future<void> addUsuario(Usuario usuario) async {
    await _box.add(usuario);
  }

  Future<void> removeUsuario(int index) async {
    await _box.deleteAt(index);
  }

  Future<void> updateUsuario(int index, Usuario usuario) async {
    await _box.putAt(index, usuario);
  }
}
