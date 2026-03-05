import 'package:flutter/material.dart';
import 'models/usuario.dart';

class CadastroFuncionarioPage extends StatefulWidget {
  final Function(Usuario) onSalvar;
  const CadastroFuncionarioPage({super.key, required this.onSalvar});

  @override
  State<CadastroFuncionarioPage> createState() =>
      _CadastroFuncionarioPageState();
}

class _CadastroFuncionarioPageState extends State<CadastroFuncionarioPage> {
  final _nome = TextEditingController();
  final _cargo = TextEditingController();
  final _telefone = TextEditingController();
  final _turno = TextEditingController();
  final _salario = TextEditingController();
  DateTime? _dataAdmissao;

  void _salvar() {
    if (_nome.text.isEmpty || _cargo.text.isEmpty) return;
    final usuario = Usuario(
      nome: _nome.text,
      cargo: _cargo.text,
      telefone: _telefone.text,
      turno: _turno.text,
      salario: double.tryParse(_salario.text) ?? 0,
      dataAdmissao: _dataAdmissao ?? DateTime.now(),
    );
    widget.onSalvar(usuario);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _pickDate() async {
    final dt = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (dt != null) setState(() => _dataAdmissao = dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Funcionario')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nome,
              decoration: const InputDecoration(labelText: 'Nome completo'),
            ),
            TextField(
              controller: _cargo,
              decoration: const InputDecoration(labelText: 'Cargo'),
            ),
            TextField(
              controller: _telefone,
              decoration: const InputDecoration(labelText: 'Telefone'),
            ),
            TextField(
              controller: _turno,
              decoration: const InputDecoration(labelText: 'Turno'),
            ),
            TextField(
              controller: _salario,
              decoration: const InputDecoration(labelText: 'Salário'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Data de contratação: '),
                Text(
                  _dataAdmissao?.toLocal().toString().split(' ')[0] ??
                      'nenhuma',
                ),
                TextButton(
                  onPressed: _pickDate,
                  child: const Text('Selecionar'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _salvar, child: const Text('Salvar')),
          ],
        ),
      ),
    );
  }
}
