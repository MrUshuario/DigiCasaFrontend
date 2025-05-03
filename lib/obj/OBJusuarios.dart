class usuariotrabajador {

  int? id;
  String? email;
  String? tipo_usuario;
  String? primer_nombre;
  String? segundo_nombre;
  String? apellido_paterno;
  String? apellido_materno;
  String? direccion;
  String? telefono;
  String? documento;
  String? fecha_nacimiento;
  String? imagen_perfil;
  String? contrasenia;
  String? token;
  String? created_at;
  String? updated_at;

  //TOKEN verificaiion en otra tabla

  usuariotrabajador({
    this.id,
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
    this.created_at,
    this.updated_at,
  });

  factory usuariotrabajador.fromJson(dynamic json)  => usuariotrabajador(
    id: json['id'] as int?,
    email: json['email'] as String?,
    tipo_usuario: json['tipo_usuario'] as String?,
    primer_nombre: json['primer_nombre'] as String?,
    segundo_nombre: json['segundo_nombre'] as String?,
    apellido_paterno: json['apellido_paterno'] as String?,
    apellido_materno: json['apellido_materno'] as String?,
    direccion: json['direccion'] as String?,
    telefono: json['telefono'] as String?,
    documento: json['documento'] as String?,
    fecha_nacimiento: json['fecha_nacimiento'] as String?,
    imagen_perfil: json['imagen_perfil'] as String?,
    contrasenia: json['contrasenia'] as String?,
    token: json['token'] as String?,
    created_at: json['created_at'] as String?,
    updated_at: json['updated_at'] as String?
  );

  static List<usuariotrabajador> listFromJson(dynamic json) {
    var bienvenidaList = json as List;
    List<usuariotrabajador> items =
    bienvenidaList.map((e) => usuariotrabajador.fromJson(e)).toList();
    return items ?? [];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "email": email,
      "tipo_usuario": tipo_usuario,
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
      "created_at":created_at,
      "updated_at":updated_at,
    };
  }
  
}