import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tab_bar/models/detail.dart';

class DetailService {
  Future<List<Detail>> getDetail() async {
    try {
      final String response =
          await rootBundle.loadString('assets/data/detail.json');
      List<Detail> detailList = detailFromJson(response);
      return detailList;
    } catch (error) {
      debugPrint('Error al obtener los detalles: $error');
      return [];
    }
  }
}
