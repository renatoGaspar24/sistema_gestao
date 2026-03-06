import 'dart:io';
// ignore: unnecessary_import
import 'dart:typed_data'; // IMPORTANTE: Para usar Uint8List (bytes)
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Para usar kIsWeb
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
  final TextEditingController _quantidade = TextEditingController(text: '0');
  
  Categoria _categoria = Categoria.hamburguer;
  
  // Variáveis para imagem
  File? _imagemSelecionada;   // Adicionado para armazenar a imagem selecionada (Mobile)
  Uint8List? _webImageBytes; // Adicionado para armazenar os bytes da imagem (Web)
  
  final ImagePicker _picker = ImagePicker();

  Future<void> _selecionarImagem() async {
    final XFile? imagem = await _picker.pickImage(source: ImageSource.gallery);
    
    if (imagem != null) {
      final bytes = await imagem.readAsBytes();
      
      setState(() {
        _webImageBytes = bytes; // Usado para mostrar na tela (Web/Mobile)
        _imagemSelecionada = File(imagem.path); // Usado para salvar no projeto (Mobile)
      });
    }
  }

  Future<String> _salvarImagemNoProjeto(File imagem) async {
    // Se estiver na Web, a imagem vai ser salva em um caminho temporário (pois não temos acesso ao sistema de arquivos local)
    if (kIsWeb) return 'caminho_web_temporario';

    final appDir = await getApplicationDocumentsDirectory();
    final pastaImagens = Directory('${appDir.path}/produtos_fotos');
    if (!await pastaImagens.exists()) {
      await pastaImagens.create(recursive: true);
    }

    final String extensao = path.extension(imagem.path);
    final String nomeArquivo = "img_${DateTime.now().millisecondsSinceEpoch}$extensao";
    final String caminhoFinal = path.join(pastaImagens.path, nomeArquivo);
    
    await imagem.copy(caminhoFinal);
    return caminhoFinal;
  }

  void _salvar() async {
    if (_nome.text.isEmpty || _preco.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha o nome e o preço!")),
      );
      return;
    }

    String imagemPath = '';
    if (_imagemSelecionada != null) {
      imagemPath = await _salvarImagemNoProjeto(_imagemSelecionada!);
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
        backgroundColor: Colors.transparent, 
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Preview da Imagem 
            GestureDetector(
              onTap: _selecionarImagem,
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                ),
                child: _webImageBytes != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.memory(_webImageBytes!, fit: BoxFit.cover),
                      )
                    : const Icon(Icons.add_a_photo, size: 50),
              ),
            ),
            const SizedBox(height: 24),
            
            _buildTextField(_nome, "Nome do Produto"),
            const SizedBox(height: 12),
            _buildTextField(_descricao, "Descrição"),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(child: _buildTextField(_preco, "Preço", isNumber: true)),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField(_moeda, "Moeda (Ex: AOA)")),
              ],
            ),
            const SizedBox(height: 12),
            
            DropdownButtonFormField<Categoria>(
              // ignore: deprecated_member_use
              value: _categoria, 
              decoration: InputDecoration(
                labelText: 'Categoria',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
              ),
              items: Categoria.values.map((c) {
                return DropdownMenuItem(value: c, child: Text(c.name.toUpperCase()));
              }).toList(),
              onChanged: (c) {
                if (c != null) setState(() => _categoria = c);
              },
            ),
            const SizedBox(height: 12),
            _buildTextField(_quantidade, "Quantidade em Estoque", isNumber: true),
            
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _salvar,
                child: const Text("SALVAR PRODUTO", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
      ),
    );
  }
}