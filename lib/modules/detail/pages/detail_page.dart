import 'package:flutter/material.dart';
import 'package:tab_bar/modules/detail/widgets/content_card.dart';
import 'package:tab_bar/shared/models/detail.dart';
import 'package:tab_bar/modules/detail/services/detail_sevice.dart';
import 'package:animate_do/animate_do.dart';

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
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              final detail = snapshot.data![index];
              final dateIssue = detail.fechaEmision;
              DateTime dateTime = DateTime.parse(dateIssue.toString());
              String date =
                  "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: BounceInDown(
                  from: 100,
                  child: Card(
                    elevation: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            color: Colors.indigo,
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            textAlign: TextAlign.center,
                            detail.nombreDocumento,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ContentCardWidget(
                                title: 'Fecha de Emisión:',
                                subtitle: date,
                              ),
                              const SizedBox(height: 8),
                              ContentCardWidget(
                                title: 'Tipo de Descripción:',
                                subtitle: detail.descripcionTipo,
                              ),
                              const SizedBox(height: 8),
                              ContentCardWidget(
                                title: 'Estado:',
                                subtitle: detail.estado,
                              ),
                              const SizedBox(height: 8),
                              ContentCardWidget(
                                title: 'Respeta Orden:',
                                subtitle: detail.respetaOrden,
                              ),
                              const SizedBox(height: 8),
                              ContentCardWidget(
                                title: 'Observaciones:',
                                subtitle: detail.observaciones == ''
                                    ? 'No hay observaciones'
                                    : detail.observaciones,
                              ),
                              const SizedBox(height: 8)
                            ],
                          ),
                        )
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
