import 'package:flutter/material.dart';
import '../models/lugar.dart';

class FormularioLugarPage extends StatefulWidget {
  final Lugar? lugarParaEditar;

  const FormularioLugarPage({super.key, this.lugarParaEditar});

  @override
  State<FormularioLugarPage> createState() => _FormularioLugarPageState();
}

class _FormularioLugarPageState extends State<FormularioLugarPage> {
  // 1. La clave global para el formulario (necesaria para validación)
  final _formKey = GlobalKey<FormState>();

  // 2. Controladores para capturar el texto de cada campo
  final _nombreCtrl = TextEditingController();
  final _descCortaCtrl = TextEditingController();
  final _descLargaCtrl = TextEditingController();
  final _categoriaCtrl = TextEditingController();
  final _imageUrlCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.lugarParaEditar != null) {
      _nombreCtrl.text = widget.lugarParaEditar!.nombre;
      _descCortaCtrl.text = widget.lugarParaEditar!.descripcionCorta;
      _descLargaCtrl.text = widget.lugarParaEditar!.descripcionLarga;
      _categoriaCtrl.text = widget.lugarParaEditar!.categoria;
      _imageUrlCtrl.text = widget.lugarParaEditar!.imagen;
      }
  }

  @override
  void dispose() {
    // Importante: Limpiar controladores para evitar fugas de memoria
    _nombreCtrl.dispose();
    _descCortaCtrl.dispose();
    _descLargaCtrl.dispose();
    _categoriaCtrl.dispose();
    _imageUrlCtrl.dispose();
    super.dispose();
  }

  void _enviarFormulario() {
    // 3. Validar el formulario
    if (_formKey.currentState!.validate()) {
      // Si es válido, creamos el objeto Lugar (sin ID, el servicio se lo pondrá)
      final nuevoLugar = Lugar(
        id: widget.lugarParaEditar?.id ?? 0,
        nombre: _nombreCtrl.text,
        // Asumiendo que tu modelo tiene estos campos, si no, usa 'descripcion'
        descripcionCorta: _descCortaCtrl.text, 
        descripcionLarga: _descLargaCtrl.text,
        categoria: _categoriaCtrl.text,
        imagen: _imageUrlCtrl.text.isEmpty 
            ? 'https://via.placeholder.com/150' // Imagen por defecto
            : _imageUrlCtrl.text,
      );

      // 4. Devolvemos el lugar a la pantalla anterior
      Navigator.pop(context, nuevoLugar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Lugar'),
      ),
      body: SingleChildScrollView( // Para que no choque con el teclado
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey, // Asignamos la clave
          child: Column(
            children: [
              // --- CAMPO NOMBRE ---
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nombre del Lugar *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.place),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // --- CAMPO DESCRIPCIÓN CORTA ---
              TextFormField(
                controller: _descCortaCtrl,
                decoration: const InputDecoration(
                  labelText: 'Descripción Corta *',
                  hintText: 'Un resumen rápido',
                  border: OutlineInputBorder(),
                ),
                maxLength: 50, // Límite de caracteres
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // --- CAMPO DESCRIPCIÓN LARGA ---
              TextFormField(
                controller: _descLargaCtrl,
                decoration: const InputDecoration(
                  labelText: 'Descripción Larga',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4, // Múltiples líneas
              ),
              const SizedBox(height: 20),

              // --- CAMPO CATEGORÍA ---
              TextFormField(
                controller: _categoriaCtrl,
                decoration: const InputDecoration(
                  labelText: 'Categoría (ej: Facultad, Parque)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
              ),
              const SizedBox(height: 20),

              // --- CAMPO URL IMAGEN ---
              TextFormField(
                controller: _imageUrlCtrl,
                decoration: const InputDecoration(
                  labelText: 'URL de la Imagen',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.image),
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 36),

              // --- BOTÓN GUARDAR ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  onPressed: _enviarFormulario,
                  icon: const Icon(Icons.save),
                  label: const Text('Guardar Lugar', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}