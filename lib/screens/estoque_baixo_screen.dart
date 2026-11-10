import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/produto_provider.dart';
import 'produto_detalhes_screen.dart';

const verdeBaixo = Color(0xFF27834B);
const verdeEscuroBaixo = Color(0xFF174D32);
const fundoBaixo = Color(0xFFF2F7F0);

class EstoqueBaixoScreen extends StatefulWidget {
  const EstoqueBaixoScreen({super.key});

  @override
  State<EstoqueBaixoScreen> createState() => _EstoqueBaixoScreenState();
}

class _EstoqueBaixoScreenState extends State<EstoqueBaixoScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProdutoProvider>().carregarProdutos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProdutoProvider>();

    final produtosBaixos = provider.produtos.where((produto) {
      return produto.quantidade <= produto.estoqueMinimo;
    }).toList();

    return Scaffold(
      backgroundColor: fundoBaixo,
      appBar: AppBar(
        backgroundColor: verdeEscuroBaixo,
        foregroundColor: Colors.white,
        title: const Text('Estoque baixo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.orange.shade100,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange,
                      size: 35,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Acompanhe os produtos que precisam de reposição.',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Produtos que precisam de atenção',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: verdeEscuroBaixo,
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: verdeBaixo),
                    )
                  : provider.erro != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                  : produtosBaixos.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: verdeBaixo,
                            size: 55,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Tudo certo!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: verdeEscuroBaixo,
                            ),
                          ),
                          Text('Nenhum produto com estoque baixo.'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: produtosBaixos.length,
                      itemBuilder: (context, index) {
                        final produto = produtosBaixos[index];

                        return Card(
                          color: Colors.white,
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.orange.shade100,
                              child: Icon(
                                Icons.warning_amber,
                                color: Colors.orange.shade800,
                              ),
                            ),
                            title: Text(
                              produto.nome,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Disponível: ${produto.quantidade}\n'
                              'Mínimo: ${produto.estoqueMinimo}',
                            ),
                            isThreeLine: true,
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
