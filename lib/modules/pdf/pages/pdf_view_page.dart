import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:tab_bar/modules/archive/pages/archive_page.dart';
import 'package:tab_bar/modules/detail/pages/detail_page.dart';
import 'package:tab_bar/modules/home/pages/home_page.dart';

class PdfViewPage extends StatefulWidget {
  const PdfViewPage({super.key, required this.url, required this.title});

  final String url;
  final String title;

  @override
  State<PdfViewPage> createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  String? localPath;
  List<int>? pageList;
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  Future<String> loadPDF() async {
    try {
      var bytes = base64Decode(widget.url);
      final output = await getTemporaryDirectory();
      String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      String fileName = '$timestamp.pdf';
      File file = File("${output.path}/$fileName");
      await file.writeAsBytes(bytes.buffer.asUint8List());
      return file.path;
    } on Exception catch (e) {
      throw Exception('Error al cargar el archivo: $e');
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
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        centerTitle: true,
        title: Text(widget.title),
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
              preventLinkNavigation: false,
              onRender: (_pages) {
                setState(() {
                  pages = _pages;
                  isReady = true;
                  pageList = List<int>.generate(_pages!, (index) => index + 1);
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
        height: 60,
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
            // DropdownButton<int>(
            //   value: currentPage! + 1,
            //   items: pageList?.map((page) {
            //     return DropdownMenuItem<int>(
            //       value: page,
            //       child: Text('$page'),
            //     );
            //   }).toList(),
            //   onChanged: (int? selectedPage) {
            //     final controller = _controller.future;
            //     controller.then((value) => value.setPage(selectedPage! - 1));
            //   },
            // ),
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
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(bottom: 635),
      //   child: FloatingActionButton(
      //     backgroundColor: const Color.fromARGB(25, 0, 0, 0),
      //     shape:
      //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      //     elevation: 0,
      //     onPressed: null,
      //     child: Center(
      //         child: Text(
      //       '${currentPage! + 1} / $pages',
      //       style: const TextStyle(fontSize: 10),
      //     )),
      //   ),
      // ),
    );
  }
}
