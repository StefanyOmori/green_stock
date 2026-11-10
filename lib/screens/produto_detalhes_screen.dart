import 'package:flutter/material.dart';
import 'package:green_stock/model/produto.dart';
import 'package:provider/provider.dart';


import '../providers/produto_provider.dart';
import 'produto_form_screen.dart';

const verdeDetalhes = Color(0xFF27834B);
const verdeEscuroDetalhes = Color(0xFF174D32);
const fundoDetalhes = Color(0xFFF2F7F0);

class ProdutoDetalhesScreen extends StatelessWidget {
  final Produto produto;

  const ProdutoDetalhesScreen({super.key, required this.produto});

  Future<void> excluirProduto(BuildContext context) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir produto'),
          content: Text('Deseja realmente excluir ${produto.nome}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmar != true || !context.mounted) return;

    try {
      await context.read<ProdutoProvider>().excluirProduto(produto.id);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto excluído com sucesso!')),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao excluir produto: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final produtos = context.watch<ProdutoProvider>().produtos;

    final produtoAtual = produtos.cast<Produto?>().firstWhere(
      (item) => item?.id == produto.id,
      orElse: () => produto,
    )!;

    final estoqueBaixo = produtoAtual.quantidade <= produtoAtual.estoqueMinimo;

    return Scaffold(
      backgroundColor: fundoDetalhes,
      appBar: AppBar(
        backgroundColor: verdeEscuroDetalhes,
        foregroundColor: Colors.white,
        title: const Text('Detalhes do produto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 48,
                backgroundColor: const Color(0xFFA8D5A2),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  size: 50,
                  color: verdeEscuroDetalhes,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: Text(
                produtoAtual.nome,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: verdeEscuroDetalhes,
                ),
              ),
            ),

            const SizedBox(height: 25),

            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    _informacao('ID', produtoAtual.id),
                    _informacao('Categoria', produtoAtual.categoria),
                    _informacao(
                      'Descrição',
                      produtoAtual.descricao.isEmpty
                          ? 'Não informada'
                          : produtoAtual.descricao,
                    ),
                    _informacao(
                      'Quantidade',
                      produtoAtual.quantidade.toString(),
                    ),
                    _informacao(
                      'Preço',
                      'R\$ ${produtoAtual.preco.toStringAsFixed(2)}',
                    ),
                    _informacao(
                      'Estoque mínimo',
                      produtoAtual.estoqueMinimo.toString(),
                    ),
                    _informacao(
                      'Situação',
                      estoqueBaixo ? 'Estoque baixo' : 'Normal',
                      cor: estoqueBaixo
                          ? Colors.orange.shade800
                          : verdeDetalhes,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProdutoFormScreen(produto: produtoAtual),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text('Editar produto'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: verdeDetalhes,
                  foregroundColor: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () => excluirProduto(context),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Excluir produto'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _informacao(String titulo, String valor, {Color? cor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              titulo,
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              valor,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: cor ?? verdeEscuroDetalhes,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
