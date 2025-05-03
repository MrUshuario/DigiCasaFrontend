import 'dart:convert';
import 'package:digicasa/obj/OBJGrupo_habitacional.dart';
import 'package:digicasa/obj/OBJapartamentos.dart';
import 'package:digicasa/obj/OBJusuarios.dart';
import 'package:digicasa/obj/sql/OBJusuariosERRORES.dart';
import 'package:digicasa/obj/sql/respformato.dart';
import 'package:digicasa/utils/resources_apis.dart';
import 'package:crypto/crypto.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../obj/OBJPaginado_Apartamento.dart';


class apiprovider_formulario {


  //final client = GetIt.I.get<Client>();
  final api_get_busqueda_listar_general               = apisResources.REST_BUSQUEDA_LISTAR_GENERAL;
  final api_get_busqueda_listar                       = apisResources.REST_BUSQUEDA_LISTAR_HABITACION;
  final api_get_listar_departamento_detalle           = apisResources.REST_BUSQUEDA_LISTAR_DESCRIPCION;
  final api_get_inversiones                           = apisResources.REST_inversiones;
  final api_get_usuariosdeinversiones 		            = apisResources.REST_usuariosdeinversiones;
  final api_get_listar_usuarios_inversiones           = apisResources.REST_LISTAR_USUARIOS_INVERSIONES;
  final api_post_registrarUsuario                        = apisResources.REST_REGISTRAR_USUARIO;
  final api_post_modificarUsuario                        = apisResources.REST_MODIFICAR_USUARIO;
  final api_post_registrarApartamento                        = apisResources.REST_REGISTRAR_APARTAMENTO;


  final api_post_login_contra        = apisResources.REST_LOGIN_CONTRA;
  final api_post_login_google       = apisResources.REST_LOGIN_GOOGLE;
  final api_post_login_facebook        = apisResources.REST_LOGIN_FACABOOK;




  //EJEMPLO CON LISTAS

  Future<usuariotrabajador> post_Login(String correo, String contra, String tipo) async {
    try {
      var bytes1 = utf8.encode(contra);         // data being hashed
      var hash = sha256.convert(bytes1);
      String hasheado = hash.toString();// Hashing Process
      final Map<String, dynamic> bodyData = {"email": correo, "password": hasheado,};
      print(bodyData);
      String url_login = "$api_post_login_contra";
     if (tipo == "google") {
       url_login = "$api_post_login_google";
      } else if (tipo == "facebook"){
       url_login = "$api_post_login_facebook";
      }

      print("iniciando post_Login...");
      Uri uri = Uri.parse(url_login);
      final response = await http.post(
        uri,
        body: json.encode(bodyData),
        headers: {'Content-Type': 'application/json'},
      );
      print("respondio");
      print(response.body);
      final Map<String, dynamic> data = jsonDecode(response.body);
      //respFormato formatorespuesta = respFormato.fromJson(data); //type '_Map<String, dynamic>' is not a subtype of type 'JsonCodec?'
      //print(formatorespuesta);
      if (response.statusCode == 200) {
        print("200 hecho");
        if( data["message"] == apisResources.mensaje_correcto_login){
          SharedPreferences prefs = await SharedPreferences.getInstance();
          usuariotrabajador resp = usuariotrabajador.fromJson(data["data"]);
          //usuariotrabajador resp = usuariotrabajador.fromJson(formatorespuesta.data);

          await prefs.setString('token', resp.token!);
          await prefs.setString('email', resp.email!);
          await prefs.setString('nombre_completo', "${resp.primer_nombre!} ${resp.segundo_nombre!} ${resp.apellido_paterno!} ${resp.apellido_materno!}");
          await prefs.setString('tipo_usuario', resp.tipo_usuario!);
          await prefs.setString('direccion', resp.direccion!);
          await prefs.setString('telefono', resp.telefono!);
          await prefs.setString('documento', resp.documento!);
          await prefs.setString('fecha_creacion', resp.created_at!);
          await prefs.setString('fecha_nacimiento', resp.fecha_nacimiento!);
          await prefs.setInt('id', resp.id!);
          return resp;

        } else {
          usuariotrabajador obj = usuariotrabajador();
          obj.primer_nombre = "errorNOENVIADO";
          obj.token = data["message"];
          return  obj;
        }

      } else {
        print("200 NO HECHO");
        usuariotrabajador obj = usuariotrabajador();
        obj.primer_nombre = "errorNOENVIADO";
        obj.token = data["message"];
        return  obj;
      }
    } catch (e) {
      print("OCURRIO EL ERROR");
      print(e);
      usuariotrabajador obj = usuariotrabajador();
      obj.primer_nombre = "errorNOENVIADO";
      obj.token = "Ocurrio un error en el envio";
      return  obj;
    }
  }


