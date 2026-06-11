import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../config/app_config.dart';
import '../models/produto.dart';

class ProdutoCard extends StatelessWidget {
  final Produto produto;
  final VoidCallback? onTap;

  const ProdutoCard({super.key, required this.produto, this.onTap});

  @override
  Widget build(BuildContext context) {
    final corPrimaria = Color(int.parse(AppConfig.corPrimaria.replaceAll('#', '0xFF')));

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: produto.imagemUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: produto.imagemUrl,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        height: 120,
                        color: Colors.grey[100],
                        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      ),
                      errorWidget: (_, __, ___) => _semImagem(),
                    )
                  : _semImagem(),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produto.nome,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
                  ),
                  const SizedBox(height: 6),
                  if (produto.temPromocao) ...[
                    Text(
                      'R\$ ${produto.preco.toStringAsFixed(2).replaceAll('.', ',')}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'R\$ ${produto.precoPromocional!.toStringAsFixed(2).replaceAll('.', ',')}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: corPrimaria,
                      ),
                    ),
                  ] else
                    Text(
                      'R\$ ${produto.preco.toStringAsFixed(2).replaceAll('.', ',')}',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: corPrimaria),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _semImagem() {
    return Container(
      height: 120,
      width: double.infinity,
      color: Colors.grey[100],
      child: const Icon(Icons.medication_outlined, size: 40, color: Colors.grey),
    );
  }
}
