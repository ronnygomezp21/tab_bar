import 'dart:convert';

List<Detail> detailFromJson(String str) =>
    List<Detail>.from(json.decode(str).map((x) => Detail.fromJson(x)));

String detailToJson(List<Detail> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Detail {
  String idDocumentos;
  String nombreDocumento;
  DateTime fechaEmision;
  String estado;
  String observaciones;
  String descripcionTipo;
  String respetaOrden;
  ProcesoRealiza procesoRealiza;

  Detail({
    required this.idDocumentos,
    required this.nombreDocumento,
    required this.fechaEmision,
    required this.estado,
    required this.observaciones,
    required this.descripcionTipo,
    required this.respetaOrden,
    required this.procesoRealiza,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        idDocumentos: json["IdDocumentos"],
        nombreDocumento: json["NombreDocumento"],
        fechaEmision: DateTime.parse(json["FechaEmision"]),
        estado: json["Estado"],
        observaciones: json["Observaciones"],
        descripcionTipo: json["DescripcionTipo"],
        respetaOrden: json["RespetaOrden"],
        procesoRealiza: ProcesoRealiza.fromJson(json["procesoRealiza"]),
      );

  Map<String, dynamic> toJson() => {
        "IdDocumentos": idDocumentos,
        "NombreDocumento": nombreDocumento,
        "FechaEmision": fechaEmision.toIso8601String(),
        "Estado": estado,
        "Observaciones": observaciones,
        "DescripcionTipo": descripcionTipo,
        "RespetaOrden": respetaOrden,
        "procesoRealiza": procesoRealiza.toJson(),
      };
}

class ProcesoRealiza {
  bool realizarProceso;
  bool firmar;
  bool revisar;

  ProcesoRealiza({
    required this.realizarProceso,
    required this.firmar,
    required this.revisar,
  });

  factory ProcesoRealiza.fromJson(Map<String, dynamic> json) => ProcesoRealiza(
        realizarProceso: json["realizarProceso"],
        firmar: json["firmar"],
        revisar: json["revisar"],
      );

  Map<String, dynamic> toJson() => {
        "realizarProceso": realizarProceso,
        "firmar": firmar,
        "revisar": revisar,
      };
}
