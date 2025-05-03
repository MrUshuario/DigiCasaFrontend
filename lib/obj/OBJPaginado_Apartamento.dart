import 'OBJapartamentos.dart';


class Paginado_apartamento {

  int?                  current_page;
  List<Apartamento>?    data;
  String?               next_page_url;
  String?               path;
  int?                  per_page;
  String?               prev_page_url;
  int?                  to;
  int?                  total;

  Paginado_apartamento({
    this.current_page,
    this.data,
    this.next_page_url,
    this.path,
    this.per_page,
    this.prev_page_url,
    this.to,
    this.total,
  });

  factory Paginado_apartamento.fromJson(dynamic json)  => Paginado_apartamento(
    current_page: json['current_page'] as int?,
    data: Apartamento.listFromJson(json['data']),
    next_page_url: json['next_page_url'],
    path: json['path'],
    per_page: json['per_page'],
    prev_page_url: json['prev_page_url'],
    to: json['to'],
    total: json['total'],
  );

  static List<Paginado_apartamento> listFromJson(dynamic json) {
    var bienvenidaList = json as List;
    List<Paginado_apartamento> items =
    bienvenidaList.map((e) => Paginado_apartamento.fromJson(e)).toList();
    return items ?? [];
  }

  Map<String, dynamic> toMap() {
    return {
      "current_page":current_page,
      "data":data,
      "next_page_url":next_page_url,
      "path":path,
      "per_page":per_page,
      "prev_page_url":prev_page_url,
      "to":to,
      "total":total,
    };
  }
  
}
