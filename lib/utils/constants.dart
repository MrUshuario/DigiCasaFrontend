class Constants {
  static const String formatDate = "dd-MM-yyyy";
  static const String titleEditStudent = 'Editar estudiantes';
  static const String titleListStudent = 'Listado de estudiantes';
  static const String titleSearchStudent = 'Buscador estudiantes';
  static const String titleUploadFile = 'Configuración estudiantes';
  static const String titleSynchronization = 'Sincronizar estudiantes';
  static const String buttonSynchronization = 'Sincronizar';
  static const String patternNameLastName = r'(^[a-zñA-ZÑ ]*$)';
  static const String patternDepart = r'(^[a-zñA-ZÑ ]*$)';
  static const String patternProvince = r'(^[a-zñA-ZÑ ]*$)';
  static const String patternDistrict = r'(^[a-zñA-ZÑ ]*$)';
  static const String patterndocumento = r'(^[0-9]{8,9}$)';
  static const String patternTelefono = r'(^[0-9]{11,11}$)';
  static const String patternAge = r'(^[0-9]{1,2}$)';
  static const String patternDegree = r'(^[0-9]{1,2}$)';
  static const String patternNameColegio = r'(^[a-zñA-ZÑ ]*$)';
  static const String patternEnrollmentDate = r'(^2\d{3}$)';
  static const String patternCodStudent = r'(^[0-9]{8,15}$)';
  static const String patternCodModularStudent = r'(^[0-9]{7,12}$)';

  static const String patterncontra = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$';
  static const String patterncorreo= r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+(.[a-zA-Z]+)?$";


  static const List<String> departments = [
    "<Seleccionar>",
    "Amazonas",
    "Ancash",
    "Apurimac",
    "Arequipa",
    "Ayacucho",
    "Cajamarca",
    "Callao",
    "Cusco",
    "Huancavelica",
    "Huanuco",
    "Ica",
    "Junín",
    "La Libertad",
    "Lambayeque",
    "Lima",
    "Loreto",
    "Madre de Dios",
    "Moquegua",
    "Pasco",
    "Piura",
    "Puno",
    "San Martín",
    "Tacna",
    "Tumbes"
  ];
}
