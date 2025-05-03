import 'dart:async';
import 'dart:convert';
import 'package:digicasa/firebase_options.dart';
import 'package:digicasa/infraestructure/apis/apiprovider_formulario.dart';
import 'package:digicasa/obj/OBJusuarios.dart';
import 'package:digicasa/utils/helpersviewAlertProgressCircle.dart';
import 'package:digicasa/utils/helpersviewInputs.dart';
import 'package:digicasa/utils/helpersviewLetrasSubs.dart';
import 'package:digicasa/utils/resources.dart';
import 'package:digicasa/vistas/crear_cuenta.dart';
import 'package:digicasa/vistas/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



const List<String> scopes = <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
];

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  clientId: 'gov.es.barcelona.approom.barcelonaroom',
  scopes: scopes,
);


class login extends StatefulWidget {
  apiprovider_formulario apiForm= apiprovider_formulario();

  //GlobalKey<FormState> keyForm = GlobalKey();
  TextEditingController formUsuarioCtrl = TextEditingController();
  TextEditingController formClaveCtrl = TextEditingController();


  bool _isPasswordVisible = true;

  static Route<dynamic> route() =>
      MaterialPageRoute(builder: (context) => login());

  @override
  State<StatefulWidget> createState() => _login();
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


class _login extends State<login> {
  bool mostrarCargar = false;
  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false; // has granted permissions?
  String _contactText = '';


  @override
  void initState() {
    initializeDatabase();
    super.initState();

    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      bool isAuthorized = account != null;
      if (kIsWeb && account != null) {
        isAuthorized = await _googleSignIn.canAccessScopes(scopes);
      }
      setState(() {
        _currentUser = account;
        _isAuthorized = isAuthorized;
      });
      if (isAuthorized) {
        unawaited(_handleGetContact(account!));
      }
    });

