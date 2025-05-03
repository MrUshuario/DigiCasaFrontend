class Mensualidad {
  int? codigomes;
  String? mes;
  double? montopagado;


  Mensualidad({
    this.codigomes,
    this.mes,
    this.montopagado,
  });

  factory Mensualidad.fromJson(dynamic json)  => Mensualidad(
    codigomes: json['codigomes'] as int?,
    mes: json['mes'] as String?,
    montopagado: json['montopagado'] as double?,
  );

  static List<Mensualidad> listFromJson(dynamic json) {
    var bienvenidaList = json as List;
    List<Mensualidad> items =
    bienvenidaList.map((e) => Mensualidad.fromJson(e)).toList();
    return items ?? [];
  }

  Map<String, dynamic> toMap() {
    return {
      "codigomes": codigomes,
      "mes": mes,
      "montopagado": montopagado,
    };
  }
  
}