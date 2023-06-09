import 'package:flutter/material.dart';
import 'package:tab_bar/modules/action/pages/action_page.dart';
import 'package:tab_bar/modules/archive/pages/archive_page.dart';
import 'package:tab_bar/modules/detail/pages/detail_page.dart';
import 'package:tab_bar/modules/traceability/pages/trazabilidad_page.dart';

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
              Tab(
                text: 'Detalle',
                icon: Icon(Icons.details),
              ),
              Tab(
                text: 'Archivo',
                icon: Icon(Icons.archive),
              ),
              Tab(
                text: 'Accion',
                icon: Icon(Icons.accessibility),
              ),
              Tab(
                text: 'Trazabilidad',
                icon: Icon(Icons.track_changes),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            DetailPage(),
            ArchivePage(),
            ActionPage(),
            TraceabilityPage(),
          ],
        ),
      ),
    );
  }
}
