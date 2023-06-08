import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tab_bar/modules/pdf/pages/pdf_view_page.dart';
import 'package:tab_bar/data/url.dart';

class ArchivePage extends StatelessWidget {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<Directory?> savePDF() async {
      var bytes = base64Decode(Url.url);
      if (Platform.isAndroid) {
        String timestamp =
            DateFormat('yyyyMMdd_HHmmss_SSS').format(DateTime.now());
        String fileName = 'Factura_$timestamp.pdf';
        Directory downloadsDirectory =
            Directory('/storage/emulated/0/Download');
        File file = File("${downloadsDirectory.path}/$fileName");
        await file.writeAsBytes(bytes.buffer.asUint8List());
        print(file.path);
        print(file.path.split('/').last);
        print('android');
        SnackBar snackBar = SnackBar(
          backgroundColor: Colors.green,
          content: Text('El archivo $fileName ha sido descargado.'),
          duration: const Duration(seconds: 3),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return downloadsDirectory;
      } else {
        return await getDownloadsDirectory();
      }
    }

    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.archive),
          title: Text('Factura $index'),
          subtitle: Text('Factura $index'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            PdfViewPage(url: Url.url, title: 'Factura $index'),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.picture_as_pdf)),
              IconButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                    savePDF();
                  },
                  // ignore: prefer_const_constructors
                  icon: Icon(Icons.save)),
            ],
          ),
        );
      },
    );
  }
}
