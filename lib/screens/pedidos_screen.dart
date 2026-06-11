import 'package:flutter/material.dart';
import '../config/app_config.dart';

class PedidosScreen extends StatelessWidget {
  const PedidosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final corPrimaria = Color(int.parse(AppConfig.corPrimaria.replaceAll('#', '0xFF')));

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 64, color: corPrimaria.withOpacity(0.4)),
          const SizedBox(height: 16),
          const Text('Meus Pedidos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
          const SizedBox(height: 8),
          const Text('Seus pedidos aparecerão aqui.', style: TextStyle(fontSize: 13, color: Colors.grey)),
        ],
      ),
    );
  }
}
