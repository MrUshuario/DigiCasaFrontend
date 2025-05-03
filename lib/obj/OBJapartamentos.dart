import 'OBJGrupo_habitacional.dart';

class Apartamento {

  int?            id;
  String?         titulo;
  String?         nombre_alquilador;
  String?         numero_contacto;
  String?         direccion;
  int?         grupo_habitacional_id;
  int?         numero_habitaciones;
  int?         numero_banos;
  int?         numero_pisos;
  int?         numero_habitantes;
  int?         maximo_habitantes;
  String?         created_at;
  String?         updated_at;
  List<dynamic>?  images;
  String?         ubigeo_latitud;
  String?         ubigeo_longitud;
  String?         descripcion;
  List<dynamic>?  amenidades; // Lista separado por comas cocina, calefaccion,
  String?         mensualidad;
  int?         metros_cuadrados; //metros cuadrados
  grupo_habitacional? obj_grupo_habitacional;

  Apartamento({
    this.id,
    this.titulo,
    this.nombre_alquilador,
    this.numero_contacto,
    this.direccion,
    this.grupo_habitacional_id,
    this.numero_habitaciones,
    this.numero_banos,
    this.numero_pisos,
    this.numero_habitantes,
    this.maximo_habitantes,
    this.created_at,
    this.updated_at,
    this.images,
    this.ubigeo_latitud,
    this.ubigeo_longitud,
    this.descripcion,
    this.amenidades,
    this.mensualidad,
    this.metros_cuadrados,
    this.obj_grupo_habitacional
  });

  //type '_Map<String, dynamic>' is not a subtype of type 'grupo_habitacional?'

  factory Apartamento.fromJson(dynamic json)  => Apartamento(
    id: json['id'] as int?,
    titulo: json['titulo'],
    nombre_alquilador: json['nombre_alquilador'],
    numero_contacto: json['numero_contacto'],
    direccion: json['direccion'],
    grupo_habitacional_id: json['grupo_habitacional_id'],
    numero_habitaciones: json['numero_habitaciones'],
    numero_banos: json['numero_banos'],
    numero_pisos: json['numero_pisos'],
    numero_habitantes: json['numero_habitantes'],
    maximo_habitantes: json['maximo_habitantes'],
    created_at: json['created_at'],
    updated_at: json['updated_at'],
    images: json['images'],
    ubigeo_latitud: json['ubigeo_latitud'],
    ubigeo_longitud: json['ubigeo_longitud'],
    descripcion: json['descripcion'],
    amenidades: json['amenidades'],
    mensualidad: json['mensualidad'],
    metros_cuadrados: json['metros_cuadrados'],
    obj_grupo_habitacional: grupo_habitacional.fromJson(json['grupo_habitacional']),

  );

  static List<Apartamento> listFromJson(dynamic json) {
    var bienvenidaList = json as List;
    List<Apartamento> items =
    bienvenidaList.map((e) => Apartamento.fromJson(e)).toList();
    return items ?? [];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "titulo":titulo,
      "nombre_alquilador":nombre_alquilador,
      "numero_contacto":numero_contacto,
      "direccion": direccion,
      "grupo_habitacional_id": grupo_habitacional_id,
      "numero_habitaciones": numero_habitaciones,
      "numero_banos": numero_banos,
      "numero_pisos": numero_pisos,
      "numero_habitantes": numero_habitantes,
      "created_at": created_at,
      "updated_at": updated_at,
      "images": images,
      "ubigeo_latitud":ubigeo_latitud,
      "ubigeo_longitud":ubigeo_longitud,
      "descripcion": descripcion,
      "amenidades": amenidades,
      "mensualidad": mensualidad,
      "metros_cuadrados": metros_cuadrados,
      "grupo_habitacional": obj_grupo_habitacional, //grupo_habitacional
    };
  }
  
}