import 'package:flutter/material.dart';
import 'package:green_stock/model/produto.dart';
import '../data/produto_service.dart';

class ProdutoProvider extends ChangeNotifier {
  final ProdutoService _service;

  ProdutoProvider({ProdutoService? service})
    : _service = service ?? ProdutoService();

  List<Produto> _produtos = [];
  bool _isLoading = false;
  String? _erro;

  List<Produto> get produtos => _produtos;
  bool get isLoading => _isLoading;
  String? get erro => _erro;

  int get totalProdutos => _produtos.length;

  int get totalItens {
    return _produtos.fold(0, (total, produto) => total + produto.quantidade);
  }

  List<Produto> get produtosEstoqueBaixo {
    return _produtos
        .where((produto) => produto.quantidade <= produto.estoqueMinimo)
        .toList();
  }

  int get totalEstoqueBaixo => produtosEstoqueBaixo.length;

  Future<void> carregarProdutos() async {
    _isLoading = true;
    _erro = null;
    notifyListeners();

    try {
      _produtos = await _service.buscarProdutos();
    } catch (e) {
      _erro = 'Não foi possível carregar os produtos.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> adicionarProduto(Produto produto) async {
    _erro = null;

    try {
      final novoProduto = await _service.cadastrarProduto(produto);
      _produtos.add(novoProduto);
      notifyListeners();
    } catch (e) {
      _erro = 'Não foi possível cadastrar o produto.';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> atualizarProduto(Produto produto) async {
    _erro = null;

    try {
      final produtoAtualizado = await _service.atualizarProduto(produto);

      final index = _produtos.indexWhere((item) => item.id == produto.id);

      if (index != -1) {
        _produtos[index] = produtoAtualizado;
      }

      notifyListeners();
    } catch (e) {
      _erro = 'Não foi possível atualizar o produto.';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> excluirProduto(String id) async {
    _erro = null;

    try {
      await _service.excluirProduto(id);
      _produtos.removeWhere((produto) => produto.id == id);
      notifyListeners();
    } catch (e) {
      _erro = 'Não foi possível excluir o produto.';
      notifyListeners();
      rethrow;
    }
  }
}
