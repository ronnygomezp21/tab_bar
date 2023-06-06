import 'package:flutter/material.dart';
import 'package:tab_bar/pages/accion_page.dart';
import 'package:tab_bar/pages/archivo_page.dart';
import 'package:tab_bar/pages/detalle_page.dart';
import 'package:tab_bar/pages/trazabilidad_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Detalle', icon: Icon(Icons.details)),
              Tab(text: 'Archivo', icon: Icon(Icons.archive)),
              Tab(text: 'Accion', icon: Icon(Icons.accessibility)),
              Tab(text: 'Trazabilidad', icon: Icon(Icons.track_changes)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            DetallePage(),
            ArchivoPage(),
            AccionPage(),
            TrazabilidadPage(),
          ],
        ),
      ),
    );
  }
}
