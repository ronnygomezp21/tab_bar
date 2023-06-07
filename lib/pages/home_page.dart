import 'package:flutter/material.dart';
import 'package:tab_bar/pages/accion_page.dart';
import 'package:tab_bar/pages/archivo_page.dart';
import 'package:tab_bar/pages/detalle_page.dart';
import 'package:tab_bar/pages/pdf_view_page.dart';
import 'package:tab_bar/pages/trazabilidad_page.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    String urlPdf =
        'https://www.kindacode.com/wp-content/uploads/2021/07/test.pdf';
    Future<void> launchInWebViewOrVC(Uri url) async {
      if (!await launchUrl(
        url,
        mode: LaunchMode.platformDefault,
        //mode: LaunchMode.externalApplication,
        //mode: LaunchMode.externalNonBrowserApplication,
        //mode: LaunchMode.platformDefault,
        webViewConfiguration: const WebViewConfiguration(
            headers: <String, String>{'my_header_key': 'my_header_value'}),
      )) {
        debugPrint('opening Google docs with PDF url = $url');
        throw Exception('Could not launch $url');
      }
    }

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
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
            DetallePage(),
            ArchivoPage(),
            AccionPage(),
            TrazabilidadPage(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: SizedBox(
                    width: double.maxFinite,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.archive),
                          title: const Text('Archivo'),
                          subtitle: const Text('Subtitulo'),
                          trailing: const Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PdfViewPage(
                                  url: urlPdf,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  // content: ListTile(
                  //   leading: const Icon(Icons.archive),
                  //   title: const Text('Archivo'),
                  //   subtitle: const Text('Subtitulo'),
                  //   trailing: const Icon(Icons.keyboard_arrow_right),
                  //   onTap: () => launchInWebViewOrVC(
                  //     Uri.parse(
                  //         "https://docs.google.com/gview?embedded=true&url=$urlPdf"),
                  //   ),
                  // ),
                  //scrollable: true,
                  title: const Text('data'),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Salir'),
                    )
                  ],
                );
              },
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
