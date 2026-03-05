import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'models/produto.dart';

class CadastroProdutoPage extends StatefulWidget {
  final Function(Produto) onSalvar;
  const CadastroProdutoPage({super.key, required this.onSalvar});

  @override
  State<CadastroProdutoPage> createState() => _CadastroProdutoPageState();
}

class _CadastroProdutoPageState extends State<CadastroProdutoPage> {
  final TextEditingController _nome = TextEditingController();
  final TextEditingController _descricao = TextEditingController();
  final TextEditingController _preco = TextEditingController();
  final TextEditingController _moeda = TextEditingController();
  Categoria _categoria = Categoria.hamburguer;
  final TextEditingController _quantidade = TextEditingController(text: '0');
  File? _imagemSelecionada;
  final ImagePicker _picker = ImagePicker();

  Future<void> _selecionarImagem() async {
    final XFile? imagem = await _picker.pickImage(source: ImageSource.gallery);
    if (imagem != null) {
      setState(() {
        _imagemSelecionada = File(imagem.path);
      });
    }
  }

  Future<String> _salvarImagem(File imagem) async {
    final directory = await getApplicationDocumentsDirectory();
    final nomeArquivo = path.basename(imagem.path);
    final caminhoSalvo = path.join(directory.path, nomeArquivo);
    await imagem.copy(caminhoSalvo);
    return caminhoSalvo;
  }

  void _salvar() async {
    if (_nome.text.isEmpty || _preco.text.isEmpty) return;
    String imagemPath = '';
    if (_imagemSelecionada != null) {
      imagemPath = await _salvarImagem(_imagemSelecionada!);
    }
    final novo = Produto(
      nome: _nome.text,
      descricao: _descricao.text,
      preco: double.tryParse(_preco.text) ?? 0,
      moeda: _moeda.text.isEmpty ? "AOA" : _moeda.text,
      imagemPath: imagemPath,
      categoria: _categoria,
      quantidade: int.tryParse(_quantidade.text) ?? 0,
    );
    widget.onSalvar(novo);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastrar Produto"),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nome,
                decoration: InputDecoration(
                  labelText: "Nome",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descricao,
                decoration: InputDecoration(
                  labelText: "Descrição",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _preco,
                decoration: InputDecoration(
                  labelText: "Preço",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _moeda,
                decoration: InputDecoration(
                  labelText: "Moeda",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<Categoria>(
                initialValue: _categoria,
                decoration: InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                ),
                items: Categoria.values.map((c) {
                  return DropdownMenuItem(
                    value: c,
                    child: Text(c.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (c) {
                  if (c != null) setState(() => _categoria = c);
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _quantidade,
                decoration: InputDecoration(
                  labelText: "Quantidade",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _imagemSelecionada != null && !kIsWeb
                  ? Image.file(
                      _imagemSelecionada!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    )
                  : const Text("Nenhuma imagem selecionada"),
              ElevatedButton(
                onPressed: _selecionarImagem,
                child: const Text("Selecionar Imagem"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _salvar, child: const Text("Salvar")),
            ],
          ),
        ),
      ),
    );
  }
}
