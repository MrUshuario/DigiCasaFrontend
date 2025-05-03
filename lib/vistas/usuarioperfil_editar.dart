import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:digicasa/infraestructure/apis/apiprovider_formulario.dart';
import 'package:digicasa/obj/OBJapartamentos.dart';
import 'package:digicasa/obj/OBJusuarios.dart';
import 'package:digicasa/obj/sql/respformato.dart';
import 'package:digicasa/utils/HelpersViewAlertaInfo.dart';
import 'package:digicasa/utils/helpersviewAlertProgressCircle.dart';
import 'package:digicasa/utils/helpersviewInputs.dart';
import 'package:digicasa/utils/helpersviewLetrasSubs.dart';
import 'package:digicasa/utils/resources.dart';
import 'package:digicasa/vistas/home.dart';
import 'package:digicasa/vistas/usuarioperfil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';



class Usuario_perfileditar extends StatefulWidget {
  usuariotrabajador modoficarusuario = usuariotrabajador();
  apiprovider_formulario apiForm= apiprovider_formulario();
  //XFile? imageFile;
  String? base64String;
  bool fotoTomada = false;
  TextEditingController formNombre1 = TextEditingController();
  TextEditingController formNombre2 = TextEditingController();
  TextEditingController formApeP = TextEditingController();
  TextEditingController formApeM = TextEditingController();
  TextEditingController formDirrecion = TextEditingController();
  TextEditingController formTelefono = TextEditingController();
  TextEditingController formContra = TextEditingController();
  TextEditingController formContraRepetir = TextEditingController();
  TextEditingController formContra2 = TextEditingController();
  bool _isPasswordVisible = true;
  bool _isPasswordVisibleRepetir = true;
  bool _isPasswordVisible2 = true;

  final formNombre1ParamValidateForm    = List.filled(3, "", growable: false);
  final formApePParamValidateForm       = List.filled(3, "", growable: false);
  final formDirrecionParamValidateForm  = List.filled(3, "", growable: false);
  final formCorreoParamValidateForm     = List.filled(3, "", growable: false);
  final formdocumentoParamValidateForm        = List.filled(3, "", growable: false);
  final formContraParamValidateForm     = List.filled(3, "", growable: false);
  final formContra2ParamValidateForm    = List.filled(3, "", growable: false);
  final formTelefonoParamValidateForm   = List.filled(3, "", growable: false);

  @override
  State<StatefulWidget> createState() => _Usuario_perfileditar();
}

class PasswordVisibilityToggle extends StatefulWidget {
  const PasswordVisibilityToggle({
    Key? key,
    required this.isPasswordVisible,
    required this.onToggle,
  }) : super(key: key);
  final bool isPasswordVisible;
  final VoidCallback onToggle;
  @override
  State<PasswordVisibilityToggle> createState() => _PasswordVisibilityToggleState();
}

class _PasswordVisibilityToggleState extends State<PasswordVisibilityToggle> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        widget.isPasswordVisible ? Icons.visibility : Icons.visibility_off,
      ),
      onPressed: () {
        widget.onToggle();
      },
    );
  }
}

class _Usuario_perfileditar extends State<Usuario_perfileditar> {
  int? PREFidUsuario;
  String? PREFcorreo;

  @override
  void initState() {
    cargardatos();
    super.initState();

  }

