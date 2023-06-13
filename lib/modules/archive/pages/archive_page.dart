import 'dart:convert';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tab_bar/modules/pdf/pages/pdf_view_page.dart';
import 'package:tab_bar/shared/data/url.dart';
import 'package:permission_handler/permission_handler.dart';

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
        debugPrint('Directorio de descarga: ${file.path}');
        debugPrint('Documento: ${file.path.split('/').last}');
        debugPrint('Estoy en un dispositivo android');
        SnackBar snackBar = SnackBar(
          action: SnackBarAction(
            textColor: Colors.black87,
            backgroundColor: Colors.white,
            label: 'Abrir',
            onPressed: () {
              OpenFilex.open('/storage/emulated/0/Download/$fileName'
                  //type: 'application/pdf',
                  );
            },
          ),
          backgroundColor: const Color(0xff198754),
          content: Text('El archivo $fileName ha sido descargado.'),
          duration: const Duration(seconds: 3),
        );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        return downloadsDirectory;
      } else {
        return await getDownloadsDirectory();
      }
    }

    Future<void> grantPermission() async {
      var statusPermission = await Permission.manageExternalStorage.status;

      try {
        if (statusPermission.isGranted) {
          debugPrint('Permiso concedido');
          savePDF();
        }
        if (statusPermission.isDenied) {
          debugPrint('Permiso denegado');
          await Permission.manageExternalStorage.request();
        }
        if (statusPermission.isPermanentlyDenied) {
          debugPrint('Permiso denegado permanentemente');
          await Permission.manageExternalStorage.request();
        }
      } on Exception catch (e) {
        debugPrint('Error: $e');
      }
    }

    return BounceInDown(
      child: ListView.builder(
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
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  PdfViewPage(
                                      url: Url.url, title: 'Factura $index'),
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
                    onPressed: () async {
                      grantPermission();
                      // final directory = await getExternalStorageDirectory();
                      // String timestamp = DateFormat('yyyyMMdd_HHmmss_SSS')
                      //     .format(DateTime.now());

                      // final cacheFilePath = '${directory!.path}/$timestamp.txt';

                      // // Guardar datos en caché
                      // final cacheData = 'Datos en caché';
                      // final cacheFile = File(cacheFilePath);
                      // await cacheFile.writeAsString(cacheData);

                      // // Verificar tiempo de vida (por ejemplo, 24 horas)
                      // final cachedFileExists = await cacheFile.exists();
                      // if (cachedFileExists) {
                      //   final cacheStat = await cacheFile.stat();
                      //   final cacheModified = cacheStat.modified;
                      //   final currentTime = DateTime.now();
                      //   final timeDifference =
                      //       currentTime.difference(cacheModified);
                      //   final maxCacheTime = Duration(seconds: 1);
                      //   if (timeDifference.compareTo(maxCacheTime) >= 0) {
                      //     // Eliminar datos expirados de la caché
                      //     await cacheFile.delete();
                      //   } else {
                      //     // Acceder a los datos en la caché
                      //     final cachedData = await cacheFile.readAsString();
                      //     print(cachedData);
                      //   }
                      // }
                    },
                    icon: const Icon(Icons.save)),
              ],
            ),
          );
        },
      ),
    );
  }
}
