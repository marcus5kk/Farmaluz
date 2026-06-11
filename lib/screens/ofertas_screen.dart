import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../models/produto.dart';
import '../services/api_service.dart';
import '../widgets/produto_card.dart';

class OfertasScreen extends StatefulWidget {
  const OfertasScreen({super.key});

  @override
  State<OfertasScreen> createState() => _OfertasScreenState();
}

class _OfertasScreenState extends State<OfertasScreen> {
  List<Produto> _ofertas = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final res = await ApiService.getProdutos(ofertas: true);
    if (mounted) setState(() { _ofertas = res; _carregando = false; });
  }

  @override
  Widget build(BuildContext context) {
    final corPrimaria = Color(int.parse(AppConfig.corPrimaria.replaceAll('#', '0xFF')));

    if (_carregando) return const Center(child: CircularProgressIndicator());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          color: corPrimaria,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🔥 Ofertas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              Text('Produtos com preço especial para você!', style: TextStyle(fontSize: 12, color: Colors.white70)),
            ],
          ),
        ),
        Expanded(
          child: _ofertas.isEmpty
              ? const Center(child: Text('Nenhuma oferta disponível no momento.', style: TextStyle(color: Colors.grey)))
              : RefreshIndicator(
                  onRefresh: _carregar,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.68,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _ofertas.length,
                    itemBuilder: (_, i) => ProdutoCard(produto: _ofertas[i]),
                  ),
                ),
        ),
      ],
    );
  }
}