  //DESCARGAR APARTAMENTO
  Future<Paginado_apartamento> get_DescargarApartamento(String distrito) async {
    try {
      String url_login = "$api_get_busqueda_listar$distrito";
      print("iniciando get_DescargarApartamento...");
      if ( distrito == ""){
        url_login = api_get_busqueda_listar_general;
      }

      Uri uri = Uri.parse(url_login);
      //TOKEN
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token') ?? "ERROR";
      //ENVIO
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        print("response DEPARTAMENTO...${response.body}");
        final Map<String, dynamic> data = jsonDecode(response.body);
        //METER DATA EN UN OBJETO
        Paginado_apartamento? objaux = Paginado_apartamento.fromJson( data['data']);
        //List<Apartamento>? apartaux = objaux.data?.cast<Apartamento>(); //EN OTRO FLUTTER MAS ACTUAL NO ERA NECESARIO CONVERTIR
        return objaux!;
      } else if (response.statusCode == 401) {
        print("response DEPARTAMENTO...${response.body}");
        Paginado_apartamento tipo = Paginado_apartamento();
        return  tipo;
      } else {
        Paginado_apartamento tipo = Paginado_apartamento();
        return  tipo;
      }
    } catch (e) {
      Paginado_apartamento tipo = Paginado_apartamento(); // type '_Map<String, dynamic>' is not a subtype of type 'grupo_habitacional?'
      return  tipo;
    }
  }


  //CREAR USUARIO
  Future<usuariotrabajador> post_CrearUsuario(usuariotrabajador usuario) async {
    try {
      String url_login = "$api_post_registrarUsuario";
      print("iniciando post_CrearUsuario...");
      var body = json.encode(usuario.toMap());
      print(body);
      Uri uri = Uri.parse(url_login);
      final response = await http.post(
        uri,
        body: json.encode(usuario.toMap()),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      var data =  json.decode(response.body);
      if (response.statusCode == 200) {

        SharedPreferences prefs = await SharedPreferences.getInstance();
        var resp = usuariotrabajador.fromJson(data["data"]);
        await prefs.setString('token', resp.token!);
        await prefs.setString('email', resp.email!);
        await prefs.setString('nombre_completo', "${resp.primer_nombre!} ${resp.segundo_nombre!} ${resp.apellido_paterno!} ${resp.apellido_materno!}");
        await prefs.setString('tipo_usuario', resp.tipo_usuario!);
        await prefs.setString('direccion', resp.direccion!);
        await prefs.setString('telefono', resp.telefono!);
        await prefs.setString('documento', resp.documento!);
        await prefs.setString('fecha_creacion', resp.created_at!);
        await prefs.setString('fecha_nacimiento', resp.fecha_nacimiento!);
        await prefs.setInt('id', resp.id!);

        return resp;
      } else if (response.statusCode == 422) {


        print("APARECIOE EL ERROR 422");

        usuariotrabajadorERROR ERRORobj = usuariotrabajadorERROR.fromJson(data["data"]);
        usuariotrabajador obj = usuariotrabajador();
        List<String?> mensajeerror = List.empty(growable: true);
        mensajeerror.add(ERRORobj.email?[0]);
        mensajeerror.add(ERRORobj.primer_nombre?[0]);
        mensajeerror.add(ERRORobj.segundo_nombre?[0]);
        mensajeerror.add(ERRORobj.apellido_paterno?[0]);
        mensajeerror.add(ERRORobj.apellido_materno?[0]);
        mensajeerror.add(ERRORobj.direccion?[0]);
        mensajeerror.add(ERRORobj.telefono?[0]);
        mensajeerror.add(ERRORobj.documento?[0]);
        mensajeerror.add(ERRORobj.fecha_nacimiento?[0]);
        mensajeerror.add(ERRORobj.tipo_usuario?[0]);
        mensajeerror.add(ERRORobj.contrasenia?[0]);

        /*
        List<String?> mensajeerror = List.empty(growable: true);

        final List0 = data['data']['email'] as List<dynamic>?;
        final List1 = data['data']['primer_nombre'] as List<dynamic>?;
        final List2 = data['data']['segundo_nombre'] as List<dynamic>?;
        final List3 = data['data']['apellido_paterno'] as List<dynamic>?;
        final List4 = data['data']['apellido_materno'] as List<dynamic>?;
        final List5 = data['data']['direccion'] as List<dynamic>?;
        final List6 = data['data']['telefono'] as List<dynamic>?;
        final List7 = data['data']['documento'] as List<dynamic>?;
        final List8 = data['data']['fecha_nacimiento'] as List<dynamic>?;
        final List9 = data['data']['tipo_usuario'] as List<dynamic>?;
        final List10 = data['data']['contrasenia'] as List<dynamic>?;

        mensajeerror.add(List0?[0]);
        mensajeerror.add(List1?[0]);
        mensajeerror.add(List2?[0]);
        mensajeerror.add(List3?[0]);
        mensajeerror.add(List4?[0]);
        mensajeerror.add(List5?[0]);
        mensajeerror.add(List6?[0]);
        mensajeerror.add(List7?[0]);
        mensajeerror.add(List8?[0]);
        mensajeerror.add(List9?[0]);
        mensajeerror.add(List10?[0]);*/

        //TODOS LOS MENSAJES
        String result = mensajeerror
            .where((element) => element?.isNotEmpty == true)
            .join("\n");

        obj.primer_nombre = result;
        obj.token = "ERROR";
        return  obj;

      }
      else {
        usuariotrabajador obj = usuariotrabajador();
        obj.primer_nombre = "Problemas de envio, intentelo más tarde";
        obj.token = "ERROR";
        return  obj;
      }
    } catch (e) {
      usuariotrabajador obj = usuariotrabajador();
      obj.primer_nombre = "Problemas de envio, intentelo más tarde";
      obj.token = "ERROR";
      return  obj;
    }
  }

  //MODIFICAR USUARIO
  Future<usuariotrabajador> post_ModidicarUsuario(usuariotrabajador usuario) async {
    try {
      String url_login = "$api_post_modificarUsuario";
      print("iniciando post_EnviarUsuario...");
      var body = json.encode(usuario.toMap());
      print(body);
      Uri uri = Uri.parse(url_login);
      //TOKEN
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token') ?? "ERROR";
      //ENVIO
      final response = await http.post(
        uri,
        body: json.encode(usuario.toMap()),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      var data =  json.decode(response.body);
      if (response.statusCode == 200) {
        return usuariotrabajador.fromJson(data["data"]);
      } else {
        usuariotrabajador obj = usuariotrabajador();
        obj.token = "ERROR";
        return  obj;
      }
    } catch (e) {
      usuariotrabajador obj = usuariotrabajador();
      obj.token = "ERROR";
      return  obj;
    }
  }


  Future<usuariotrabajador> post_crearApartamento(Apartamento apart) async {
    try {
      String url_login = "$api_post_registrarApartamento";
      print("iniciando post_EnviarUsuario...");
      var body = json.encode(apart.toMap());
      print(body);
      Uri uri = Uri.parse(url_login);
      //TOKEN
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token') ?? "ERROR";
      //ENVIO
      final response = await http.post(
        uri,
        body: json.encode(apart.toMap()),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      var data =  json.decode(response.body);
      if (response.statusCode == 200) {
        return usuariotrabajador.fromJson(data["data"]);
      } else {
        usuariotrabajador obj = usuariotrabajador();
        obj.token = "ERROR";
        return  obj;
      }
    } catch (e) {
      usuariotrabajador obj = usuariotrabajador();
      obj.token = "ERROR";
      return  obj;
    }
  }

}