  Future<void> cargardatos()  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      PREFidUsuario = prefs.getInt('id_usuario') ?? 1;
      PREFcorreo = prefs.getString('email') ?? "prueba@gmail.com";
    });
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
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  /*
  Future<void> TomarFoto() async {
    ImagePicker picker = ImagePicker();
    widget.imageFile = await picker.pickImage(
      source: ImageSource.camera,
    );
    List<int> imageBytes = File(widget.imageFile!.path).readAsBytesSync();
    widget.base64String = base64Encode(imageBytes);
    setState(() {
      widget.fotoTomada = true;
    });
  } */

  /*
  Future<void> SubirFoto() async {
    ImagePicker picker = ImagePicker();
    widget.imageFile = await picker.pickImage(
      source: ImageSource.camera,
    );
    List<int> imageBytes = File(widget.imageFile!.path).readAsBytesSync();
    widget.base64String = base64Encode(imageBytes);
    setState(() {
      widget.fotoTomada = true;
    });
  } */

  void ConfirmarDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Image.asset(Resources.iconInfo),
              SizedBox(width: 4), // Espacio entre el icono y el texto
              Expanded(
                child: Text(
                  '¿Desea confirmar la modificación de información?',
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 20, // Tamaño de fuente deseado
                  ),
                ),
              ),
            ],
          ),
          actions: [
            OverflowBar(
              alignment: MainAxisAlignment.start, // Alinea los botones a la izquierda
              children: [
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context); // Cierra el diálogo
                    CargaDialog();
                    //HACER EL ENVIO DE DATA
                    var resp = await widget.apiForm.post_ModidicarUsuario(widget.modoficarusuario);
                    _mostrarLoadingStreamController.add(true);
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    if (resp.token == "ERROR") {
                      _mostrarLoadingStreamController.add(true);
                      _mostrarLoadingStreamControllerTEXTO.add("Ocurrio un error en la base de datos");
                    } else {
                      _mostrarLoadingStreamController.add(true);
                      _mostrarLoadingStreamControllerTEXTO.add("Envio éxitoso. Verifique su correo");

                      await prefs.setString('email', resp.email!);
                      await prefs.setString('nombre_completo', "${resp.primer_nombre!} ${resp.segundo_nombre!} ${resp.apellido_paterno!} ${resp.apellido_materno!}");
                      await prefs.setString('tipo_usuario', resp.tipo_usuario!);
                      await prefs.setString('token', resp.token!);
                      await prefs.setString('direccion', resp.direccion!);
                      await prefs.setString('telefono', resp.telefono!);
                      await prefs.setString('documento', resp.documento!);


                      //GUARDAR DATOS
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  Home()),
                      );

                    }
                    _mostrarLoadingStreamController.add(true);
                    _mostrarLoadingStreamControllerTEXTO.add("Ocurrio un error en la base de datos");
                  },
                  child: const Text('Sí',
                    style: TextStyle(
                      fontSize: 18, // Tamaño de fuente deseado
                    ),),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Cierra el diálogo
                  },
                  child: const Text('No',
                    style: TextStyle(
                      fontSize: 18, // Tamaño de fuente deseado
                    ),),
                ),
              ],
            ),
          ],
        );
      },
    );

  }

  void AvisoDialog(String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Image.asset(Resources.iconInfo),
              SizedBox(width: 4), // Espacio entre el icono y el texto
              Expanded(
                child: Text(
                  text,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 20, // Tamaño de fuente deseado
                  ),
                ),
              ),
            ],
          ),
          actions: [
            OverflowBar(
              alignment: MainAxisAlignment.start, // Alinea los botones a la izquierda
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Cierra el diálogo
                  },
                  child: const Text('Cerrar',
                    style: TextStyle(
                      fontSize: 18, // Tamaño de fuente deseado
                    ),),
                ),
              ],
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
                    HelpersViewAlertProgressCircle(
                      mostrar: mostrarLOADING,
                      texto: "Inversión realizada",
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
            icon: const Icon(Icons.arrow_back, size: 40.0, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Usuario_perfil()),
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
                    //key: widget.keyForm,
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

          SizedBox(height: MediaQuery.of(context).size.height * 0.020,),

          HelpersViewLetrasSubs.formItemsDesign("Primer Nombre"),
          HelpersViewInputs.formItemsDesignInput(
            Icons.person,
            Center(
              child: TextFormField(
                controller: widget.formNombre1,
                //readOnly: true, // Optional: Set to true if the field is read-only
                maxLength: 50,
                decoration: const InputDecoration(
                  hintText: "Primer Nombre", // Hint text for empty field
                  counterText: "", // Hides character counter (optional)
                ),
              ),
            ),
          ),

          HelpersViewLetrasSubs.formItemsDesign("Segundo Nombre"),
          HelpersViewInputs.formItemsDesignInput(
            Icons.person,
            Center(
              child: TextFormField(
                controller: widget.formNombre2,
                //readOnly: true, // Optional: Set to true if the field is read-only
                maxLength: 50,
                decoration: const InputDecoration(
                  hintText: "Segundo Nombre", // Hint text for empty field
                  counterText: "", // Hides character counter (optional)
                ),
              ),
            ),
          ),

          HelpersViewLetrasSubs.formItemsDesign("Apellido Paterno"),
          HelpersViewInputs.formItemsDesignInput(
            Icons.person,
            Center(
              child: TextFormField(
                controller: widget.formApeP,
                //readOnly: true, // Optional: Set to true if the field is read-only
                maxLength: 50,
                decoration: const InputDecoration(
                  hintText: "Apellido Paterno", // Hint text for empty field
                  counterText: "", // Hides character counter (optional)
                ),
              ),
            ),
          ),

          HelpersViewLetrasSubs.formItemsDesign("Apellido Materno"),
          HelpersViewInputs.formItemsDesignInput(
            Icons.person,
            Center(
              child: TextFormField(
                controller: widget.formApeM,
                //readOnly: true, // Optional: Set to true if the field is read-only
                maxLength: 50,
                decoration: const InputDecoration(
                  hintText: "Apellido Materno", // Hint text for empty field
                  counterText: "", // Hides character counter (optional)
                ),
              ),
            ),
          ),

          HelpersViewLetrasSubs.formItemsDesign("Télefono"),
          HelpersViewInputs.formItemsDesignInput(
            Icons.phone,
            Center(
              child: TextFormField(
                controller: widget.formTelefono,
                //readOnly: true, // Optional: Set to true if the field is read-only
                maxLength: 11,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  hintText: "telefono", // Hint text for empty field
                  counterText: "", // Hides character counter (optional)
                ),
              ),
            ),
          ),

          HelpersViewLetrasSubs.formItemsDesign("Dirección"),
          HelpersViewInputs.formItemsDesignInput(
            Icons.map,
            Center(
              child: TextFormField(
                controller: widget.formDirrecion,
                //readOnly: true, // Optional: Set to true if the field is read-only
                maxLength: 250,
                decoration: const InputDecoration(
                  hintText: "Dirección", // Hint text for empty field
                  counterText: "", // Hides character counter (optional)
                ),
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.020,),
          HelpersViewLetrasSubs.formItemsDesignLineaGris(),

          HelpersViewLetrasSubs.formItemsDesign("Cambiar Contraseña"),
          HelpersViewInputs.formItemsDesignInput(
            Icons.key,
            Center( // Center the text field content
              child: TextFormField(
                controller: widget.formContra,
                obscureText: widget._isPasswordVisible,
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

          HelpersViewLetrasSubs.formItemsDesign("Repetir Nueva Contraseña"),
          HelpersViewInputs.formItemsDesignInput(
            Icons.key,
            Center( // Center the text field content
              child: TextFormField(
                controller: widget.formContraRepetir,
                obscureText: widget._isPasswordVisibleRepetir,
                maxLength: 20,
                decoration: InputDecoration(
                  hintText: "Repetir Nueva Contraseña",
                  counterText: "",
                  suffixIcon: PasswordVisibilityToggle(
                    isPasswordVisible: widget._isPasswordVisibleRepetir,
                    onToggle: () {
                      setState(() {
                        widget._isPasswordVisibleRepetir = !widget._isPasswordVisibleRepetir;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),


          HelpersViewLetrasSubs.formItemsDesign("Anterior Contraseña"),
          HelpersViewInputs.formItemsDesignInput(
            Icons.key,
            Center( // Center the text field content
              child: TextFormField(
                controller: widget.formContra2,
                obscureText: widget._isPasswordVisible2,
                maxLength: 20,
                decoration: InputDecoration(
                  hintText: "Anterior Contraseña",
                  counterText: "",
                  suffixIcon: PasswordVisibilityToggle(
                    isPasswordVisible: widget._isPasswordVisible2,
                    onToggle: () {
                      setState(() {
                        widget._isPasswordVisible2 = !widget._isPasswordVisible2;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),

          HelpersViewLetrasSubs.formItemsDesign("Enviar Foto"),

          Padding(
            padding: const EdgeInsets.only(top: 25.0, bottom: 8.0, left: 8.0, right: 8.0),
            child:
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child:

                  GestureDetector(
                    onTap: ()  async  {
                     // TomarFoto();
                    },
                    child:    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color:  Resources.AzulTema,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Column(
                        // Add spacing between icon and text (optional)
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.camera_alt, size: 50.0, color: Colors.white,
                          ),
                          Text("Tomar Foto", style: TextStyle(color: Colors.white)), // Your text
                          SizedBox(height: 5.0),

                        ],
                      ),
                    ),
                  ),



                ),

                const Expanded(
                  flex: 1,
                  child: const SizedBox(height: 1.0),
                ),

                Expanded(
                  flex: 4,
                  child:
                  GestureDetector(
                    onTap: ()  async  {
                     // SubirFoto();
                    },
                    child:
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color:  Resources.AzulTema,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Column(
                        // Add spacing between icon and text (optional)
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search, size: 50.0, color: Colors.white,
                          ),
                          Text("Subir Foto", style: TextStyle(color: Colors.white)), // Your text
                          SizedBox(height: 5.0),

                        ],
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.020,),

    Visibility(
    visible: widget.fotoTomada,
    child:
    Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child:
      Row(
        children: [
          Expanded(
            flex: 5,
            child:
            Column(
              children: [
                HelpersViewLetrasSubs.formItemsDesign("Foto tomada"),
              ],),
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: Column(
                // Add spacing between icon and text (optional)
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete, size: 50.0, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        widget.base64String = "";
                        widget.fotoTomada = false;
                      });

                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    ),


          SizedBox(height: MediaQuery.of(context).size.height * 0.020,),
          HelpersViewLetrasSubs.formItemsDesignLineaGris(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.020,),

          GestureDetector(
              onTap: ()  {


                if( widget.formContra.text == widget.formContra2.text ) {

                  //formContra2
                  setState(() {
                    widget.modoficarusuario.id = PREFidUsuario; // POR EL MOMENTO
                    widget.modoficarusuario.primer_nombre = widget.formNombre1.text;
                    widget.modoficarusuario.segundo_nombre= widget.formNombre2.text;
                    widget.modoficarusuario.apellido_paterno= widget.formApeP.text;
                    widget.modoficarusuario.apellido_materno= widget.formApeM.text;
                    widget.modoficarusuario.direccion = widget.formDirrecion.text;
                    widget.modoficarusuario.telefono= widget.formTelefono.text;
                    widget.modoficarusuario.imagen_perfil= widget.base64String;
                  });

                  //formTelefono
                  //widget.modoficarusuario.documento;
                  //widget.modoficarusuario.idempleado;
                  //widget.modoficarusuario.nif;
                  //widget.modoficarusuario.fechaantiguedad;
                  //widget.modoficarusuario.categoriaprofesional;
                  //widget.modoficarusuario.puesto;
                  //widget.modoficarusuario.banco;
                  //widget.modoficarusuario.sucursal;
                  //widget.modoficarusuario.cuenta;
                  //widget.modoficarusuario.tipocontrato;
                  //widget.modoficarusuario.cnae;
                  //widget.modoficarusuario.nroafiliaciones;
                  //widget.modoficarusuario.centrotrabajociudad;
                  //widget.modoficarusuario.centrotrabajoinfo;
                  //widget.modoficarusuario.create_at;
                  //widget.modoficarusuario.uploadat;
                  //widget.modoficarusuario.token;
                  ConfirmarDialog();

                } else {
                  AvisoDialog("Las contraseñas no coinciden");
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
                child: const Text("Confirmar Modificación",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500)),
              )),

          SizedBox(height: MediaQuery.of(context).size.height * 0.020,),

        ],),
    );

  }


}
