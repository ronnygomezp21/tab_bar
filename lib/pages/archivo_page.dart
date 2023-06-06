import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ArchivoPage extends StatefulWidget {
  const ArchivoPage({super.key});

  @override
  State<ArchivoPage> createState() => _ArchivoPageState();
}

class _ArchivoPageState extends State<ArchivoPage> {
  String url_launcher =
      'https://www.kindacode.com/wp-content/uploads/2021/07/test.pdf';

  @override
  Widget build(BuildContext context) {
    Future<void> launchInWebViewOrVC(Uri url) async {
      if (!await launchUrl(
        url,
        mode: LaunchMode.inAppWebView,
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

    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.archive),
          title: Text('Archivo $index'),
          subtitle: Text('Subtitulo $index'),
          trailing: const Icon(Icons.keyboard_arrow_right),
          //  onTap: () => setState(
          //   () {
          //     launchInWebViewOrVC(
          //       Uri.parse(
          //           "https://docs.google.com/gview?embedded=true&url=$url_launcher"),
          //     );
          //   },
          // ),
          onTap: () => launchInWebViewOrVC(
            Uri.parse(
                "https://docs.google.com/gview?embedded=true&url=$url_launcher"),
          ),
        );
      },
    );
  }
}
