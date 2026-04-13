import 'package:flutter/material.dart';

import '../models/lugar.dart';

class LugarCard extends StatelessWidget {
  final Lugar lugar;
  final bool esFavorito;
  final VoidCallback onTap;

  const LugarCard({
    super.key,
    required this.lugar,
    required this.esFavorito,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              lugar.imagen,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 180,
                  width: double.infinity,
                  alignment: Alignment.center,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image_not_supported, size: 40),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      lugar.nombre,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(
                    esFavorito ? Icons.star : Icons.star_border,
                    color: esFavorito ? Colors.amber : Colors.grey,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                lugar.categoria,
                style: TextStyle(
                  color: Colors.indigo.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Text(lugar.descripcionCorta),
            ),
          ],
        ),
      ),
    );
  }
}