import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/produto_provider.dart';
import 'produtos_screen.dart';
import 'produto_form_screen.dart';
import 'estoque_baixo_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const verdeEscuro = Color(0xFF174D32);
  static const verde = Color(0xFF27834B);
  static const fundo = Color(0xFFF2F7F0);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProdutoProvider>();

    return Scaffold(
      backgroundColor: fundo,
      appBar: AppBar(
        title: const Text('GreenStock'),
        backgroundColor: verdeEscuro,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Olá!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: verdeEscuro,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Bem-vindo ao seu controle de estoque.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 25),

            const Text(
              'Resumo do estoque',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: verdeEscuro,
              ),
            ),
            const SizedBox(height: 15),

            if (provider.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (provider.erro != null)
              Column(
                children: [
                  const Text('Não foi possível carregar os indicadores.'),
                  TextButton(
                    onPressed: provider.carregarProdutos,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              )
            else
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _indicador(
                          'Produtos',
                          provider.totalProdutos.toString(),
                          Icons.inventory_2_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _indicador(
                          'Unidades',
                          provider.totalItens.toString(),
                          Icons.shopping_basket_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _indicador(
                    'Estoque baixo',
                    provider.totalEstoqueBaixo.toString(),
                    Icons.warning_amber_rounded,
                  ),
                ],
              ),

            const SizedBox(height: 25),

            const Text(
              'Acesso rápido',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: verdeEscuro,
              ),
            ),
            const SizedBox(height: 15),

            _atalho(
              context,
              'Ver produtos',
              'Consulte os produtos cadastrados',
              Icons.inventory_2_outlined,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProdutosScreen()),
                );
              },
            ),

            _atalho(
              context,
              'Cadastrar produto',
              'Adicione um novo produto ao estoque',
              Icons.add_circle_outline,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProdutoFormScreen()),
                );
              },
            ),

            _atalho(
              context,
              'Estoque baixo',
              'Confira os produtos que precisam de reposição',
              Icons.warning_amber_outlined,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EstoqueBaixoScreen()),
                );
              },
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFA8D5A2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ODS 12 - Consumo e Produção Responsáveis',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: verdeEscuro,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'O GreenStock contribui para a redução do desperdício '
                    'por meio do controle e acompanhamento do estoque.',
                    style: TextStyle(color: verdeEscuro),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _indicador(String titulo, String valor, IconData icone) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icone, color: verde, size: 28),
          const SizedBox(height: 10),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: verdeEscuro,
            ),
          ),
          Text(titulo, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _atalho(
    BuildContext context,
    String titulo,
    String descricao,
    IconData icone,
    VoidCallback onTap,
  ) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icone, color: verde, size: 30),
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(descricao),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
