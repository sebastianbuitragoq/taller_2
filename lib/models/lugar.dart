class Lugar {
  final int id;
  final String nombre;
  final String categoria;
  final String descripcionCorta;
  final String descripcionLarga;
  final String imagen;

  const Lugar({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.descripcionCorta,
    required this.descripcionLarga,
    required this.imagen,
  });

  Lugar copyWith({int? id, String? nombre, String? categoria, String? descripcionCorta, String? descripcionLarga, String? imagen, }) {
    return Lugar(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      categoria: categoria ?? this.categoria,
      descripcionCorta: descripcionCorta ?? this.descripcionCorta,
      descripcionLarga: descripcionLarga ?? this.descripcionLarga,
      imagen: imagen ?? this.imagen
    );
  }

  factory Lugar.fromJson(Map<String, dynamic> json) {
    return Lugar(
      id: json['id'] as int,
      nombre: (json['nombre'] ?? '') as String,
      categoria: (json['categoria'] ?? '') as String,
      descripcionCorta:
          (json['descripcion_corta'] ?? json['descripcionCorta'] ?? '')
              as String,
      descripcionLarga:
          (json['descripcion_larga'] ?? json['descripcionLarga'] ?? '')
              as String,
      imagen: (json['imagen'] ?? json['imagen_url'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'categoria': categoria,
      'descripcion_corta': descripcionCorta,
      'descripcion_larga': descripcionLarga,
      'imagen': imagen,
    };
  }
}