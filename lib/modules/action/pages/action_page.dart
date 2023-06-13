import 'package:flutter/material.dart';

class ActionPage extends StatefulWidget {
  const ActionPage({super.key});

  @override
  State<ActionPage> createState() => _ActionPageState();
}

class _ActionPageState extends State<ActionPage> {
  @override
  Widget build(BuildContext context) {
    final List<String> citizenControl = [
      'Condiciones higiénicas inadecuadas',
      'Plagas (cucarachas, ratones, etc)',
      'Falta de higiene personal',
      'Productos sin RS, caducado, muestras médicas',
      'Publicidad engañosa',
      'Consulta inconsistente',
      'Dudoso/Falsificado',
      'Venta de medicamentos sin receta médica (Antibióticos, psicotrópicos, entre otros)',
      'Personas fumando en área no permitidas',
      'Tratamientos inyectables en peluquería y SPA',
      'Otros',
      'Consulta inconsistente',
      'Violación del código de lactancia materna',
      'Cigarrillos sin advertencia gráfica',
      'Farmacia de turno Cerrada'
    ];

    return Center(
      child: SizedBox(
        width: 300,
        height: 200,
        child: DropdownButtonFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
          hint: const Text('Seleccione una opción'),
          items: citizenControl.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Text(e),
            );
          }).toList(),
          onChanged: (value) {},
          isDense: true,
          isExpanded: true,
        ),
      ),
    );
  }
}
