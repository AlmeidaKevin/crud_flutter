import 'package:flutter/material.dart';

import '../models/videojuego.dart';

class DetailPage extends StatelessWidget {
  final Videojuego videojuego;

  const DetailPage({
    super.key,
    required this.videojuego,
  });

  Widget _imagenDetalle() {
    if (videojuego.imagen.isEmpty) {
      return Container(
        height: 240,
        width: double.infinity,
        color: Colors.deepPurple.shade100,
        child: Icon(Icons.videogame_asset, size: 90, color: Colors.deepPurple.shade300),
      );
    }

    return Image.network(
      videojuego.imagen,
      height: 240,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) {
        return Container(
          height: 240,
          width: double.infinity,
          color: Colors.grey.shade200,
          child: Icon(Icons.broken_image, size: 90, color: Colors.grey.shade400),
        );
      },
    );
  }

  Widget _infoCard(BuildContext context, {required List<Widget> children}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _fila(IconData icon, String label, String valor, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade500,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  valor,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F3F9),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: Colors.deepPurple.shade700,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: _imagenDetalle(),
              titlePadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              title: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.45),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  videojuego.titulo,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                // Title card
                _infoCard(context, children: [
                  Text(
                    videojuego.titulo,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A2E),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.deepPurple.shade100),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.gamepad_outlined, size: 14, color: Colors.deepPurple.shade600),
                        const SizedBox(width: 5),
                        Text(
                          videojuego.plataforma,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.deepPurple.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
                // Info card
                _infoCard(context, children: [
                  Text(
                    'DETALLES',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey.shade400,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _fila(Icons.attach_money, 'PRECIO', '\$${videojuego.precio.toStringAsFixed(2)}', Colors.green.shade600),
                  _fila(
                    Icons.inventory_2_outlined,
                    'STOCK',
                    '${videojuego.stock} unidades',
                    videojuego.stock > 0 ? Colors.blue.shade600 : Colors.red.shade600,
                  ),
                ]),
                // Description card
                if (videojuego.descripcion.isNotEmpty)
                  _infoCard(context, children: [
                    Text(
                      'DESCRIPCIÓN',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey.shade400,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      videojuego.descripcion,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        height: 1.6,
                      ),
                    ),
                  ]),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}