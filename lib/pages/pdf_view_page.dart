import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

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

  Future<void> savePDF() async {
    var response = await http.get(Uri.parse(widget.url));
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if (status.isGranted) {
      var dir = await getExternalStorageDirectory();
      if (dir != null) {
        File file = File("${dir.path}/data.pdf");
        await file.writeAsBytes(response.bodyBytes, flush: true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Archivo PDF guardado exitosamente')),
        );
      }
    }
  }

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
        onPressed: () {
          savePDF();
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
