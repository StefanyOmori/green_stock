import 'package:flutter/material.dart';
import 'package:green_stock/model/produto.dart';
import 'package:provider/provider.dart';

import '../providers/produto_provider.dart';

const verdeForm = Color(0xFF27834B);
const verdeEscuroForm = Color(0xFF174D32);
const fundoForm = Color(0xFFF2F7F0);

class ProdutoFormScreen extends StatefulWidget {
  final Produto? produto;

  const ProdutoFormScreen({super.key, this.produto});

  @override
  State<ProdutoFormScreen> createState() => _ProdutoFormScreenState();
}

class _ProdutoFormScreenState extends State<ProdutoFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nomeController;
  late final TextEditingController _descricaoController;
  late final TextEditingController _quantidadeController;
  late final TextEditingController _precoController;
  late final TextEditingController _estoqueMinimoController;

  String? categoriaSelecionada;
  bool salvando = false;

  final List<String> categorias = [
    'Alimentos',
    'Frutas',
    'Verduras e legumes',
    'Grãos e cereais',
    'Laticínios',
    'Bebidas',
    'Outros',
  ];

  @override
  void initState() {
    super.initState();

    final produto = widget.produto;

    _nomeController = TextEditingController(text: produto?.nome ?? '');

    _descricaoController = TextEditingController(
      text: produto?.descricao ?? '',
    );

    _quantidadeController = TextEditingController(
      text: produto?.quantidade.toString() ?? '',
    );

    _precoController = TextEditingController(
      text: produto?.preco.toString() ?? '',
    );

    _estoqueMinimoController = TextEditingController(
      text: produto?.estoqueMinimo.toString() ?? '',
    );

    categoriaSelecionada = produto?.categoria;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _quantidadeController.dispose();
    _precoController.dispose();
    _estoqueMinimoController.dispose();
    super.dispose();
  }

  String? validarNumero(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Campo obrigatório';
    }

    final numero = int.tryParse(valor);

    if (numero == null || numero < 0) {
      return 'Informe um número inteiro válido';
    }

    return null;
  }

  Future<void> salvarProduto() async {
    if (!_formKey.currentState!.validate()) return;

    if (categoriaSelecionada == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Selecione uma categoria.')));
      return;
    }

    setState(() {
      salvando = true;
    });

    final produto = Produto(
      id: widget.produto?.id ?? '',
      nome: _nomeController.text.trim(),
      descricao: _descricaoController.text.trim(),
      categoria: categoriaSelecionada!,
      quantidade: int.parse(_quantidadeController.text),
      preco: double.parse(_precoController.text.replaceAll(',', '.')),
      estoqueMinimo: int.parse(_estoqueMinimoController.text),
    );

    try {
      final provider = context.read<ProdutoProvider>();

      if (widget.produto == null) {
        await provider.adicionarProduto(produto);
      } else {
        await provider.atualizarProduto(produto);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.produto == null
                ? 'Produto cadastrado com sucesso!'
                : 'Produto atualizado com sucesso!',
          ),
          backgroundColor: verdeForm,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Não foi possível salvar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          salvando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.produto != null;

    return Scaffold(
      backgroundColor: fundoForm,
      appBar: AppBar(
        backgroundColor: verdeEscuroForm,
        foregroundColor: Colors.white,
        title: Text(editando ? 'Editar produto' : 'Cadastrar produto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Informações do produto',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: verdeEscuroForm,
                ),
              ),

              const SizedBox(height: 20),

              _campo(
                'Nome do produto',
                _nomeController,
                'Digite o nome do produto',
              ),

              _campo('Descrição', _descricaoController, 'Digite uma descrição'),

              const SizedBox(height: 14),

              const Text(
                'Categoria',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                value: categoriaSelecionada,
                decoration: _decoracao('Selecione uma categoria'),
                items: categorias.map((categoria) {
                  return DropdownMenuItem(
                    value: categoria,
                    child: Text(categoria),
                  );
                }).toList(),
                onChanged: (valor) {
                  setState(() {
                    categoriaSelecionada = valor;
                  });
                },
                validator: (valor) {
                  if (valor == null) {
                    return 'Selecione uma categoria';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              _campo(
                'Quantidade',
                _quantidadeController,
                'Ex.: 20',
                teclado: TextInputType.number,
                validator: validarNumero,
              ),

              _campo(
                'Preço (R\$)',
                _precoController,
                'Ex.: 15.90',
                teclado: const TextInputType.numberWithOptions(decimal: true),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Campo obrigatório';
                  }

                  final preco = double.tryParse(valor.replaceAll(',', '.'));

                  if (preco == null || preco < 0) {
                    return 'Informe um preço válido';
                  }

                  return null;
                },
              ),

              _campo(
                'Estoque mínimo',
                _estoqueMinimoController,
                'Ex.: 5',
                teclado: TextInputType.number,
                validator: validarNumero,
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: salvando ? null : salvarProduto,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: verdeForm,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: salvando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          editando ? 'Salvar alterações' : 'Cadastrar produto',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campo(
    String titulo,
    TextEditingController controller,
    String dica, {
    TextInputType teclado = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: teclado,
            decoration: _decoracao(dica),
            validator:
                validator ??
                (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
          ),
        ],
      ),
    );
  }

  InputDecoration _decoracao(String dica) {
    return InputDecoration(
      hintText: dica,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: verdeForm),
      ),
    );
  }
}
