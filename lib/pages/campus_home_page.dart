import 'package:flutter/material.dart';
import 'package:flutter_application_test_23_feb/pages/FormularioLugarPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/lugar.dart';
import '../services/lugar_service.dart';
import '../widgets/lugar_card.dart';
import 'lugar_detail_page.dart';

class CampusHomePage extends StatefulWidget {
  const CampusHomePage({super.key});

  @override
  State<CampusHomePage> createState() => _CampusHomePageState();
}

class _CampusHomePageState extends State<CampusHomePage> {
  final Set<int> _favoritos = {};

  late final LugarService _service;
  late Future<List<Lugar>> _futureLugares;

  @override
  void initState() {
    super.initState();

    _service = const LugarService(
      baseUrl: 'https://dummyjso.com/c/2870-3197-4f39-9a26',
      usarFallbackLocal: true,
    );

    _futureLugares = _service.obtenerLugares();
    _cargarFavoritos();
  }

  Future<void> _cargarFavoritos() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList('favoritos') ?? [];

    setState(() {
      _favoritos
        ..clear()
        ..addAll(ids.map(int.parse));
    });
  }

  Future<void> _guardarFavoritos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'favoritos',
      _favoritos.map((id) => id.toString()).toList(),
    );
  }

  void _actualizarFavorito(int lugarId, bool esFavorito) {
    setState(() {
      if (esFavorito) {
        _favoritos.add(lugarId);
      } else {
        _favoritos.remove(lugarId);
      }
    });

    _guardarFavoritos();
  }

  Future<void> _recargarLugares() async {
    setState(() {
      _futureLugares = _service.obtenerLugares();
    });

    await _futureLugares;
  }

  Future<void> _crearNuevoLugar() async {
    final Lugar? lugarDesdeFormulario = await Navigator.push<Lugar>(
      context, MaterialPageRoute(builder: (context) => const FormularioLugarPage()),
    );
    
    if (lugarDesdeFormulario == null) return;

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Guardando nuevo lugar'))
    );
    try {
      await _service.crearLugar(lugarDesdeFormulario);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${lugarDesdeFormulario.nombre} añadido'),
          backgroundColor: Colors.green,
          )
        );
      }
      _recargarLugares();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lugares del Campus'),
        actions: [
          IconButton(
            onPressed: _crearNuevoLugar, icon: const Icon(Icons.add_location_alt_outlined), tooltip: 'Añadir lugar'),
        ]
      ),
      body: FutureBuilder<List<Lugar>>(
        future: _futureLugares,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 12),
                    const Text(
                      'Ocurrió un error al cargar los lugares.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () {
                        setState(() {
                          _futureLugares = _service.obtenerLugares();
                        });
                      },
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          final lugares = snapshot.data ?? [];

          if (lugares.isEmpty) {
            return const Center(
              child: Text('No hay lugares disponibles.'),
            );
          }

          return RefreshIndicator(
            onRefresh: _recargarLugares,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: lugares.length,
              itemBuilder: (context, index) {
                final lugar = lugares[index];
                final esFavorito = _favoritos.contains(lugar.id);

                return LugarCard(
                  lugar: lugar,
                  esFavorito: esFavorito,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LugarDetailPage(
                          lugar: lugar,
                          baseUrl: _service.baseUrl,
                          esFavoritoInicial: esFavorito,
                          onFavoritoChanged: (nuevoValor) {
                            _actualizarFavorito(lugar.id, nuevoValor);
                          },
                        ),
                      ),
                    );
                    _recargarLugares();
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
