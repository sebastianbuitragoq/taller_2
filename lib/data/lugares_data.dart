import '../models/lugar.dart';

List<Lugar> lugares = [
  Lugar(
    id: 1,
    nombre: 'Biblioteca Central',
    categoria: 'Estudio',
    descripcionCorta: 'Espacio tranquilo para lectura y trabajo.',
    descripcionLarga:
        'La Biblioteca Central ofrece salas de estudio, zonas silenciosas, acceso a material bibliográfico y espacios para trabajo individual y colaborativo. Es uno de los lugares más utilizados por estudiantes para leer, investigar y preparar proyectos.',
    imagen: 'assets/biblioteca.jpg',
  ),
  Lugar(
    id: 2,
    nombre: 'Cafetería Principal',
    categoria: 'Comida',
    descripcionCorta: 'Punto de encuentro con snacks y bebidas.',
    descripcionLarga:
        'La Cafetería Principal es un lugar de encuentro entre clases. Ofrece bebidas, snacks y comidas rápidas, además de mesas para conversar, descansar o reunirse brevemente con compañeros.',
    imagen: 'assets/cafeteria.jpg',
  ),
  Lugar(
    id: 3,
    nombre: 'Bloque de Laboratorios',
    categoria: 'Práctica',
    descripcionCorta: 'Zona para actividades técnicas y experimentos.',
    descripcionLarga:
        'El Bloque de Laboratorios concentra espacios destinados a prácticas académicas. Allí se desarrollan actividades de programación, electrónica, simulación y otras experiencias que requieren equipos especializados.',
    imagen: 'assets/laboratorio.jpg',
  ),
];