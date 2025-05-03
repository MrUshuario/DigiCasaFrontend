class usuariotrabajadorERROR {

  int? id_usuario;
  List<dynamic>? email;
  List<dynamic>? primer_nombre;
  List<dynamic>? segundo_nombre;
  List<dynamic>? apellido_paterno;
  List<dynamic>? apellido_materno;
  List<dynamic>? direccion;
  List<dynamic>? telefono;
  List<dynamic>? documento;
  List<dynamic>? fecha_nacimiento;
  List<dynamic>? tipo_usuario;
  List<dynamic>? imagen_perfil;
  List<dynamic>? contrasenia;
  List<dynamic>? token;

  usuariotrabajadorERROR({
    this.id_usuario,
    this.email,
    this.tipo_usuario,
    this.primer_nombre,
    this.segundo_nombre,
    this.apellido_paterno,
    this.apellido_materno,
    this.direccion,
    this.telefono,
    this.documento,
    this.fecha_nacimiento,
    this.imagen_perfil,
    this.contrasenia,
    this.token,
  });

  factory usuariotrabajadorERROR.fromJson(dynamic json)  => usuariotrabajadorERROR(
    id_usuario: json['id_usuario'] as int?,
    email: json['email'],
    tipo_usuario: json['tipo_usuario'] ,
    primer_nombre: json['primer_nombre'],
    segundo_nombre: json['segundo_nombre'],
    apellido_paterno: json['apellido_paterno'],
    apellido_materno: json['apellido_materno'],
    direccion: json['direccion'],
    telefono: json['telefono'],
    documento: json['documento'],
    fecha_nacimiento: json['fecha_nacimiento'],
    imagen_perfil: json['imagen_perfil'],
    contrasenia: json['contrasenia'],
    token: json['token'],
  );

  static List<usuariotrabajadorERROR> listFromJson(dynamic json) {
    var bienvenidaList = json as List;
    List<usuariotrabajadorERROR> items =
    bienvenidaList.map((e) => usuariotrabajadorERROR.fromJson(e)).toList();
    return items ?? [];
  }

  Map<String, dynamic> toMap() {
    return {
      "id_usuario": id_usuario,
      "primer_nombre": primer_nombre,
      "segundo_nombre": segundo_nombre,
      "apellido_paterno": apellido_paterno,
      "apellido_materno": apellido_materno,
      "direccion": direccion,
      "telefono":telefono,
      "documento": documento,
      "fecha_nacimiento":fecha_nacimiento,
      "imagen_perfil":imagen_perfil,
      "contrasenia":contrasenia,
      "token":token,
    };
  }
  
}