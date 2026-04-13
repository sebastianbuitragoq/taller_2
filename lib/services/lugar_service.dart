import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data/lugares_data.dart';
import '../models/lugar.dart';

class LugarService {
  final String baseUrl;
  final bool usarFallbackLocal;

  const LugarService({
    required this.baseUrl,
    this.usarFallbackLocal = true,
  });

  Future<List<Lugar>> obtenerLugares() async {
    try {
      final response = await http
                  .get(Uri.parse('$baseUrl/lugares'))
                  .timeout(const Duration(seconds: 3));

      if (response.statusCode != 200) {
        throw Exception('No se pudieron cargar los lugares');
      }

      final dynamic decoded = jsonDecode(response.body);

      if (decoded is! List) {
        throw Exception('La respuesta no tiene el formato esperado');
      }

      return decoded
          .map((item) => Lugar.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (!usarFallbackLocal) rethrow;

      await Future.delayed(const Duration(seconds: 1));
      return lugares;
    }
  }

  Future<Lugar> crearLugar(Lugar lugar) async {
    try{
      final response = await http
          .post(
            Uri.parse('$baseUrl/lugares'), 
            headers: {'Content-Type': 'application/json; charset=UTF-8'}, 
            body: jsonEncode(lugar.toJson()),
          ).timeout(const Duration(seconds: 3));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic decoded = jsonDecode(response.body);
        return Lugar.fromJson(decoded as Map<String, dynamic>);
      } else {
        throw Exception('No se pudo crear el lugar');
      }
    } catch (e) {
      if (!usarFallbackLocal) rethrow;
      final lugarConId = lugar.copyWith(id: lugares.length +1);
      lugares.add(lugarConId);

      print('Dummy guardado, cantidad: ${lugares.length}');
      return lugarConId;
    }
  }

  Future<Lugar> actualizarLugar(Lugar lugarEditado) async {
    try {
      final response = await http
        .put(
          Uri.parse('$baseUrl/lugares/${lugarEditado.id}'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(lugarEditado.toJson()),
        ).timeout(const Duration(seconds: 3));
    
      if (response.statusCode == 200 || response.statusCode == 204) {
          final dynamic decoded = jsonDecode(response.body);
          return Lugar.fromJson(decoded as Map<String, dynamic>);
        } else {
          throw Exception('Error en el servidor al actualizar');
        }
      } catch (e) {
        // Si falla la API, entramos al modo simulación (Persistencia Dummy)
        if (!usarFallbackLocal) rethrow;

        // 2. Buscamos el índice del lugar en nuestra lista global 'lugares'
        final index = lugares.indexWhere((l) => l.id == lugarEditado.id);

        if (index != -1) {
          // 3. Reemplazamos el objeto antiguo con el editado
          lugares[index] = lugarEditado;
          
          print('Modo Dummy: Lugar con ID ${lugarEditado.id} actualizado con éxito.');
          return lugarEditado;
        } else {
          // Si por alguna razón el ID no existe en la lista local
          throw Exception('El lugar con ID ${lugarEditado.id} no existe en la base de datos local.');
        }
      }
    }
    Future<void> eliminarLugar(int id) async {
  try {
    final response = await http
        .delete(
          Uri.parse('$baseUrl/lugares/$id'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        )
        .timeout(const Duration(seconds: 3));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('No se pudo eliminar el lugar');
    }
  } catch (e) {
    if (!usarFallbackLocal) rethrow;

    // 🔁 Modo dummy (local)
    lugares.removeWhere((l) => l.id == id);

    print('Modo Dummy: Lugar eliminado. Total: ${lugares.length}');
  }
}
  }
