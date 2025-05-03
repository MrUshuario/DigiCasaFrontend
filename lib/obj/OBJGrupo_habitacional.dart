import 'package:flutter/cupertino.dart';


class grupo_habitacional {

  int?       id;
  String?    direccion;
  String?    created_at;
  String?    updated_at;

  grupo_habitacional({
    this.id,
    this.direccion,
    this.created_at,
    this.updated_at,
  });

  factory grupo_habitacional.fromJson(dynamic json)  => grupo_habitacional(
    id: json['id'] as int?,
    direccion: json['direccion'],
    created_at: json['created_at'],
    updated_at: json['updated_at'],
  );

  static List<grupo_habitacional> listFromJson(dynamic json) {
    var bienvenidaList = json as List;
    List<grupo_habitacional> items =
    bienvenidaList.map((e) => grupo_habitacional.fromJson(e)).toList();
    return items ?? [];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "direccion":direccion,
      "created_at":created_at,
      "updated_at":updated_at,
    };
  }
  
}
