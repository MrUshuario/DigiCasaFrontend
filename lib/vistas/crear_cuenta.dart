import 'dart:async';
import 'dart:convert';
import 'package:digicasa/infraestructure/apis/apiprovider_formulario.dart';
import 'package:digicasa/obj/OBJapartamentos.dart';
import 'package:digicasa/obj/OBJusuarios.dart';
import 'package:digicasa/obj/sql/respformato.dart';
import 'package:digicasa/utils/HelpersViewAlertaInfo.dart';
import 'package:digicasa/utils/constants.dart';
import 'package:digicasa/utils/helpers.dart';
import 'package:digicasa/utils/helpersviewAlertProgressCircle.dart';
import 'package:digicasa/utils/helpersviewInputs.dart';
import 'package:digicasa/utils/helpersviewLetrasSubs.dart';
import 'package:digicasa/utils/resources.dart';
import 'package:digicasa/vistas/home.dart';
import 'package:digicasa/vistas/login.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/helpersviewAlertProgressCircleSINOPCION.dart';



class Crear_cuenta extends StatefulWidget {
  apiprovider_formulario apiForm= apiprovider_formulario();
  GlobalKey<FormState> keyForm = GlobalKey();
  TextEditingController formNombre1 = TextEditingController();
  TextEditingController formNombre2 = TextEditingController();
  TextEditingController formApeP = TextEditingController();
  TextEditingController formApeM = TextEditingController();
  TextEditingController formDirrecion= TextEditingController();
  TextEditingController formCorreo = TextEditingController();
  TextEditingController formdocumento= TextEditingController();
  TextEditingController formContra = TextEditingController();
  TextEditingController formContra2 = TextEditingController();
  TextEditingController formFechaNac = TextEditingController();
  TextEditingController formTelefono = TextEditingController();
  usuariotrabajador nuevousuario = usuariotrabajador();
  bool _isPasswordVisible = true;

  final formFechanacParamValidateForm       = List.filled(3, "", growable: false);
  final formNombre1ParamValidateForm    = List.filled(3, "", growable: false);
  final formApePParamValidateForm       = List.filled(3, "", growable: false);
  final formDirrecionParamValidateForm  = List.filled(3, "", growable: false);
  final formCorreoParamValidateForm     = List.filled(3, "", growable: false);
  final formdocumentoParamValidateForm        = List.filled(3, "", growable: false);
  final formContraParamValidateForm     = List.filled(3, "", growable: false);
  final formTelefonoParamValidateForm   = List.filled(3, "", growable: false);

  @override
  State<StatefulWidget> createState() => _Crear_cuenta();
}

class _Crear_cuenta extends State<Crear_cuenta> {

  @override
  void initState() {
    funcion();

    //PARAMS
    widget.formNombre1ParamValidateForm[0] = Constants.patternNameLastName;
    widget.formNombre1ParamValidateForm[1] = "Nombre obligatorio";
    widget.formNombre1ParamValidateForm[2] = "Formato incorrecto. [a-z] y [A-Z]";

    widget.formApePParamValidateForm[0] = Constants.patternNameLastName;
    widget.formApePParamValidateForm[1] = "Apellido obligatorio";
    widget.formApePParamValidateForm[2] = "Formato incorrecto. [a-z] y [A-Z]";

    widget.formdocumentoParamValidateForm[0] = Constants.patterndocumento;
    widget.formdocumentoParamValidateForm[1] = "documento obligatorios";
    widget.formdocumentoParamValidateForm[2] = "Formato incorrecto. [0-9] de longitud 8 o 9";

    widget.formTelefonoParamValidateForm[0] = Constants.patternTelefono;
    widget.formTelefonoParamValidateForm[1] = "Telefono obligatorios";
    widget.formTelefonoParamValidateForm[2] = "Formato incorrecto. Longitud 11";

    //
    widget.formCorreoParamValidateForm[0] = Constants.patterncorreo;
    widget.formCorreoParamValidateForm[1] = "Correo obligatorio";
    widget.formCorreoParamValidateForm[2] = "Formato incorrecto. Correo obligatorio";

    widget.formContraParamValidateForm[0] = Constants.patterncontra;
    widget.formContraParamValidateForm[1] = "Contraseña obligatorios";
    widget.formContraParamValidateForm[2] = "Almenos una mayuscula/tecla especial y 8 caracteres";



    /*
    final formFechanacParamValidateForm
    final formDirrecionParamValidateForm
     */

    super.initState();

  }

  void funcion()  {

  }

  displayDialog(String? title, String? msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title!),
          content: Text(msg!),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  //ALERTDIALGO API

