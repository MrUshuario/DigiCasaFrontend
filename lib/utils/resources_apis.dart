
class apisResources {

  //FORMULARIO
  static const String urlbase 							= "https://bcnclean.com/php/index.php/";

  //OFICIAL
  //SI SE LE AGREGA UN LUGAR SE PUEDE TRAER UNO ESPECIFICO
  static const String REST_BUSQUEDA_LISTAR_GENERAL					          = "${urlbase}available-rentals";

  //SI SE LE AGREGA UN LUGAR SE PUEDE TRAER UNO ESPECIFICO UBIGEO
  static const String REST_BUSQUEDA_LISTAR_HABITACION							    = "${urlbase}habitaciones/ubigeo/"; //POR LUGAR
  //SI SE LE AGREGA UN LUGAR SE PUEDE TRAER UNO ESPECIFICO DESCRIPCION
  static const String REST_BUSQUEDA_LISTAR_DESCRIPCION						    = "${urlbase}habitaciones/descripcion/Departamento"; //ME LISTA ALL
  //DETALLES INVERSION LO ODEL USUARIO
  static const String REST_inversiones						                    =	"${urlbase}inversiones";
  //Un usuarios con su inversiones
  static const String REST_usuariosdeinversiones 					            =	"${urlbase}usuariosdeinversiones";
  //Un usuarios con su inversiones
  static const String REST_LISTAR_USUARIOS_INVERSIONES	 					    =	"${urlbase}inversiones-con-usuarios";

  //APIS REGISTRAR
  static const String REST_REGISTRAR_USUARIO	 					    =	"${urlbase}registrarme";
  static const String REST_MODIFICAR_USUARIO	 					    =	"${urlbase}modificarme";

  //CREAR APARTAMENTO
  static const String REST_REGISTRAR_APARTAMENTO	 					    =	"${urlbase}crearapartamento";



  static const String mensaje_correcto_login 					     =	"Usuario indentificado correctamente";
  static const String REST_LOGIN_GOOGLE 					     =	"${urlbase}loginGoogle";
  static const String REST_LOGIN_FACABOOK 					   =	"${urlbase}loginFacebook";

  //EN EL TOKEN DEBE ESTAR EL ID DE USUARIO EMAIL VERIFICATION CORREO DE VERIFICACION
  //LOGIN
  static const String REST_LOGIN_CONTRA 					     =	"${urlbase}logeo";
}