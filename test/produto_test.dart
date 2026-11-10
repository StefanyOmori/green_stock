import 'package:flutter_test/flutter_test.dart';
import 'package:green_stock/data/produto_service.dart';
import 'package:green_stock/model/produto.dart';
import 'package:green_stock/providers/produto_provider.dart';

class FakeProdutoService extends ProdutoService {
  List<Produto> produtos = [];

  bool falharBusca = false;
  bool falharCadastro = false;
  bool falharAtualizacao = false;
  bool falharExclusao = false;

  @override
  Future<List<Produto>> buscarProdutos() async {
    if (falharBusca) {
      throw Exception('Erro ao buscar produtos');
    }

    return produtos;
  }

  @override
  Future<Produto> cadastrarProduto(Produto produto) async {
    if (falharCadastro) {
      throw Exception('Erro ao cadastrar');
    }

    return Produto(
      id: '3',
      nome: produto.nome,
      descricao: produto.descricao,
      categoria: produto.categoria,
      quantidade: produto.quantidade,
      preco: produto.preco,
      estoqueMinimo: produto.estoqueMinimo,
    );
  }

  @override
  Future<Produto> atualizarProduto(Produto produto) async {
    if (falharAtualizacao) {
      throw Exception('Erro ao atualizar');
    }

    return produto;
  }

  @override
  Future<void> excluirProduto(String id) async {
    if (falharExclusao) {
      throw Exception('Erro ao excluir');
    }

    produtos.removeWhere((produto) => produto.id == id);
  }
}

Produto criarProduto({
  String id = '1',
  String nome = 'Arroz',
  int quantidade = 20,
  int estoqueMinimo = 10,
}) {
  return Produto(
    id: id,
    nome: nome,
    descricao: 'Produto de teste',
    categoria: 'Alimentos',
    quantidade: quantidade,
    preco: 10.0,
    estoqueMinimo: estoqueMinimo,
  );
}

void main() {
  late FakeProdutoService service;
  late ProdutoProvider provider;

  setUp(() {
    service = FakeProdutoService();

    service.produtos = [
      criarProduto(id: '1', nome: 'Arroz', quantidade: 20),
      criarProduto(id: '2', nome: 'Feijão', quantidade: 5),
    ];

    provider = ProdutoProvider(service: service);
  });

  test('O Provider deve iniciar sem produtos', () {
    expect(provider.produtos, isEmpty);
    expect(provider.isLoading, false);
    expect(provider.erro, isNull);
  });

  test('Deve carregar os produtos', () async {
    await provider.carregarProdutos();

    expect(provider.produtos.length, 2);
    expect(provider.produtos.first.nome, 'Arroz');
  });

  test('Deve calcular o total de produtos', () async {
    await provider.carregarProdutos();

    expect(provider.totalProdutos, 2);
  });

  test('Deve calcular o total de unidades', () async {
    await provider.carregarProdutos();

    expect(provider.totalItens, 25);
  });

  test('Deve identificar produtos com estoque baixo', () async {
    await provider.carregarProdutos();

    expect(provider.produtosEstoqueBaixo.length, 1);
    expect(provider.produtosEstoqueBaixo.first.nome, 'Feijão');
  });

  test('Deve calcular o total de produtos com estoque baixo', () async {
    await provider.carregarProdutos();

    expect(provider.totalEstoqueBaixo, 1);
  });

  test('Deve cadastrar um produto', () async {
    await provider.carregarProdutos();

    final produto = criarProduto(id: '', nome: 'Macarrão');

    await provider.adicionarProduto(produto);

    expect(provider.totalProdutos, 3);
    expect(provider.produtos.last.nome, 'Macarrão');
  });

  test('Deve atualizar um produto', () async {
    await provider.carregarProdutos();

    final produtoAtualizado = criarProduto(id: '1', nome: 'Arroz Integral');

    await provider.atualizarProduto(produtoAtualizado);

    expect(provider.produtos.first.nome, 'Arroz Integral');
  });

  test('Deve excluir um produto', () async {
    await provider.carregarProdutos();

    await provider.excluirProduto('1');

    expect(provider.totalProdutos, 1);
    expect(provider.produtos.first.nome, 'Feijão');
  });

  test('Deve apresentar erro quando não conseguir carregar produtos', () async {
    service.falharBusca = true;

    await provider.carregarProdutos();

    expect(provider.erro, isNotNull);
    expect(provider.isLoading, false);
  });
}