  final _mostrarLoadingStreamController = StreamController<bool>.broadcast();
  final _mostrarLoadingStreamControllerTEXTO = StreamController<String>.broadcast();
  void CargaDialog() {
    bool mostrarLOADING = false;
    String texto = "Envio Fallido";
    showDialog(
      barrierDismissible: mostrarLOADING,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {

            _mostrarLoadingStreamController.stream.listen((value) {
              setState(() {
                mostrarLOADING = value;
              });
            });

            _mostrarLoadingStreamControllerTEXTO.stream.listen((value) {
              setState(() {
                texto = value;
              });
            });

            return AlertDialog(
              contentPadding: EdgeInsets.all(0),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    HelpersViewAlertProgressCircleSINOPCION(
                      mostrar: mostrarLOADING,
                      texto: texto,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true, //SACA LA BARRA DEBUG
      home: Scaffold(
        backgroundColor: Resources.fondoBlanquiso,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 40.0, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => login()),
              );
            },
          ),
        ),
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
            ),

            // Existing content with Center, SingleChildScrollView, and Container
            //Center( child:
            SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  margin: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Form(
                    key: widget.keyForm,
                    child: formUI(),
                  ),
                ),
              ),
           // ),
          ],
        ),
      ),
    );
  }


  Widget formUI() {
    return Container(
        child: Column(
        children: [

        Padding(
        padding: const EdgeInsets.only(top: 30.0, bottom: 8.0, left: 8.0, right: 8.0),
      child:
      Column(
        children: [

          HelpersViewLetrasSubs.formItemsDesignBig("Ingrese sus datos"),
          const SizedBox(height: 10.0),

          SizedBox(height: MediaQuery.of(context).size.height * 0.020,),

          HelpersViewLetrasSubs.formItemsDesign("Primer Nombre"),
          HelpersViewInputs.formItemsDesignInput(
            Icons.person,
            Center(
              child: TextFormField(
                controller: widget.formNombre1,
                //readOnly: true, // Optional: Set to true if the field is read-only
                validator: (value) {
                  return HelpersViewInputs.validateField(
                      value!, widget.formNombre1ParamValidateForm);
                },
                maxLength: 50,
                decoration: const InputDecoration(
                  hintText: "Primer Nombre", // Hint text for empty field
                  counterText: "", // Hides character counter (optional)
                ),
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.020,),

          HelpersViewLetrasSubs.formItemsDesign("Segundo Nombre"),
          HelpersViewInputs.formItemsDesignInput(
            Icons.person,
            Center(
              child: TextFormField(
                controller: widget.formNombre2,
                validator: (value) {
                  return HelpersViewInputs.validateField(
                      value!, widget.formNombre1ParamValidateForm);
                },
                maxLength: 50,
                decoration: const InputDecoration(
                  hintText: "Segundo Nombre", // Hint text for empty field
                  counterText: "", // Hides character counter (optional)
                ),
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.020,),

          HelpersViewLetrasSubs.formItemsDesign("Apellido Paterno"),
          HelpersViewInputs.formItemsDesignInput(
            Icons.person,
            Center(
              child: TextFormField(
                controller: widget.formApeP,
                validator: (value) {
                  return HelpersViewInputs.validateField(
                      value!, widget.formApePParamValidateForm);
                },
                maxLength: 50,
                decoration: const InputDecoration(
                  hintText: "Apellido Paterno", // Hint text for empty field
                  counterText: "", // Hides character counter (optional)
                ),
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.020,),

          HelpersViewLetrasSubs.formItemsDesign("Apellido Materno"),
          HelpersViewInputs.formItemsDesignInput(
            Icons.person,
            Center(
              child: TextFormField(
                controller: widget.formApeM,
                validator: (value) {
                  return HelpersViewInputs.validateField(
                      value!, widget.formApePParamValidateForm);
                },
                maxLength: 50,
                decoration: const InputDecoration(
                  hintText: "Apellido Materno", // Hint text for empty field
                  counterText: "", // Hides character counter (optional)
                ),
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.020,),

          HelpersViewLetrasSubs.formItemsDesign("Documento de Identidad"),
          HelpersViewInputs.formItemsDesignInput(
            Icons.person,
            Center(
              child: TextFormField(
                controller: widget.formdocumento,
                validator: (value) {
                  return HelpersViewInputs.validateField(
                      value!, widget.formdocumentoParamValidateForm);
                },
                maxLength: 8,
                decoration: const InputDecoration(
                  hintText: "Documento", // Hint text for empty field
                  counterText: "", // Hides character counter (optional)
                ),
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.020,),

          HelpersViewLetrasSubs.formItemsDesign("Dirección"),
          HelpersViewInputs.formItemsDesignInput(
            Icons.map,
            Center(
              child: TextFormField(
                controller: widget.formDirrecion,
                validator: (value) {
                  return HelpersViewInputs.validateField(
                      value!, widget.formDirrecionParamValidateForm);
                },
                maxLength: 500,
                decoration: const InputDecoration(
                  hintText: "Dirección", // Hint text for empty field
                  counterText: "", // Hides character counter (optional)
                ),
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.020,),

          HelpersViewLetrasSubs.formItemsDesign("Télefono"),
          HelpersViewInputs.formItemsDesignInput(
            Icons.phone,
            Center(
              child: TextFormField(
                controller: widget.formTelefono,
                validator: (value) {
                  return HelpersViewInputs.validateField(
                      value!, widget.formTelefonoParamValidateForm);
                },
                maxLength: 11,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  hintText: "telefono", // Hint text for empty field
                  counterText: "", // Hides character counter (optional)
                ),
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.020,),

          //FECHA NAC
          HelpersViewInputs.formItemsDesignloginIcon(
              Icons.person,
              TextFormField(
                readOnly: true,
                controller: widget.formFechaNac,
                decoration: const InputDecoration(
                  labelText: 'Fecha de Nacimiento',
                ),
                validator: (value) {
                  return HelpersViewInputs.validateField(
                      value!, widget.formFechanacParamValidateForm);
                },
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1930, 03, 01),
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null) {
                    widget.formFechaNac.text =
                        Helpers.formatDate(Constants.formatDate, pickedDate);
                  }
                },
              )),


          SizedBox(height: MediaQuery.of(context).size.height * 0.020,),

          HelpersViewLetrasSubs.formItemsDesign("Correo"),
          HelpersViewInputs.formItemsDesignInput(
            Icons.email,
            Center(
              child: TextFormField(
                controller: widget.formCorreo,
                validator: (value) {
                  return HelpersViewInputs.validateField(
                      value!, widget.formCorreoParamValidateForm);
                },
                maxLength: 50,
                decoration: const InputDecoration(
                  hintText: "Correo electronico", // Hint text for empty field
                  counterText: "", // Hides character counter (optional)
                ),
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.020,),

          HelpersViewLetrasSubs.formItemsDesign("Contraseña (requiere almenos 8 caracteres)"),
          HelpersViewInputs.formItemsDesignInput(
            Icons.key,
            Center( // Center the text field content
              child: TextFormField(
                controller: widget.formContra,
                obscureText: widget._isPasswordVisible,
                validator: (value) {
                  return HelpersViewInputs.validateField(
                      value!, widget.formContraParamValidateForm);
                },
                maxLength: 20,
                decoration: InputDecoration(
                  hintText: "Nueva Contraseña",
                  counterText: "",
                  suffixIcon: PasswordVisibilityToggle(
                    isPasswordVisible: widget._isPasswordVisible,
                    onToggle: () {
                      setState(() {
                        widget._isPasswordVisible = !widget._isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.020,),

          HelpersViewLetrasSubs.formItemsDesign("Repita Contraseña"),
          HelpersViewInputs.formItemsDesignInput(
            Icons.key,
            Center( // Center the text field content
              child: TextFormField(
                controller: widget.formContra2,
                obscureText: widget._isPasswordVisible,
                validator: (value) {
                  return HelpersViewInputs.validateField(
                      value!, widget.formContraParamValidateForm);
                },
                maxLength: 20,
                decoration: InputDecoration(
                  hintText: "Nueva Contraseña",
                  counterText: "",
                  suffixIcon: PasswordVisibilityToggle(
                    isPasswordVisible: widget._isPasswordVisible,
                    onToggle: () {
                      setState(() {
                        widget._isPasswordVisible = !widget._isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.020,),
          HelpersViewLetrasSubs.formItemsDesignLineaGris(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.020,),

          GestureDetector(
              onTap: () async {

                if (widget.keyForm.currentState!.validate()) {

                  //widget.modoficarusuario.id_usuario = PREFidUsuario
                  widget.nuevousuario.primer_nombre = widget.formNombre1.text;
                  widget.nuevousuario.segundo_nombre= widget.formNombre2.text;
                  widget.nuevousuario.apellido_paterno= widget.formApeP.text;
                  widget.nuevousuario.apellido_materno= widget.formApeM.text;
                  widget.nuevousuario.direccion = widget.formDirrecion.text;
                  widget.nuevousuario.email = widget.formCorreo.text;
                  widget.nuevousuario.telefono= widget.formTelefono.text;
                  widget.nuevousuario.fecha_nacimiento= widget.formFechaNac.text;
                  widget.nuevousuario.documento= widget.formdocumento.text;
                  widget.nuevousuario.tipo_usuario= "arrendatario";

                  var bytes1 = utf8.encode(widget.formContra.text);
                  var hash = sha256.convert(bytes1);
                  widget.nuevousuario.contrasenia= hash.toString();

                  widget.keyForm.currentState!.reset();
                  usuariotrabajador resp = usuariotrabajador();
                  CargaDialog();

                  resp = await widget.apiForm.post_CrearUsuario(widget.nuevousuario);

                  if(resp.token == "ERROR"){
                    _mostrarLoadingStreamController.add(true);
                    _mostrarLoadingStreamControllerTEXTO.add(resp.primer_nombre!);

                  } else {

                    _mostrarLoadingStreamController.add(true);
                    _mostrarLoadingStreamControllerTEXTO.add("Se ha logrado crear la cuenta");

                    //GUARDAR DATOS
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  Home()),
                    );

                  }

                } else {
                  displayDialog(
                      "Mensaje Informativo", "Hay campos obligatorios por llenar.");
                }


              },
              child: Container(
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                alignment: Alignment.center,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color: Resources.AzulTema,
                ),
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: const Text("Crear Cuenta",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500)),
              )),



        ],
      ),),],),
    );

  }


}
