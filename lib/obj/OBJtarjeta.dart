class Tarjeta {
  int? codigotarjeta;
  int? id_usuario; //CLAVE FORANEA
  String? numero;
  String? numeroinicio;
  String? numeroseguridad;
  String? fechavencimiento;
  String? tipo;
  String? token; //psp
  


  Tarjeta({
    this.codigotarjeta,
    this.id_usuario,
    this.numero,
    this.numeroinicio,
    this.numeroseguridad,
    this.fechavencimiento,
    this.tipo,
    this.token,

  });

  factory Tarjeta.fromJson(dynamic json)  => Tarjeta(
    codigotarjeta: json['codigotarjeta'] as int?,
    id_usuario: json['id_usuario'] as int?,
    numero: json['numero'] as String?,
    numeroinicio: json['numeroinicio'] as String?,
    numeroseguridad: json['numeroseguridad'] as String?,
    fechavencimiento: json['fechavencimiento'] as String?,
    tipo: json['tipo'] as String?,
    token: json['token'] as String?,
  );

  static List<Tarjeta> listFromJson(dynamic json) {
    var bienvenidaList = json as List;
    List<Tarjeta> items =
    bienvenidaList.map((e) => Tarjeta.fromJson(e)).toList();
    return items ?? [];
  }

  Map<String, dynamic> toMap() {
    return {
      "codigotarjeta": codigotarjeta,
      "id_usuario":id_usuario,
      "numeroinicio":numeroinicio,
      "numero": numero,
      "numeroseguridad": numeroseguridad,
      "fechavencimiento": fechavencimiento,
      "tipo": tipo,
      "token": token,
    };
  }
  
}