import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:tab_bar/shared/models/detail.dart';

class DetailService {
  Future<List<Detail>> getDetail() async {
    const String url = 'assets/data/detail.json';
    final response = await rootBundle.loadString(url);
    final jsonData = jsonDecode(response);
    final details = Detail.fromJson(jsonData);
    return [details];
  }
}
