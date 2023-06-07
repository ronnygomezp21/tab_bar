import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class PdfViewPage extends StatefulWidget {
  const PdfViewPage({super.key, required this.url});

  final String url;

  @override
  State<PdfViewPage> createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  String? localPath;

  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  Future<String> loadPDF() async {
    var response = await http.get(Uri.parse(widget.url));
    var dir = await getApplicationDocumentsDirectory();

    // Generar un nombre de archivo único basado en la fecha y hora actual
    String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    String fileName = 'data_$timestamp.pdf';

    File file = File("${dir.path}/$fileName");
    file.writeAsBytesSync(response.bodyBytes, flush: true);
    return file.path;
  }

  Future<void> launchInWebViewOrVC(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
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

  Future<void> savePDF() async {
    var response = await http.get(Uri.parse(widget.url));
    var status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      await Permission.manageExternalStorage.request();
      status = await Permission.manageExternalStorage.status;
      //return;
    }
    if (status.isGranted) {
      var dir = await getExternalStorageDirectory();
      if (dir != null) {
        String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
        String fileName = 'data_$timestamp.pdf';

        File file = File("${dir.path}/$fileName");
        file.writeAsBytesSync(response.bodyBytes, flush: true);
        // File file = File("${dir.path}/data.pdf");
        // await file.writeAsBytes(response.bodyBytes, flush: true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Archivo PDF guardado exitosamente')),
        );
      }
      print('permiso concedido');
      print(dir);
      if (status.isDenied) {
        print('permiso denegado');
      }
    }
    // var response = await http.get(Uri.parse(widget.url));
    // var status = await Permission.storage.status;
    // if (!status.isGranted) {
    //   await Permission.storage.request();
    //   status = await Permission
    //       .storage.status; // Verifica nuevamente el estado del permiso
    // }
    // if (status.isDenied) {
    //   await Permission.storage.request();
    //   status = await Permission.storage.status;
    // }
    // if (status.isGranted) {
    //   Directory? dir = await getDownloadsDirectory();
    //   if (dir != null) {
    //     File file = File("${dir.path}/data.pdf");
    //     await file.writeAsBytes(response.bodyBytes, flush: true);
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('Archivo PDF guardado exitosamente')),
    //     );
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //           content: Text('No se pudo obtener la ubicación de descarga')),
    //     );
    //   }
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('No se otorgó el permiso de almacenamiento')),
    //   );
    // }
  }

  // Future<void> savePDF() async {
  //   //var status = await Permission.storage.status;
  //   PermissionStatus status = await Permission.storage.status;
  //   if (status.isDenied) {
  //     // El usuario negó el acceso al almacenamiento
  //     // Puedes mostrar un mensaje o realizar alguna acción adicional
  //     debugPrint('Permiso denegado');
  //     // Solicitar permiso de almacenamiento nuevamente
  //     status = await Permission.storage.request();

  //     if (status.isDenied) {
  //       debugPrint('Permiso denegado el acceso de nuevo');
  //       status = await Permission.storage.request();
  //       // El usuario volvió a negar el acceso al almacenamiento
  //       // Puedes mostrar un mensaje o realizar alguna acción adicional
  //     } else if (status.isPermanentlyDenied) {
  //       // El usuario negó permanentemente el acceso al almacenamiento
  //       // Puedes mostrar un mensaje y redirigirlo a la configuración de la aplicación
  //       await openAppSettings();
  //     }
  //   } else if (status.isPermanentlyDenied) {
  //     // El usuario negó permanentemente el acceso al almacenamiento
  //     // Puedes mostrar un mensaje y redirigirlo a la configuración de la aplicación
  //     await openAppSettings();
  //   } else if (status.isGranted) {
  //     var response = await http.get(Uri.parse(widget.url));
  //     var dir = await getDownloadsDirectory();
  //     if (dir != null) {
  //       File file = File("${dir.path}/data.pdf");
  //       await file.writeAsBytes(response.bodyBytes, flush: true);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Archivo PDF guardado exitosamente')),
  //       );
  //     }
  //     // El usuario concedió el permiso de almacenamiento
  //     // Puedes realizar las acciones necesarias para acceder al almacenamiento
  //   }
  //   // if (!status.isGranted) {
  //   //   await Permission.storage.request();
  //   // }
  //   // if (status.isDenied) {
  //   //   await Permission.storage.request();
  //   // }
  //   // if (status.isGranted) {
  //   //   var dir = await getDownloadsDirectory();
  //   //   if (dir != null) {
  //   //     File file = File("${dir.path}/data.pdf");
  //   //     await file.writeAsBytes(response.bodyBytes, flush: true);
  //   //     ScaffoldMessenger.of(context).showSnackBar(
  //   //       SnackBar(content: Text('Archivo PDF guardado exitosamente')),
  //   //     );
  //   //   }
  //   // }
  // }

  @override
  void initState() {
    super.initState();
    loadPDF().then((value) {
      setState(() {
        localPath = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('PDF View'),
      ),
      body: localPath != null
          ? PDFView(
              filePath: localPath!,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: true,
              pageSnap: true,
              defaultPage: currentPage!,
              fitPolicy: FitPolicy.BOTH,
              preventLinkNavigation:
                  false, // if set to true the link is handled in flutter
              onRender: (_pages) {
                setState(() {
                  pages = _pages;
                  isReady = true;
                });
              },
              onError: (error) {
                setState(() {
                  errorMessage = error.toString();
                });
                print(error.toString());
              },
              onPageError: (page, error) {
                setState(() {
                  errorMessage = '$page: ${error.toString()}';
                });
                print('$page: ${error.toString()}');
              },
              onViewCreated: (PDFViewController pdfViewController) {
                _controller.complete(pdfViewController);
              },
              onLinkHandler: (String? uri) {
                print('goto uri: $uri');
              },
              onPageChanged: (int? page, int? total) {
                print('page change: $page/$total');
                setState(() {
                  currentPage = page;
                });
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      bottomNavigationBar: BottomAppBar(
        //height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.first_page),
              onPressed: () {
                final controller = _controller.future;
                controller.then((value) => value.setPage(0));
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                final controller = _controller.future;
                controller.then((value) => value.setPage(currentPage! - 1));
              },
            ),
            Text('${currentPage! + 1} / $pages'),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                final controller = _controller.future;
                controller.then((value) => value.setPage(currentPage! + 1));
              },
            ),
            IconButton(
              icon: const Icon(Icons.last_page),
              onPressed: () {
                final controller = _controller.future;
                controller.then((value) => value.setPage(pages! - 1));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: savePDF,
        //   savePDF();
        //   // launchInWebViewOrVC(
        //   //   Uri.parse(widget.url),
        //   // );
        // },
        child: const Icon(Icons.save),
      ),
    );
  }
}
