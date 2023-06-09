import 'package:flutter/material.dart';
import 'package:tab_bar/shared/models/detail.dart';
import 'package:tab_bar/modules/detail/services/detail_sevice.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    DetailService detailService = DetailService();

    return FutureBuilder<List<Detail>>(
      future: detailService.getDetail(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              final detail = snapshot.data![index];
              final dateIssue = detail.fechaEmision;
              DateTime dateTime = DateTime.parse(dateIssue.toString());
              String date =
                  "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nombre del documento: ${detail.nombreDocumento}'),
                        Text('Fecha de emision: $date'),
                        Text('Estado: ${detail.estado}'),
                        Text(
                            'Observaciones: ${detail.observaciones == '' ? 'Sin observaciones' : detail.observaciones}'),
                        const Text('Proceso realiza: '),
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FilledButton.icon(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          const Color.fromARGB(20, 0, 0, 0)),
                                ),
                                onPressed: null,
                                icon: Icon(
                                  detail.procesoRealiza.realizarProceso == true
                                      ? Icons.check_circle_outline_rounded
                                      : Icons.cancel_outlined,
                                  color:
                                      detail.procesoRealiza.realizarProceso ==
                                              true
                                          ? const Color(0xFF198754)
                                          : const Color(0XFFdc3545),
                                ),
                                label: const Text(
                                  'Realizar Proceso',
                                  style: TextStyle(color: Colors.black87),
                                ),
                              ),
                              FilledButton.icon(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          const Color.fromARGB(20, 0, 0, 0)),
                                ),
                                onPressed: null,
                                icon: Icon(
                                  detail.procesoRealiza.firmar == true
                                      ? Icons.check_circle_outline_rounded
                                      : Icons.cancel_outlined,
                                  color: detail.procesoRealiza.firmar == true
                                      ? const Color(0xFF198754)
                                      : const Color(0XFFdc3545),
                                ),
                                label: const Text(
                                  'Firmar',
                                  style: TextStyle(color: Colors.black87),
                                ),
                              ),
                              FilledButton.icon(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          const Color.fromARGB(20, 0, 0, 0)),
                                ),
                                onPressed: null,
                                icon: Icon(
                                  detail.procesoRealiza.revisar == true
                                      ? Icons.check_circle_outline_rounded
                                      : Icons.cancel_outlined,
                                  color: detail.procesoRealiza.revisar == true
                                      ? const Color(0xFF198754)
                                      : const Color(0XFFdc3545),
                                ),
                                label: const Text(
                                  'Revisar',
                                  style: TextStyle(color: Colors.black87),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
