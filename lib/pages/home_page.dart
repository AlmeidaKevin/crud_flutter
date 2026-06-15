import 'package:flutter/material.dart';

import '../db/mongo_database.dart';
import '../models/videojuego.dart';
import 'detail_page.dart';
import 'form_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Videojuego>> videojuegosFuture;
  final Set<int> _expandedDescriptions = {};

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  void cargarDatos() {
    videojuegosFuture = MongoDatabase.getVideojuegos();
  }

  Future<void> refrescar() async {
    setState(() {
      _expandedDescriptions.clear();
      cargarDatos();
    });
  }

  Future<void> eliminar(String id) async {
    await MongoDatabase.deleteVideojuego(id);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('Registro eliminado correctamente'),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
      ),
    );

    await refrescar();
  }

  void confirmarEliminar(Videojuego item) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red.shade400),
              const SizedBox(width: 8),
              const Text('Confirmar eliminación'),
            ],
          ),
          content: Text('¿Deseas eliminar "${item.titulo}"? Esta acción no se puede deshacer.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton.tonal(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red.shade100,
                foregroundColor: Colors.red.shade800,
              ),
              onPressed: () {
                Navigator.pop(context);
                eliminar(item.id);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> abrirFormulario({Videojuego? videojuego}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FormPage(videojuego: videojuego),
      ),
    );
    await refrescar();
  }

  void abrirDetalle(Videojuego videojuego) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailPage(videojuego: videojuego),
      ),
    );
  }

  Widget _imagenVideojuego(String url) {
    if (url.isEmpty) {
      return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.videogame_asset, size: 40, color: Colors.deepPurple.shade400),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        url,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) {
          return Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.broken_image, size: 40, color: Colors.grey.shade400),
          );
        },
      ),
    );
  }

  Widget _buildGameCard(Videojuego item, int reversedIndex) {
    final bool expanded = _expandedDescriptions.contains(reversedIndex);
    final bool hasDesc = item.descripcion.isNotEmpty;
    final int descLen = item.descripcion.length;
    final bool longDesc = descLen > 80;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main row
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _imagenVideojuego(item.imagen),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title + badges row
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.titulo,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                letterSpacing: -0.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Platform chip
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.deepPurple.shade100),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.gamepad_outlined, size: 13, color: Colors.deepPurple.shade600),
                            const SizedBox(width: 4),
                            Text(
                              item.plataforma,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.deepPurple.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Price & stock row
                      Row(
                        children: [
                          _infoChip(
                            Icons.attach_money,
                            '\$${item.precio.toStringAsFixed(2)}',
                            Colors.green.shade700,
                            Colors.green.shade50,
                          ),
                          const SizedBox(width: 8),
                          _infoChip(
                            Icons.inventory_2_outlined,
                            'Stock: ${item.stock}',
                            item.stock > 0 ? Colors.blue.shade700 : Colors.red.shade700,
                            item.stock > 0 ? Colors.blue.shade50 : Colors.red.shade50,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Actions column
                Column(
                  children: [
                    _actionButton(
                      icon: Icons.remove_red_eye_outlined,
                      color: Colors.deepPurple,
                      tooltip: 'Ver detalle',
                      onTap: () => abrirDetalle(item),
                    ),
                    const SizedBox(height: 4),
                    _actionButton(
                      icon: Icons.edit_outlined,
                      color: Colors.orange,
                      tooltip: 'Editar',
                      onTap: () => abrirFormulario(videojuego: item),
                    ),
                    const SizedBox(height: 4),
                    _actionButton(
                      icon: Icons.delete_outline,
                      color: Colors.red,
                      tooltip: 'Eliminar',
                      onTap: () => confirmarEliminar(item),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Description section
          if (hasDesc) ...[
            Divider(height: 1, thickness: 1, color: Colors.grey.shade100),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.description_outlined, size: 14, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text(
                        'Descripción',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 250),
                    crossFadeState: expanded || !longDesc
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: Text(
                      '${item.descripcion.substring(0, descLen < 80 ? descLen : 80)}...',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        height: 1.45,
                      ),
                    ),
                    secondChild: Text(
                      item.descripcion,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        height: 1.45,
                      ),
                    ),
                  ),
                  if (longDesc) ...[
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (expanded) {
                            _expandedDescriptions.remove(reversedIndex);
                          } else {
                            _expandedDescriptions.add(reversedIndex);
                          }
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            expanded ? 'Ver menos' : 'Ver más',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.deepPurple.shade600,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Icon(
                            expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            size: 16,
                            color: Colors.deepPurple.shade600,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String label, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: textColor),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F3F9),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.sports_esports, size: 22),
            SizedBox(width: 8),
            Text(
              'Videojuegos',
              style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: -0.5),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: refrescar,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refrescar',
          ),
          const SizedBox(width: 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple.shade400, Colors.purple.shade300],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => abrirFormulario(),
        backgroundColor: Colors.deepPurple.shade600,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Agregar', style: TextStyle(fontWeight: FontWeight.w600)),
        elevation: 4,
      ),
      body: FutureBuilder<List<Videojuego>>(
        future: videojuegosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Colors.deepPurple.shade400),
                  const SizedBox(height: 16),
                  Text('Cargando videojuegos...', style: TextStyle(color: Colors.grey.shade500)),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                    const SizedBox(height: 16),
                    Text(
                      'Error al cargar datos',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.red.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ],
                ),
              ),
            );
          }

          // Reverse the list: latest added first
          final List<Videojuego> data = (snapshot.data ?? []).reversed.toList();

          if (data.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.videogame_asset_off, size: 80, color: Colors.deepPurple.shade200),
                  const SizedBox(height: 16),
                  Text(
                    'No hay videojuegos registrados',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Presiona + para agregar uno',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: refrescar,
            color: Colors.deepPurple,
            child: Column(
              children: [
                // Count header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${data.length} juego${data.length != 1 ? 's' : ''}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.deepPurple.shade700,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Más recientes primero',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_downward, size: 12, color: Colors.grey.shade400),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return _buildGameCard(data[index], index);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}