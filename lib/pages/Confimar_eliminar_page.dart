import 'package:flutter/material.dart';
import '../models/lugar.dart';

class ConfirmarEliminarPage extends StatelessWidget {
  final Lugar lugar;

  const ConfirmarEliminarPage({super.key, required this.lugar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmar eliminación'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.red,
              size: 80,
            ),
            const SizedBox(height: 24),

            Text(
              '¿Eliminar este lugar?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),

            Text(
              lugar.nombre,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Esta acción no se puede deshacer.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            // BOTÓN ELIMINAR
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                icon: const Icon(Icons.delete),
                label: const Text('Sí, eliminar'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // BOTÓN CANCELAR
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('Cancelar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}