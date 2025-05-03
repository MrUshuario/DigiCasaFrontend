import 'dart:convert';

class respFormato<T> {
  String? message;
  JsonCodec? data; //CLAVE FORANEA
  String? error;



  respFormato({
    this.message,
    this.data,
    this.error,
  });

  factory respFormato.fromJson(dynamic json)  => respFormato(
    message: json['message'] as String?,
    data: json['data'], //Map<String, dynamic> data = jsonDecode(response.body);
    error: json['numero'] as String?,

  );

  static List<respFormato> listFromJson(dynamic json) {
    var bienvenidaList = json as List;
    List<respFormato> items =
    bienvenidaList.map((e) => respFormato.fromJson(e)).toList();
    return items ?? [];
  }

  Map<String, dynamic> toMap() {
    return {
      "message": data,
      "data": data,
      "error":error,
    };
  }

}