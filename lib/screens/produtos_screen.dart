import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/produto_provider.dart';
import 'produto_detalhes_screen.dart';

const verdeLista = Color(0xFF27834B);
const verdeEscuroLista = Color(0xFF174D32);
const fundoLista = Color(0xFFF2F7F0);

class ProdutosScreen extends StatefulWidget {
  const ProdutosScreen({super.key});

  @override
  State<ProdutosScreen> createState() => _ProdutosScreenState();
}

class _ProdutosScreenState extends State<ProdutosScreen> {
  final TextEditingController _buscaController = TextEditingController();
  String busca = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProdutoProvider>().carregarProdutos();
    });
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProdutoProvider>();

    final produtos = provider.produtos.where((produto) {
      return produto.nome.toLowerCase().contains(busca.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: fundoLista,
      appBar: AppBar(
        backgroundColor: verdeEscuroLista,
        foregroundColor: Colors.white,
        title: const Text('Meu estoque'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _buscaController,
              decoration: InputDecoration(
                hintText: 'Buscar produto...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (valor) {
                setState(() {
                  busca = valor;
                });
              },
            ),

            const SizedBox(height: 18),

            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: verdeLista),
                    )
                  : provider.erro != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 50,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 12),
                          Text(provider.erro!),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              provider.carregarProdutos();
                            },
                            child: const Text('Tentar novamente'),
                          ),
                        ],
                      ),
                    )
                  : produtos.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum produto encontrado.',
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                    )
                  : ListView.separated(
                      itemCount: produtos.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final produto = produtos[index];

                        final estoqueBaixo =
                            produto.quantidade <= produto.estoqueMinimo;

                        return Card(
                          color: Colors.white,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: CircleAvatar(
                              backgroundColor: estoqueBaixo
                                  ? Colors.orange.shade100
                                  : const Color(0xFFA8D5A2),
                              child: Icon(
                                Icons.inventory_2_outlined,
                                color: estoqueBaixo
                                    ? Colors.orange.shade800
                                    : verdeLista,
                              ),
                            ),
                            title: Text(
                              produto.nome,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: verdeEscuroLista,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(produto.categoria),
                                Text('Quantidade: ${produto.quantidade}'),
                                Text(
                                  estoqueBaixo
                                      ? 'Estoque baixo'
                                      : 'Estoque normal',
                                  style: TextStyle(
                                    color: estoqueBaixo
                                        ? Colors.orange.shade800
                                        : verdeLista,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProdutoDetalhesScreen(produto: produto),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
