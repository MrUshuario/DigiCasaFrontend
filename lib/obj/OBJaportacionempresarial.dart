class AportacionEmpresarial {
  int? codigoaportacion;
  int? codigotarjeta; //FK
  int? nominatrabajador;
  String? descripcion;
  double? base;
  double? tipo;
  double? impuesto;
  String? create_at;
  String? uploadat;


  AportacionEmpresarial({
    this.codigoaportacion,

  });

  factory AportacionEmpresarial.fromJson(dynamic json)  => AportacionEmpresarial(
    codigoaportacion: json['codigoaportacion'] as int?,

  );

  static List<AportacionEmpresarial> listFromJson(dynamic json) {
    var bienvenidaList = json as List;
    List<AportacionEmpresarial> items =
    bienvenidaList.map((e) => AportacionEmpresarial.fromJson(e)).toList();
    return items ?? [];
  }

  Map<String, dynamic> toMap() {
    return {
      "codigoaportacion": codigoaportacion,

    };
  }
  
}