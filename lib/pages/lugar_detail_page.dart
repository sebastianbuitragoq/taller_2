import 'package:flutter/material.dart';
import 'package:flutter_application_test_23_feb/services/lugar_service.dart';
import 'Confimar_eliminar_page.dart';
import '../models/lugar.dart';
import 'FormularioLugarPage.dart';

class LugarDetailPage extends StatefulWidget {
  final Lugar lugar;
  final bool esFavoritoInicial;
  final ValueChanged<bool> onFavoritoChanged;
  final String baseUrl;

  const LugarDetailPage({
    super.key,
    required this.lugar,
    required this.esFavoritoInicial,
    required this.onFavoritoChanged,
    required this.baseUrl
  });

  @override
  State<LugarDetailPage> createState() => _LugarDetailPageState();
}

class _LugarDetailPageState extends State<LugarDetailPage> {
  late bool _esFavorito;
  late Lugar _lugarActual;
  
  late final LugarService _lugarService;

  @override
  void initState() {
    super.initState();
    _esFavorito = widget.esFavoritoInicial;
    _lugarActual = widget.lugar;

    _lugarService = LugarService(baseUrl: widget.baseUrl);
  }

  void _toggleFavorito() {
    setState(() {
      _esFavorito = !_esFavorito;
    });

    widget.onFavoritoChanged(_esFavorito);
  }

  Future<void> _abrirFormularioEdicion(BuildContext context) async {
    final lugarEditado = await Navigator.push<Lugar>(
      context,
      MaterialPageRoute(
        builder: (context) => FormularioLugarPage(lugarParaEditar: _lugarActual)
      ),  
    );
    if (lugarEditado != null) {
      try {
        final lugarActualizado = await _lugarService.actualizarLugar(lugarEditado);
        setState(() {
        _lugarActual = lugarActualizado;
      });

      if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lugar actualizado correctamente')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al actualizar: $e')),
          );
        }
      }
    }
  }
  Future<void> _abrirEliminar(BuildContext context) async {
    final confirmado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ConfirmarEliminarPage(
          lugar: _lugarActual,
        ),
      ),
    );

    if (confirmado == true) {
      try {
        await _lugarService.eliminarLugar(_lugarActual.id);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lugar eliminado correctamente')),
          );

          // Volver a la pantalla anterior indicando eliminación
          Navigator.pop(context, 'eliminado');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al eliminar: $e')),
          );
        }
      }
    }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_lugarActual.nombre),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Editar lugar',
            onPressed: () => _abrirFormularioEdicion(context),
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            tooltip: 'Eliminar lugar',
            onPressed: () => _abrirEliminar(context),
        ),
          IconButton(
            onPressed: _toggleFavorito,
            icon: Icon(
              _esFavorito ? Icons.star : Icons.star_border,
              color: _esFavorito ? Colors.amber : null,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              _lugarActual.imagen,
              width: double.infinity,
              height: 240,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 240,
                  alignment: Alignment.center,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image_not_supported, size: 48),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _lugarActual.nombre,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  IconButton(
                    onPressed: _toggleFavorito,
                    icon: Icon(
                      _esFavorito ? Icons.star : Icons.star_border,
                      color: _esFavorito ? Colors.amber : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Chip(
                label: Text(_lugarActual.categoria),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _lugarActual.descripcionLarga,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}