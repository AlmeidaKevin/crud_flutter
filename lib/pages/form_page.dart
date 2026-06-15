import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../db/mongo_database.dart';
import '../models/videojuego.dart';

class FormPage extends StatefulWidget {
  final Videojuego? videojuego;

  const FormPage({
    super.key,
    this.videojuego,
  });

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController tituloCtrl = TextEditingController();
  final TextEditingController plataformaCtrl = TextEditingController();
  final TextEditingController precioCtrl = TextEditingController();
  final TextEditingController stockCtrl = TextEditingController();
  final TextEditingController imagenCtrl = TextEditingController();
  final TextEditingController descripcionCtrl = TextEditingController();

  bool guardando = false;

  @override
  void initState() {
    super.initState();

    final Videojuego? item = widget.videojuego;

    if (item != null) {
      tituloCtrl.text = item.titulo;
      plataformaCtrl.text = item.plataforma;
      precioCtrl.text = item.precio.toString();
      stockCtrl.text = item.stock.toString();
      imagenCtrl.text = item.imagen;
      descripcionCtrl.text = item.descripcion;
    }
  }

  @override
  void dispose() {
    tituloCtrl.dispose();
    plataformaCtrl.dispose();
    precioCtrl.dispose();
    stockCtrl.dispose();
    imagenCtrl.dispose();
    descripcionCtrl.dispose();
    super.dispose();
  }

  Future<void> guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      guardando = true;
    });

    final Videojuego videojuego = Videojuego(
      mongoId: widget.videojuego?.mongoId,
      id: widget.videojuego?.id ?? const Uuid().v4(),
      titulo: tituloCtrl.text.trim(),
      plataforma: plataformaCtrl.text.trim(),
      precio: double.tryParse(precioCtrl.text.trim()) ?? 0,
      stock: int.tryParse(stockCtrl.text.trim()) ?? 0,
      imagen: imagenCtrl.text.trim(),
      descripcion: descripcionCtrl.text.trim(),
    );

    try {
      if (widget.videojuego == null) {
        await MongoDatabase.insertVideojuego(videojuego);
      } else {
        await MongoDatabase.updateVideojuego(videojuego);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(widget.videojuego == null ? 'Videojuego agregado' : 'Cambios guardados'),
            ],
          ),
          backgroundColor: Colors.deepPurple.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(12),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar: $e'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(12),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          guardando = false;
        });
      }
    }
  }

  Widget _seccionLabel(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Row(
        children: [
          Icon(icon, size: 15, color: Colors.deepPurple.shade400),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade500,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _campo(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, size: 20, color: Colors.deepPurple.shade400),
          labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.deepPurple.shade400, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade300),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
          ),
        ),
        validator: (String? value) {
          if (value == null || value.trim().isEmpty) {
            return 'Este campo es obligatorio';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool editando = widget.videojuego != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F3F9),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Icon(editando ? Icons.edit_rounded : Icons.add_circle_outline, size: 20),
            const SizedBox(width: 8),
            Text(
              editando ? 'Editar videojuego' : 'Nuevo videojuego',
              style: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: -0.3),
            ),
          ],
        ),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Información general
              Container(
                padding: const EdgeInsets.all(16),
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
                  children: [
                    _seccionLabel('INFORMACIÓN GENERAL', Icons.info_outline),
                    _campo(tituloCtrl, 'Título', Icons.title, hint: 'Ej: The Last of Us'),
                    _campo(plataformaCtrl, 'Plataforma', Icons.gamepad_outlined, hint: 'Ej: PS5, Xbox, PC'),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              // Precio y stock
              Container(
                padding: const EdgeInsets.all(16),
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
                  children: [
                    _seccionLabel('PRECIO Y STOCK', Icons.storefront_outlined),
                    _campo(
                      precioCtrl,
                      'Precio',
                      Icons.attach_money,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      hint: '0.00',
                    ),
                    _campo(
                      stockCtrl,
                      'Stock',
                      Icons.inventory_2_outlined,
                      keyboardType: TextInputType.number,
                      hint: '0',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              // Imagen y descripción
              Container(
                padding: const EdgeInsets.all(16),
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
                  children: [
                    _seccionLabel('MULTIMEDIA Y DESCRIPCIÓN', Icons.image_outlined),
                    _campo(imagenCtrl, 'URL de imagen', Icons.link, hint: 'https://...'),
                    _campo(
                      descripcionCtrl,
                      'Descripción',
                      Icons.description_outlined,
                      maxLines: 4,
                      hint: 'Escribe una descripción del videojuego...',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Botón guardar
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                  onPressed: guardando ? null : guardar,
                  icon: guardando
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save_rounded),
                  label: Text(
                    guardando ? 'Guardando...' : (editando ? 'Guardar cambios' : 'Agregar videojuego'),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}