    //_googleSignIn.signInSilently();

  }

  Future<void> initializeDatabase() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  }

  //FUNCION PRINCIPAL DEL LOGEO!
  Future<void> _handleSignIn() async {
    try {
      _currentUser = await _googleSignIn.signIn();

      if (_currentUser != null) {
        String? correoname = _currentUser?.email;
        String? id = _currentUser?.id;
        String? token = _currentUser?.serverAuthCode;

        if (correoname != null) {

          usuariotrabajador resp = usuariotrabajador();
          resp = await widget.apiForm.post_Login(correoname,id!,"google");
          if(resp.primer_nombre! == "errorNOENVIADO"){

            AvisoDialog(resp.token!);

          } else {
            //GUARDAR DATOS
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  Home()),
            );
          }

        }
      } else {
        AvisoDialog("Este usuario no esta registrado en Google");
      }

    } catch (error) {
      AvisoDialog("Este usuario no existe");
    }
  }

  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    setState(() {
      _contactText = 'Loading contact info...';
    });
    final http.Response response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names'),
      headers: await user.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = 'People API gave a ${response.statusCode} '
            'response. Check logs for details.';
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data =
    json.decode(response.body) as Map<String, dynamic>;
    final String? namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = 'I see you know $namedContact!';
      } else {
        _contactText = 'No contacts to display.';
      }
    });
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'] as List<dynamic>?;
    final Map<String, dynamic>? contact = connections?.firstWhere(
          (dynamic contact) => (contact as Map<Object?, dynamic>)['names'] != null,
      orElse: () => null,
    ) as Map<String, dynamic>?;
    if (contact != null) {
      final List<dynamic> names = contact['names'] as List<dynamic>;
      final Map<String, dynamic>? name = names.firstWhere(
            (dynamic name) =>
        (name as Map<Object?, dynamic>)['displayName'] != null,
        orElse: () => null,
      ) as Map<String, dynamic>?;
      if (name != null) {
        return name['displayName'] as String?;
      }
    }
    return null;
  }

  Future<void> _handleAuthorizeScopes() async {
    final bool isAuthorized = await _googleSignIn.requestScopes(scopes);
    // #enddocregion RequestScopes
    setState(() {
      _isAuthorized = isAuthorized;
    });
    // #docregion RequestScopes
    if (isAuthorized) {
      unawaited(_handleGetContact(_currentUser!));
    }
    // #enddocregion RequestScopes
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  void googlelogin() {
    _googleSignIn.signInSilently();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true, //SACA LA BARRA DEBUG
      home: Scaffold(
        appBar: null,
        //drawer: const MenuLateral(),
        body: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Container(
                  width: 420,
                  margin: const EdgeInsets.symmetric(horizontal: 60.0),
                  child: Form(
                    //key: widget.keyForm,
                    child: formUI(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
  void CargaDialog() {
    bool mostrarLOADING = false;
    showDialog(
      barrierDismissible: mostrarLOADING,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            _mostrarLoadingStreamController.stream.listen((value) {
              setState(() {
                Navigator.pop(context);
              });
            });

            return AlertDialog(
              contentPadding: EdgeInsets.all(0),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    HelpersViewAlertProgressCircle(
                      mostrar: mostrarLOADING,
                      texto: "Usuario no encontrado",
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


  Widget formUI() {
      return Column(
        children: <Widget>[

          Visibility(
            visible: mostrarCargar,
            child:
            Container(
              width: MediaQuery.of(context).size.height * 0.080,
              height: MediaQuery.of(context).size.height * 0.080,
              child: CircularProgressIndicator(
                backgroundColor: Colors.grey,
                valueColor: AlwaysStoppedAnimation(Resources.AzulTema),
                strokeWidth: 10,
              ),
            ),
          ),



          Visibility(
            visible: !mostrarCargar,
            child:
            Column(
              children: <Widget>[
                Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      /*
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ), */
                      margin: EdgeInsets.only(top: 10),
                      child: Image.asset( Resources.loginlargo, //
                        width: 250,
                        height: 60,),
                    )),

                Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      //margin: EdgeInsets.only(bottom: 20),
                      child: Image.asset( Resources.siContigo,
                        width: 250,
                        height: 100,),
                    )),

                //TESTEO
                Visibility(
                  visible: _isAuthorized,
                  child: const Text("AUTORIZADO TESTEO"),
                ),

                HelpersViewInputs.formItemsDesignloginIcon(
                  Icons.email,
                  Center(
                    child: TextFormField(
                      controller: widget.formUsuarioCtrl,
                      maxLength: 50,
                      decoration: InputDecoration(
                        hintText: "Correo electronico",
                      ),
                    ),
                  ),
                ),


                Card(
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    //side: BorderSide(color: Color.fromARGB(255, 45, 55, 207)), // Red border
                    side: BorderSide(color: Colors.black), // Red border
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0), // Optional padding
                    child: Center( // Center the text field content
                      child: TextFormField(
                        controller: widget.formClaveCtrl,
                        obscureText: widget._isPasswordVisible,
                        maxLength: 20,
                        decoration: InputDecoration(
                          hintText: "Ingrese su contraseña",
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
                ),

                GestureDetector(
                    onTap: () async {

                      //String usuario = widget.formUsuarioCtrl.text!.toUpperCase();
                      String usuario = widget.formUsuarioCtrl.text!;
                      String contra = widget.formClaveCtrl.text!;
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      //ME QUEDE AQUI
                      if(usuario == "ALBERTO" && contra == "alberto"){
                        await prefs.setString('nombre_completo', "Alberto");
                        await prefs.setString('email', "alberto@gmail.com");
                        await prefs.setString('tipo_usuario', "INVERSOR"); //INTERMEDIARIO
                        await prefs.setString('direccion', "PRUEBA DIRECCION");
                        await prefs.setString('telefono', "PRUEBA TELEFONO");
                        await prefs.setString('documento', "99999999");
                        await prefs.setString('fecha_creacion', "24-12-1999");
                        await prefs.setString('fecha_nacimiento', "24-12-1999");
                        await prefs.setInt('id', 1);

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  Home()),
                        );

                      } else if (usuario == "" || contra == "") {
                        AvisoDialog("Rellene adecuadamente el usuario");
                      } else {

                        //ENTRAR LOGIN EXITOSO

                        usuariotrabajador resp = usuariotrabajador();

                        //CargaDialog();
                        setState(() {mostrarCargar = true;});

                        resp = await widget.apiForm.post_Login(usuario,contra,"CONTRA");



                        if(resp.primer_nombre! == "errorNOENVIADO"){

                          //_mostrarLoadingStreamController.add(true);
                          setState(() {mostrarCargar = false;});

                          AvisoDialog(resp.token!);

                        } else {
                          //_mostrarLoadingStreamController.add(true);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>  Home()),
                          );

                        }

                      }
                    },
                    child: Container(
                      //margin: const EdgeInsets.all(30.0),
                      margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                      alignment: Alignment.center,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        color: Resources.AzulTema,
                      ),
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      child: const Text("Ingresar",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                    )),

                GestureDetector(
                    onTap: () async {

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  Crear_cuenta()),
                      );


                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                      alignment: Alignment.center,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        color: Resources.AzulTema,
                      ),
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      child: const Text("Crear cuenta",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                    )),

                HelpersViewLetrasSubs.formItemsDesign2("Ingreso con redes sociales"),

                Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child:           IconButton(
                            icon: Icon(FontAwesomeIcons.google, size: 50.0, color: Colors.black),
                            onPressed: () async {
                              await _handleSignIn();
                              //GOOGLE INGRESO

                            }
                        ),
                      ),

                      Expanded(
                        flex: 4,
                        child:           IconButton(
                            icon: Icon(FontAwesomeIcons.facebook, size: 50.0, color: Colors.black),
                            onPressed: () async {
                              await _handleSignIn();
                              //FACEBOOK INGRESO

                            }
                        ),
                      ),

                    ]),
              ],
            ),
          ),





          //ENTRADA SIGILOSA
          /*
          GestureDetector(
              onTap: ()  {
                googlelogin();
              },
              child: Container(
                margin: const EdgeInsets.all(10.0),
                alignment: Alignment.center,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  color: Color.fromARGB(255, 27, 65, 187),
                ),
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: const Text("GOOGLE SIGILO TESTEO",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
              )),

           */

        ],
      );
  }


}
