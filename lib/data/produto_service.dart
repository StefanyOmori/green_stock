import 'dart:convert';
import 'package:green_stock/model/produto.dart';
import 'package:http/http.dart' as http;

class ProdutoService {
  static const String baseUrl =
      'https://6af312c0d2377d6c370478a6.mockapi.io/api/v1/produtos/produtos';

  Future<List<Produto>> buscarProdutos() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List dados = jsonDecode(response.body);

      return dados.map((item) => Produto.fromJson(item)).toList();
    }

    throw Exception('Erro ao carregar produtos.');
  }

  Future<Produto> cadastrarProduto(Produto produto) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(produto.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Produto.fromJson(jsonDecode(response.body));
    }

    throw Exception(
      'Erro ao cadastrar produto: ${response.statusCode} - ${response.body}',
    );
  }

  Future<Produto> atualizarProduto(Produto produto) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${produto.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(produto.toJson()),
    );

    if (response.statusCode == 200) {
      return Produto.fromJson(jsonDecode(response.body));
    }

    throw Exception('Erro ao atualizar produto.');
  }

  Future<void> excluirProduto(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Erro ao excluir produto.');
    }
  }
}
