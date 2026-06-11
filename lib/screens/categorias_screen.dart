import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../models/categoria.dart';
import '../models/produto.dart';
import '../services/api_service.dart';
import '../widgets/produto_card.dart';

class CategoriasScreen extends StatefulWidget {
  const CategoriasScreen({super.key});

  @override
  State<CategoriasScreen> createState() => _CategoriasScreenState();
}

class _CategoriasScreenState extends State<CategoriasScreen> {
  List<Categoria> _categorias = [];
  List<Produto> _produtos = [];
  Categoria? _selecionada;
  bool _carregando = true;
  bool _carregandoProdutos = false;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final cats = await ApiService.getCategorias();
    if (mounted) setState(() { _categorias = cats; _carregando = false; });
    if (cats.isNotEmpty) _selecionarCategoria(cats.first);
  }

  Future<void> _selecionarCategoria(Categoria cat) async {
    setState(() { _selecionada = cat; _carregandoProdutos = true; });
    final prods = await ApiService.getProdutos(categoria: cat.id);
    if (mounted) setState(() { _produtos = prods; _carregandoProdutos = false; });
  }

  @override
  Widget build(BuildContext context) {
    final corPrimaria = Color(int.parse(AppConfig.corPrimaria.replaceAll('#', '0xFF')));

    if (_carregando) return const Center(child: CircularProgressIndicator());

    return Row(
      children: [
        Container(
          width: 120,
          color: Colors.white,
          child: ListView.builder(
            itemCount: _categorias.length,
            itemBuilder: (_, i) {
              final cat = _categorias[i];
              final ativo = _selecionada?.id == cat.id;
              return GestureDetector(
                onTap: () => _selecionarCategoria(cat),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                  decoration: BoxDecoration(
                    color: ativo ? corPrimaria.withOpacity(0.08) : Colors.transparent,
                    border: Border(left: BorderSide(color: ativo ? corPrimaria : Colors.transparent, width: 3)),
                  ),
                  child: Text(
                    cat.nome,
                    style: TextStyle(fontSize: 12, fontWeight: ativo ? FontWeight.bold : FontWeight.normal, color: ativo ? corPrimaria : Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
        ),
        Container(width: 1, color: Colors.grey[200]),
        Expanded(
          child: _carregandoProdutos
              ? const Center(child: CircularProgressIndicator())
              : _produtos.isEmpty
                  ? const Center(child: Text('Nenhum produto nesta categoria', style: TextStyle(color: Colors.grey)))
                  : GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.68,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _produtos.length,
                      itemBuilder: (_, i) => ProdutoCard(produto: _produtos[i]),
                    ),
        ),
      ],
    );
  }
}
