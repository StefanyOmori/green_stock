class Produto {
  final String id;
  final String nome;
  final String descricao;
  final String categoria;
  final int quantidade;
  final double preco;
  final int estoqueMinimo;

  Produto({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.categoria,
    required this.quantidade,
    required this.preco,
    required this.estoqueMinimo,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id']?.toString() ?? '',
      nome: json['nome'] ?? '',
      descricao: json['descricao'] ?? '',
      categoria: json['categoria'] ?? 'Outros',
      quantidade: (json['quantidade'] as num?)?.toInt() ?? 0,
      preco: (json['preco'] as num?)?.toDouble() ?? 0.0,
      estoqueMinimo: (json['estoqueMinimo'] as num?)?.toInt() ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'descricao': descricao,
      'categoria': categoria,
      'quantidade': quantidade,
      'preco': preco,
      'estoqueMinimo': estoqueMinimo,
    };
  }
}
