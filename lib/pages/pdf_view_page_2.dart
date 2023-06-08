import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class PdfViewPage2 extends StatefulWidget {
  const PdfViewPage2({super.key, required this.url});

  final String url;

  @override
  State<PdfViewPage2> createState() => _PdfViewPageState2();
}

class _PdfViewPageState2 extends State<PdfViewPage2> {
  String? localPath;

  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  Future<Directory?> getDownloadsDirectory() async {
    if (Platform.isAndroid) {
      var bytes = base64Decode(widget.url);
      String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      String fileName = '$timestamp.pdf';
      Directory downloadsDirectory = Directory('/storage/emulated/0/Download');
      File file = File("${downloadsDirectory.path}/$fileName");
      await file.writeAsBytes(bytes.buffer.asUint8List());
      print(file.path);
      print('android');
      return downloadsDirectory;
    } else {
      return await getDownloadsDirectory();
    }
  }

  Future<String> loadPDF() async {
    var bytes = base64Decode(widget.url);
    //final output = await getDownloadsDirectory();
    //es un espacio de almacenamiento privado para la propia aplicación
    //final output = await getApplicationDocumentsDirectory();
    // proporciona la ruta al directorio temporal de la plataforma, que es útil para almacenar archivos temporales necesarios durante la ejecución de la aplicación Flutter
    final output = await getTemporaryDirectory();
    //proporciona la ruta al directorio de almacenamiento externo de la plataforma, que es útil para almacenar archivos que deben persistir incluso después de que se desinstale la aplicación Flutter
    //final output = await getExternalStorageDirectory();
    String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    String fileName = '$timestamp.pdf';
    File file = File("${output.path}/$fileName");
    await file.writeAsBytes(bytes.buffer.asUint8List());
    return file.path;
  }

  Future<void> launchInWebViewOrVC(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
      webViewConfiguration: const WebViewConfiguration(
          headers: <String, String>{'my_header_key': 'my_header_value'}),
    )) {
      debugPrint('opening Google docs with PDF url = $url');
      throw Exception('Could not launch $url');
    }
  }

  Future<void> requestStoragePermission() async {
    final PermissionStatus status =
        await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      var response = await http.get(Uri.parse(widget.url));
      Directory? dir = await getExternalStorageDirectory();
      if (dir != null) {
        String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
        String fileName = '$timestamp.pdf';

        File file = File("${dir.path}/$fileName");
        file.writeAsBytesSync(response.bodyBytes, flush: true);
        print(fileName);
        print(dir);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Archivo PDF guardado exitosamente')),
        );
      } else {
        await Permission.manageExternalStorage.request();
        print('denid');
      }
    }
  }

  Future<void> savePDF() async {
    var response = await http.get(Uri.parse(widget.url));

    var statusStorage = await Permission.storage.status;
    if (!statusStorage.isGranted) {
      await Permission.storage.request();

      await Permission.storage.request();
      statusStorage = await Permission
          .storage.status; // Verifica nuevamente el estado del permiso
    }
    if (statusStorage.isGranted) {
      Directory? dir = await getExternalStorageDirectory();
      if (dir != null) {
        String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
        String fileName = '$timestamp.pdf';

        File file = File("${dir.path}/$fileName");
        file.writeAsBytesSync(response.bodyBytes, flush: true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Archivo PDF guardado exitosamente')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('No se pudo obtener la ubicación de descarga')),
        );
      }
    } else {
      await Permission.storage.request();

      await Permission.storage.request();
      statusStorage = await Permission.storage.status; // Verifica nuevamente
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se otorgó el permiso de almacenamiento')),
      );
    }
  }
  // Future<void> guardarPDF() async {
  //   var response = await http.get(Uri.parse(widget.url));
  //   var status = await Permission.storage.status;
  //   if (!status.isGranted) {
  //     await Permission.storage.request();
  //   }
  //   if (status.isDenied) {
  //     print('permiso denegado');
  //     openAppSettings();
  //   }
  //   if (status.isGranted) {
  //     var dir = await getExternalStorageDirectory();
  //     if (dir != null) {
  //       File file = File("${dir.path}/data.pdf");
  //       await file.writeAsBytes(response.bodyBytes, flush: true);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Archivo PDF guardado exitosamente')),
  //       );
  //     }
  //   }
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
        onPressed: () async {
          //checkPermission();
          //requestPermission(Permission.storage);
          //guardarPDF,
          //savePDF();
          //requestStoragePermission();
          // launchInWebViewOrVC(
          //   Uri.parse(widget.url),
          // );
          // final downloadsDirectory = await getExternalStorageDirectory();
          // print(downloadsDirectory!.path);
          //final taskId = await FlutterDownloader.enqueue(
          /*-----------------------------------------------------
          si vale
          var bytes = base64Decode(widget.url);
          final output = await getExternalStorageDirectory();
          String timestamp =
              DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
          String fileName = '$timestamp.pdf';
          File file = File("${output!.path}/$fileName");
          await file.writeAsBytes(bytes.buffer.asUint8List());
          //await OpenFilex.open(file.path);
          print(file.path);
          -----------------------------------------------------*/
          getDownloadsDirectory();
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
