class AportacionEmpresarial {
  int? codigoInversion; //LLAVE
  int? idDepartamento; //FK OBJapartamentos
  int? codigoaportacion;  //FK OBJimporte
  int? id_usuario; //FK OBJUsuario
  String? codigoFondo;
  String? nombreInversion;
  int? montoInversion;
  double? porcentajeInteres;
  int? montoBeneficioTotal;
  String? fechaInversion;


  AportacionEmpresarial({
    this.codigoInversion,
    this.idDepartamento, //FK
    this.codigoaportacion,  //FK
    this.id_usuario, //FK
    this.codigoFondo,
    this.nombreInversion,
    this.montoInversion,
    this.porcentajeInteres,
    this.montoBeneficioTotal,
    this.fechaInversion
  });

  factory AportacionEmpresarial.fromJson(dynamic json)  => AportacionEmpresarial(
    codigoInversion: json['codigoInversion'] as int?,
    idDepartamento: json['idDepartamento'] as int?,
    codigoaportacion: json['codigoaportacion'] as int?,
    id_usuario: json['id_usuario'] as int?,
    codigoFondo: json['codigoFondo'] as String?,
    nombreInversion: json['nombreInversion'] as String?,
    montoInversion: json['montoInversion'] as int?,
    porcentajeInteres: json['porcentajeInteres'] as double?,
    montoBeneficioTotal: json['montoBeneficioTotal'] as int?,
    fechaInversion: json['fechaInversion'] as String?,
  );

  static List<AportacionEmpresarial> listFromJson(dynamic json) {
    var bienvenidaList = json as List;
    List<AportacionEmpresarial> items =
    bienvenidaList.map((e) => AportacionEmpresarial.fromJson(e)).toList();
    return items ?? [];
  }

  Map<String, dynamic> toMap() {
    return {
      "codigoInversion": codigoInversion,
      "idDepartamento": idDepartamento,
      "codigoaportacion": codigoaportacion,
      "id_usuario": id_usuario,
      "codigoFondo": codigoFondo,
      "nombreInversion": nombreInversion,
      "montoInversion":montoInversion,
      "porcentajeInteres": porcentajeInteres,
      "montoBeneficioTotal": montoBeneficioTotal,
      "fechaInversion": fechaInversion,
    };
  }
  
}