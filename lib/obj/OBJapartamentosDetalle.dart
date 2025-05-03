//import 'package:flutter/cupertino.dart';


class ApartamentoDetalle {
 // @PrimaryKey(autoGenerate: true)
  int?    id;
  int?    id_habitacion;
  String? ubigeo;
  String? descripcion;
  String? amenidades; //CHARLA STRING
  String? caracteristicas;
  String? precio;
  String? area;
  String? imagenes;
  String? imagenes_nombres;

  ApartamentoDetalle({
    this.id,
    this.id_habitacion,
    this.ubigeo,
    this.descripcion,
    this.amenidades, //CHARL
    this.caracteristicas,
    this.precio,
    this.area,
    this.imagenes,
    this.imagenes_nombres,
  });

  factory ApartamentoDetalle.fromJson(dynamic json)  => ApartamentoDetalle(
    id: json['id'] as int?,
    id_habitacion: json['id_habitacion'] as int?,
    ubigeo: json['ubigeo'] as String?,
    descripcion: json['descripcion'] as String?,
    amenidades: json['amenidades'] as String?,
    caracteristicas: json['caracteristicas'] as String?,
    precio: json['precio'] as String?,
    area: json['area'] as String?,
    imagenes: json['imagen'],
    imagenes_nombres: json['imagenes_nombres'],
  );

  static List<ApartamentoDetalle> listFromJson(dynamic json) {
    var bienvenidaList = json as List;
    List<ApartamentoDetalle> items =
    bienvenidaList.map((e) => ApartamentoDetalle.fromJson(e)).toList();
    return items ?? [];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "id_habitacion":id_habitacion,
      "ubigeo":ubigeo,
      "descripcion":descripcion,
      "amenidades": amenidades,
      "caracteristicas": caracteristicas,
      "precio": precio,
      "area": area,
      "imagenes": imagenes,
      "imagenes_nombres": imagenes_nombres,
    };
  }
  
}


/*


      String tipoOpcionList = "";
    if (json['tipoOpcion'] != null || json['tipoOpcion'] != "" || json['tipoOpcion'] != "texto") {
      tipoOpcionList = (json['tipoOpcion'] as List<dynamic>).join('; ');
    }

          "id": 1,
        "id_habitacion": 1,
        "ubigeo": "Av La Molina 555, Lima",
        "descripcion": "Departamento cerca al mar, elegante y sobrio.",
        "amenidades": "Piscina, Cancha de Fútbol",
        "caracteristicas": "3 habitaciones, 2 baños, comedor, lavandería",
        "precio": "1400.00",
        "area": "150.00",
        "imagenes": "imagen1.jpg,imagen2.jpg,imagen3.jpg",
        "imagenes_nombres": "imagen1,imagen2,imagen3"
   */
