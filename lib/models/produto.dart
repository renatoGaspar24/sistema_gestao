enum Categoria { hamburguer, bebida, acompanhamento }

class Produto {
  final String nome;
  final String descricao;
  final double preco;
  final String moeda;
  final String imagemPath;
  Categoria categoria;
  int quantidade;

  Produto({
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.moeda,
    required this.imagemPath,
    this.categoria = Categoria.hamburguer,
    this.quantidade = 0,
  });
}
