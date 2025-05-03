import 'dart:async';
import 'dart:convert';
//import 'package:digicasa/database/database.dart';
import 'package:digicasa/infraestructure/apis/apiprovider_formulario.dart';
import 'package:digicasa/obj/OBJPaginado_Apartamento.dart';
import 'package:digicasa/obj/OBJapartamentos.dart';
import 'package:digicasa/obj/OBJinversion.dart';
import 'package:digicasa/utils/HelpersViewAlertaInfo.dart';
import 'package:digicasa/utils/helpersviewAlertProgressCircle.dart';
import 'package:digicasa/utils/helpersviewInputs.dart';
import 'package:digicasa/utils/helpersviewLetrasSubs.dart';
import 'package:digicasa/utils/resources.dart';
import 'package:digicasa/vistas/crear_departamento.dart';
import 'package:digicasa/vistas/departamento_detalle.dart';
import 'package:digicasa/vistas/opciones_cartera.dart';
import 'package:digicasa/vistas/usuarioperfil.dart';
import 'package:digicasa/vistas/inversiones_detalle.dart';
import 'package:digicasa/vistas/inversiones_general.dart';
import 'package:digicasa/vistas/login.dart';
import 'package:digicasa/vistas/usuario.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'mis_departamentos.dart';





class Home extends StatefulWidget {

  //API
  //PAGINADO
  int? total = 0;
  int? page = 1;
  int? totalPage = 0;
  int? porpagina = 15;

  apiprovider_formulario apiForm= apiprovider_formulario();

  String distritobuscar = "";

  //filtro
  TextEditingController inversionmin = TextEditingController();
  TextEditingController inversionmax = TextEditingController();


  //LISTA QUE SE MUESTRA PRIMERO
  List<Apartamento> listApartamentos = List.empty(growable: true);
  //LISTA QUE SE MUESTRA SEGUNDO
  List<AportacionEmpresarial> listInversiones = List.empty(growable: true);
  List<AportacionEmpresarial> listInversionesAux = List.empty(growable: true);
  //DETALLE
  Apartamento formDetalle = Apartamento();

  //LISTA DE COLORES ICONOS BOTONES
  bool activadoCasa = false;
  bool activadoHabitacion = false;
  bool activadoComunitario = false;
  bool activadoAlquilados = false;
  bool activadoSinAlquilar= false;
  bool activadoGaraje = false;
  bool activadoZonaTuristica = false;

  Color botoniconDesactivado = Resources.botoniconDesactivado;
  Color botoniconActivado = Resources.botoniconActivado;


  @override
  State<StatefulWidget> createState() => _Home();
}

class _Home extends State<Home> {
  bool mostrarCargar = true;
  int currentPageIndex = 0;
  String? PREFname; //1er nombre 2do nombre apellidos
  String? PREFtipo;

  //VISTAS SEGUN TIPO USUARIO
  bool VistaUsuarioIntermediario= false;
  bool VistaUsuarioDepartamento = false;
  //String? PREFcorreo;


  @override
  void initState() {
    cargardepartamentos("");
    cargardataprueba();
    cargardatosiniciales();
    super.initState();

  }

  void aplicarfiltros(int min, int max) {


    widget.listInversiones.removeWhere((inversion) =>
    inversion.montoInversion! > max || inversion.montoInversion! < min
    );
  }

  void borrarfiltros (){
    widget.listInversionesAux = widget.listInversiones;
  }

  Future<void> cargardatosiniciales()  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      PREFname = prefs.getString('nombre_completo') ?? "USUARIO PRUEBA";
      PREFtipo = prefs.getString('tipo_usuario') ?? "INVERSOR";
      //PREFcorreo = prefs.getString('email') ?? "prueba@gmail.com";
    });

    if(PREFtipo == "INVERSOR"){
      VistaUsuarioDepartamento= true;
    } else  if(PREFtipo == "arrendatario"){
      VistaUsuarioIntermediario = true;
    }

  }

  void SalirCuenta() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name',"USUARIO PRUEBA");
    await prefs.setString('documento', "");
    await prefs.setString('tipo_usuario', "");
  }

  Future<void> cargardepartamentos(String buscartexto)  async {
    print("mostrarCargar = true;");
    setState(() {
      mostrarCargar = true;
    });

    Paginado_apartamento auxpaginado  = await widget.apiForm.get_DescargarApartamento(buscartexto);
    //_mostrarLoadingStreamController.add(true);

    print("mostrarCargar = true;");
    setState(() {
      widget.total = auxpaginado.total;
      widget.page = auxpaginado.current_page;
      widget.totalPage = auxpaginado.total;
      widget.porpagina = auxpaginado.per_page;
      widget.listApartamentos =  auxpaginado.data!.cast<Apartamento>();
      mostrarCargar = false;
    });

  }



  Future<void> cargardataprueba()  async {
    widget.inversionmin!.text = "0";
    widget.inversionmax!.text = "90000";


    for (int i = 1; i <= 10; i++) {
      /*
      Apartamento objaux = Apartamento();
      objaux.idDepartamento = i;
      objaux.imagen = "https://picsum.photos/250?image=3";
      objaux.descripcion = "Por el momento";
      objaux.precio = ((i+1)*100).toString();
      widget.listApartamentos.add(objaux); */

      AportacionEmpresarial objaux2 = AportacionEmpresarial();
      objaux2.codigoInversion = i;
      objaux2.codigoFondo = "A0BC$i";
      objaux2.nombreInversion = "Comprado Habitación";
      objaux2.montoInversion = 1000+(i*100);
      objaux2.porcentajeInteres = 2;
      //objaux2.montoBeneficioTotal = (i+1)*100;
      objaux2.fechaInversion = "12/09/2024";
      widget.listInversiones.add(objaux2);
      widget.listInversionesAux = widget.listInversiones;
    }
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
                      texto: "Búsqueda realizada",
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

  Future<void> listarVisitasAvanzar() async {
    var pages = widget.page!+1;
    if(widget.totalPage! >= pages) {
      String buscarpag = "?page=${widget.page}";
      await cargardepartamentos(buscarpag);
    }

    setState(() {});
  }

  Future<void> listarVisitasRetro() async {

    var pages = widget.page!-1;
    if(pages > 0) {
      String buscarpag = "?page=${widget.page}";
      await cargardepartamentos(buscarpag);
    }

    setState(() {});
  }


  void filtro(String boton)  {
    setState(() {
      switch (boton) {
        case "a":

          if(widget.activadoCasa){
            widget.activadoCasa = false;
          } else {
            widget.activadoCasa = true;

            widget.activadoHabitacion = false;
            widget.activadoComunitario = false;
            widget.activadoAlquilados = false;
            widget.activadoSinAlquilar= false;
            widget.activadoGaraje = false;
            widget.activadoZonaTuristica = false;
          }

        case "b":

          if(widget.activadoHabitacion){
            widget.activadoHabitacion = false;
          } else {
            widget.activadoHabitacion = true;

            widget.activadoCasa = false;
            widget.activadoComunitario = false;
            widget.activadoAlquilados = false;
            widget.activadoSinAlquilar= false;
            widget.activadoGaraje = false;
            widget.activadoZonaTuristica = false;

          }

        case "c":

          if(widget.activadoComunitario){
            widget.activadoComunitario = false;
          } else {
            widget.activadoComunitario = true;

            widget.activadoCasa = false;
            widget.activadoHabitacion = false;
            widget.activadoAlquilados = false;
            widget.activadoSinAlquilar= false;
            widget.activadoGaraje = false;
            widget.activadoZonaTuristica = false;

          }

        case "d":

          if(widget.activadoAlquilados){
            widget.activadoAlquilados = false;
          } else {
            widget.activadoAlquilados = true;

            widget.activadoCasa = false;
            widget.activadoHabitacion = false;
            widget.activadoComunitario = false;
            widget.activadoSinAlquilar= false;
            widget.activadoGaraje = false;
            widget.activadoZonaTuristica = false;

          }

        case "e":

          if(widget.activadoSinAlquilar){
            widget.activadoSinAlquilar = false;
          } else {
            widget.activadoSinAlquilar = true;

            widget.activadoCasa = false;
            widget.activadoHabitacion = false;
            widget.activadoComunitario = false;
            widget.activadoAlquilados = false;
            widget.activadoGaraje = false;
            widget.activadoZonaTuristica = false;

          }

        case "f":

          if(widget.activadoGaraje){
            widget.activadoGaraje = false;
          } else {
            widget.activadoGaraje = true;

            widget.activadoCasa = false;
            widget.activadoHabitacion = false;
            widget.activadoComunitario = false;
            widget.activadoAlquilados = false;
            widget.activadoSinAlquilar= false;
            widget.activadoZonaTuristica = false;

          }

        case "g":

          if(widget.activadoZonaTuristica){
            widget.activadoZonaTuristica = false;
          } else {
            widget.activadoZonaTuristica = true;

            widget.activadoCasa = false;
            widget.activadoHabitacion = false;
            widget.activadoComunitario = false;
            widget.activadoAlquilados = false;
            widget.activadoSinAlquilar= false;
            widget.activadoGaraje = false;

          }

      }
    });
  }

  void FiltromalDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Image.asset(Resources.iconInfo),
              SizedBox(width: 4), // Espacio entre el icono y el texto
              const Expanded(
                child: Text(
                  'Introdusca valores válidos',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 20, // Tamaño de fuente deseado
                  ),
                ),
              ),
            ],
          ),
          actions: [
            OverflowBar(
              alignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cerrar',
                    style: TextStyle(
                      fontSize: 18,
                    ),),
                ),
              ],
            ),
          ],
        );
      },
    );

  }

  void showfiltromodal() {

    showDialog(
        context: context,
        builder: (BuildContext context) {
          //TALVEZ SIRVA TALVEZ NO
          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                    backgroundColor: Colors.white,
                    title: const Text(
                    'Filtrado por Monto:',
                    style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                ),
                ),
                content: SizedBox(
                width: double.maxFinite,
                height: double.maxFinite,
                child: Column(
                  children: [

                    Row(
                    children: [
                  const Text('Monto mínimo:', style: TextStyle(
                    fontSize: 12.0,
                    //color: Colors.white,
                  ),),

                    HelpersViewInputs.formItemsDesigndocumento(
                        TextFormField(
                          controller: widget.inversionmin,
                          //initialValue: '0',
                          decoration: const InputDecoration(
                            labelText: '€',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          maxLength: 8,
                        ), context),
                    Icon(Icons.monetization_on, size: 20.0, color: Colors.black),],
                    ),

                    Row(
                      children: [

                    const Text('Monto máximo:', style: TextStyle(
                    fontSize: 12.0,
                    //color: Colors.white,
                    ),),

                    HelpersViewInputs.formItemsDesigndocumento(
                    TextFormField(
                      controller: widget.inversionmax,
                     // initialValue: '0',
                      decoration: const InputDecoration(
                      labelText: '€',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 8,
                    ), context),

                    Icon(Icons.monetization_on, size: 20.0, color: Colors.black),

                  ],
                    ),

                    //BOTON FILTRO
                    GestureDetector(
                        onTap: ()  {
                          int valmin = 0;
                          int valmax = 90000;


                          if(widget.inversionmin.text != "" ) {
                            valmin =int.parse(widget.inversionmin.text!);
                          }
                          if(widget.inversionmax.text != "")  {
                            valmax =int.parse(widget.inversionmax.text!);
                          }
                          if( widget.inversionmax.text != "" && widget.inversionmin.text != "")  {
                            aplicarfiltros(valmin, valmax);
                          } else {
                            FiltromalDialog();
                          }

                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                          alignment: Alignment.center,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            color: widget.botoniconDesactivado,
                          ),
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: const Text("Aplicar Filtros",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500)),
                        )),

                    const SizedBox(height: 8.0),

                    GestureDetector(
                        onTap: () async {
                          borrarfiltros();
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                          alignment: Alignment.center,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            color: Colors.red,
                          ),
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: const Text("Borrar Filtros",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500)),
                        )),


                  ]),
                ),

                );
          },);
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true, //SACA LA BARRA DEBUG
      home: Scaffold(
        body: <Widget>[

        Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                Resources.backgroundAzul, // Replace with your image path
                fit: BoxFit.cover, // Adjust fit as needed
              ),
            ),

            // Existing content with Center, SingleChildScrollView, and Container
            //Center( child:
            SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  child: Form(
                    //key: widget.keyForm,
                    child: formUI(),
                  ),
                ),
              ),
           // ),
          ],
        ),

          //PARTE2
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                child: Image.asset(
                  Resources.backgroundAzul, // Replace with your image path
                  fit: BoxFit.cover, // Adjust fit as needed
                ),
              ),

              // Existing content with Center, SingleChildScrollView, and Container
              //Center( child:
              SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  child: Form(
                    //key: widget.keyForm,
                    child: formUI2(),
                  ),
                ),
              ),
              // ),
            ],
          ),

          //PARTE3
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                child: Image.asset(
                  Resources.backgroundAzul, // Replace with your image path
                  fit: BoxFit.cover, // Adjust fit as needed
                ),
              ),

              // Existing content with Center, SingleChildScrollView, and Container
              //Center( child:
              SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  child: Form(
                    //key: widget.keyForm,
                    child: formUI3(),
                  ),
                ),
              ),
              // ),
            ],
          ),


        ][currentPageIndex],

        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: Resources.AzulTema,
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[

            NavigationDestination(
              selectedIcon: Icon(Icons.home, color: Colors.white),
              icon: Icon(Icons.home_outlined, color: Colors.black),
              label: 'Departamentos',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.monetization_on, color: Colors.white),
              icon: Icon(Icons.monetization_on_outlined, color: Colors.black),
              label: 'Inversiones',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.account_box_rounded, color: Colors.white),
              icon: Icon(Icons.account_box_outlined, color: Colors.black),
              label: 'Cuenta',
            ),
          ],
        ),

      ),
    );
  }


  //Filtro
  void logoutFunction() {
    String titulo = "¿Desea Salir?";
    String subtitulo = "Aceptar";
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
              contentPadding: EdgeInsets.all(0),
              content: SingleChildScrollView(
                  child: Column(
                    children: [
                      HelpersViewAlertaInfo.formItemsDesign(titulo,subtitulo),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.end, // Align row to the end
                        children: [
                        ],
                      ),
                    ],
                  )
              )
          );
        }
    );
  }

  /*
  void CambiarPagina(Apartamento obj) {
    setState(() {
      widget.formDetalle = obj;
      currentPageIndex = 3;
    });
  } */


  Widget formUI2() {
    return Container(
        child: Column(
        children: [

          Padding(
            padding: const EdgeInsets.only(top: 25.0, bottom: 8.0, left: 8.0, right: 8.0),
            child:
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child:

                  GestureDetector(
                      onTap: ()   async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Inversiongeneral()),
                        );
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
                              Icons.account_box_outlined, size: 50.0, color: Colors.white,
                            ),
                            Text("Resumen General", style: TextStyle(color: Colors.white)), // Your text
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
                    onTap: ()   async {
                      showfiltromodal();
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
                        Text("Filtrar resultados", style: TextStyle(color: Colors.white)), // Your text
                        SizedBox(height: 5.0),

                      ],
                    ),
                  ),
                  ),
                ),

              ],
            ),
          ),

          HelpersViewLetrasSubs.formItemsDesignLineaGris(),
          //
          Padding(
            padding: const EdgeInsets.all(5), // POR ALGUN MOTIVO NO SE CENTRA ASI QUE PONGO POR EL MOMENTO
            child:
            SizedBox(
                width: MediaQuery.of(context).size.height * 0.90,
                height: MediaQuery.of(context).size.height * 0.70,
                child:
                widget.listInversiones.isNotEmpty
                    ? ListView.builder(itemCount: widget.listInversiones!.length,
                  itemBuilder: (context, index) {
                    return Card(
                        child: InkWell(
                        onTap: () {
                          //IR A DETALLE
                          AportacionEmpresarial objaux = AportacionEmpresarial();
                          objaux = widget.listInversiones![index];
                          //CambiarPagina(objaux);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Inversiondetalle(objaux)),
                          );
                          },
                            child:

                            Padding(
                            padding: const EdgeInsets.all(5), // POR ALGUN MOTIVO NO SE CENTRA ASI QUE PONGO POR EL MOMENTO
                            child:

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                SizedBox(height: MediaQuery.of(context).size.height * 0.020,),

                                HelpersViewLetrasSubs.formItemsDesign(
                                    "${widget.listInversiones![index].codigoInversion}) Nombre: "
                                        "${widget.listInversiones![index].nombreInversion}"),


                                HelpersViewLetrasSubs.formItemsDesign(
                                    "Inversion: ${widget.listInversiones![index].montoInversion}"),


                                HelpersViewLetrasSubs.formItemsDesign(
                                    "Fecha inversion: ${widget.listInversiones![index].fechaInversion}"),

                              ],
                            ),
                            ),
                        ),
                    );
                  },)
                    :  Container(
                  child:  Column(
                      children: [
                        Center(
                          child: HelpersViewLetrasSubs.formItemsDesign(
                              "Usted no ha hecho ninguna inversión"),
                        )

                      ]
                  ),
                )

            ),
          ),

        ]),
    );
  }

  Widget formUI3() {
    return Container(
      child:
        Padding(
        padding: const EdgeInsets.only(top: 30.0, bottom: 8.0, left: 8.0, right: 8.0),
    child:
      Column(
          children: [

            Card(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 100,
                      width: 100,
                      child: const Column(
                        // Add spacing between icon and text (optional)
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                         Icon(Icons.house_rounded, size: 50.0, color: Colors.black),
                        ],
                      ),
                    ),
                  ),


                  Expanded(
                    flex: 5,
                    child:
                    Column(
                      children: [
                        HelpersViewLetrasSubs.formItemsDesign("$PREFname"),
                      ],),
                  ),

                  Expanded(
                    flex: 2,
                    child:
                    IconButton(
                      icon: const Icon(Icons.arrow_forward, size: 50.0, color: Colors.black),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Usuario_perfil()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10.0),
            HelpersViewLetrasSubs.formItemsDesignLinea(),
            const SizedBox(height: 10.0),
            //

            Visibility(
              visible: VistaUsuarioIntermediario,
              child:
                Column(
                children: [
                HelpersViewLetrasSubs.formItemsDesignBig("Inversor"),

                  GestureDetector(
                      onTap: ()   async {

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => crear_departamento()),
                        );

                      },
                      child: Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child:
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                child: Column(
                                  // Add spacing between icon and text (optional)
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.house_outlined, size: 50.0, color: Colors.black),
                                      onPressed: () {
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child:
                              Column(
                                children: [
                                  HelpersViewLetrasSubs.formItemsDesign("Crear Departamento"),
                                ],),
                            ),
                          ],
                        ),
                      )),

                  HelpersViewLetrasSubs.formItemsDesignLinea(),
                  const SizedBox(height: 10.0),

                ],
            ),
          ),

            Visibility(
              visible: VistaUsuarioDepartamento ,
              child:
              Column(
              children: [
              HelpersViewLetrasSubs.formItemsDesignBig("Mis Departamentos"),

                GestureDetector(
                    onTap: ()   async {

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => mis_departamentos()),
                      );

                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child:
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              child: Column(
                                // Add spacing between icon and text (optional)
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.house, size: 50.0, color: Colors.black),
                                    onPressed: () {
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child:
                            Column(
                              children: [
                                HelpersViewLetrasSubs.formItemsDesign("Registro"),
                              ],),
                          ),
                        ],
                      ),
                    )),

                HelpersViewLetrasSubs.formItemsDesignLinea(),
                const SizedBox(height: 10.0),

              ],
            )
            ),


            HelpersViewLetrasSubs.formItemsDesignBig("Configuración"),


            GestureDetector(
                onTap: ()   async {

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => login()),
                  );

                },
                child: Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child:
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Column(
                            // Add spacing between icon and text (optional)
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.shield_outlined, size: 50.0, color: Colors.black),
                                onPressed: () {
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child:
                        Column(
                          children: [
                            HelpersViewLetrasSubs.formItemsDesign("Sesión y Seguridad"),
                          ],),
                      ),
                    ],
                  ),
                )),

            HelpersViewLetrasSubs.formItemsDesignLinea(),
            const SizedBox(height: 10.0),
            GestureDetector(
                onTap: ()   async {

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => login()),
                  );

                },
                child: Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child:
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Column(
                            // Add spacing between icon and text (optional)
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.language, size: 50.0, color: Colors.black),
                                onPressed: () {
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child:
                        Column(
                          children: [
                            HelpersViewLetrasSubs.formItemsDesign("Tradución"),
                          ],),
                      ),
                    ],
                  ),
                )),
            HelpersViewLetrasSubs.formItemsDesignLinea(),
            const SizedBox(height: 10.0),
            /*
            GestureDetector(
                onTap: ()   async {

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  Opcionescartera()),
                  );

                },
                child: Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child:
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Column(
                            // Add spacing between icon and text (optional)
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.wallet, size: 50.0, color: Colors.black),
                                onPressed: () {
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child:
                        Column(
                          children: [
                            HelpersViewLetrasSubs.formItemsDesign("Pagos y cobros"),
                          ],),
                      ),
                    ],
                  ),
                )),
            HelpersViewLetrasSubs.formItemsDesignLinea(),
            const SizedBox(height: 10.0),
            */
            GestureDetector(
                onTap: ()   async {

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => login()),
                  );

                },
                child: Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child:
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Column(
                            // Add spacing between icon and text (optional)
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.campaign, size: 50.0, color: Colors.black),
                                onPressed: () {
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child:
                        Column(
                          children: [
                            HelpersViewLetrasSubs.formItemsDesign("Notificaciones"),
                          ],),
                      ),
                    ],
                  ),
                )),
            HelpersViewLetrasSubs.formItemsDesignLinea(),
            const SizedBox(height: 10.0),

            Column(
              children: [
                  const SizedBox(height: 15.0),

                GestureDetector(
                    onTap: ()   async {

                      SalirCuenta();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => login()),
                      );
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
                      child: const Text("Cerrar Sesion",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                    )),

              ],),



          ]),

        ),
    );
  }




  Widget formUI() {
    return Container(
        child: Column(
        children: [
          //PARTE 2 FILTROS
          Container(
            margin: const EdgeInsets.only(top: 20.0),
            child: Padding(
              padding: const EdgeInsets.all(0), // Add margin here
              child: Row(
                  children: [


                    Padding(
                        padding: const EdgeInsets.all(10), // Add margin here
                        child: Row(
                            children: [

                            ])
                    ),


                    Expanded(
                      flex: 8,
                      child: SearchAnchor(
                      builder: (BuildContext context, SearchController controller) {
                        return SearchBar(
                          controller: controller,
                          padding: const MaterialStatePropertyAll<EdgeInsets>(
                              EdgeInsets.symmetric(horizontal: 16)),
                          onTap: (){
                            controller.openView();

                            widget.distritobuscar = controller.text;
                            print("DISTRITO:");
                            print(widget.distritobuscar);
                          },
                          onChanged: (_){
                            controller.openView();
                            widget.distritobuscar = controller.text;
                            print("DISTRITO2:");
                            print(widget.distritobuscar);
                          },
                          leading: HelpersViewLetrasSubs.formItemsDesignGrisSinexpanded("Distrito:"),

                          trailing: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.search_sharp),
                              onPressed: () async {

                                String textobuscar = controller.text;
                                //CargaDialog();
                                //CARGAR API
                                await cargardepartamentos(textobuscar);
                                //Paginado_apartamento auxpaginado  = await widget.apiForm.get_DescargarApartamento(textobuscar);
                                //widget.listApartamentos =  auxpaginado.data!.cast<Apartamento>();

                                //TERMINANDO
                                //_mostrarLoadingStreamController.add(true);

                              }
                            ),
                          ],
                        );
                      },
                      suggestionsBuilder: (BuildContext context, controller){
                        return List<ListTile>.generate(Resources.DistritosLima.length, (int index) {
                          final String item = Resources.DistritosLima[index];
                          return ListTile(
                            title: Text(item),
                            onTap: (){
                              setState(() {
                                controller.closeView(item);
                                print("PRUEBA AAA");
                                widget.distritobuscar = controller.text;
                                print(controller.text);
                              });
                            },
                          );
                        });
                      }
                  ),
                  ),


                  Expanded(
                    flex: 2,
                    child:
                    GestureDetector(
                        onTap: () async {

                          /*
                          String textobuscar = widget.distritobuscar;
                          print(textobuscar);
                          CargaDialog();
                          //CARGAR API
                          List<Apartamento> ApartamentoEntity  = await widget.apiForm.get_DescargarApartamento(textobuscar);
                          widget.listApartamentos = ApartamentoEntity;
                          //TERMINANDO
                          _mostrarLoadingStreamController.add(true); */

                        },
                        child: Container(
                          margin: const EdgeInsets.all(10.0),
                          alignment: Alignment.center,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            color: Resources.AzulTema,
                          ),
                          padding: const EdgeInsets.only(top: 16, bottom: 16),
                          child: const Icon(
                          Icons.format_line_spacing, // Replace "e" with Icons.search
                          color: Colors.black,
                        ),
                        )),
                  )


                  ]
              ),
            ),
          ),

          //FILTRO
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            child:
              Scrollbar(
                thickness: 9.0,
                radius: Radius.circular(5.0),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Row(
                      children: [

                        Padding(padding: EdgeInsets.all(5.0),
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                color: widget.activadoCasa ? widget.botoniconDesactivado : widget.botoniconActivado,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                // Add spacing between icon and text (optional)
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.house, size: 50.0, color: Colors.black),
                                    onPressed: () {
                                      filtro("a");
                                    },
                                  ),
                                  const Text("Casa", style: TextStyle(color: Colors.black)), // Your text
                                  const SizedBox(height: 5.0),
                                ],
                              ),

                            )
                        ),

                        Padding(padding: EdgeInsets.all(5.0),
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                color: widget.activadoHabitacion ? widget.botoniconDesactivado : widget.botoniconActivado,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                // Add spacing between icon and text (optional)
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.bed, size: 50.0, color: Colors.black),
                                    onPressed: () {
                                      filtro("b");
                                    },
                                  ),
                                  const Text("Habitación", style: TextStyle(color: Colors.black)), // Your text
                                  const SizedBox(height: 5.0),
                                ],
                              ),
                            )
                        ),

                        Padding(padding: EdgeInsets.all(5.0),
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                color: widget.activadoComunitario ? widget.botoniconDesactivado : widget.botoniconActivado,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                // Add spacing between icon and text (optional)
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.reduce_capacity, size: 50.0, color: Colors.black),
                                    onPressed: () {
                                      filtro("c");
                                    },
                                  ),
                                  const Text("Comunitario", style: TextStyle(color: Colors.black)), // Your text
                                  const SizedBox(height: 5.0),
                                ],
                              ),
                            )
                        ),


                        Padding(padding: EdgeInsets.all(5.0),
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                color: widget.activadoAlquilados ? widget.botoniconDesactivado : widget.botoniconActivado,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                // Add spacing between icon and text (optional)
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.monetization_on, size: 50.0, color: Colors.black),
                                    onPressed: () {
                                      filtro("d");
                                    },
                                  ),
                                  const Text("Alquilados", style: TextStyle(color: Colors.black)), // Your text
                                  const SizedBox(height: 5.0),
                                ],
                              ),
                            )
                        ),

                        Padding(padding: EdgeInsets.all(5.0),
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                color: widget.activadoSinAlquilar ? widget.botoniconDesactivado : widget.botoniconActivado,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                // Add spacing between icon and text (optional)
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.access_time, size: 50.0, color: Colors.black),
                                    onPressed: () {
                                      filtro("e");
                                    },
                                  ),
                                  const Text("Sin alquilar", style: TextStyle(color: Colors.black)), // Your text
                                  const SizedBox(height: 5.0),
                                ],
                              ),
                            )
                        ),


                        Padding(padding: EdgeInsets.all(5.0),
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                color: widget.activadoGaraje ? widget.botoniconDesactivado : widget.botoniconActivado,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                // Add spacing between icon and text (optional)
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.garage, size: 50.0, color: Colors.black),
                                    onPressed: () {
                                      filtro("f");
                                    },
                                  ),
                                  const Text("Garaje", style: TextStyle(color: Colors.black)), // Your text
                                  const SizedBox(height: 5.0),
                                ],
                              ),
                            )
                        ),

                        Padding(padding: EdgeInsets.all(5.0),
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                color: widget.activadoZonaTuristica ? widget.botoniconDesactivado : widget.botoniconActivado,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                // Add spacing between icon and text (optional)
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.local_play_sharp, size: 50.0, color: Colors.black),
                                    onPressed: () {
                                      filtro("g");
                                    },
                                  ),
                                  const Text("Zona Turistica", style: TextStyle(color: Colors.black)), // Your text
                                  const SizedBox(height: 5.0),
                                ],
                              ),
                            )
                        ),

                      ],
                    ),
                  ],
                ),
              ),
          ),

          Container(
            margin: EdgeInsets.only(left: 20.0, top: MediaQuery.of(context).size.height * 0.020, bottom: MediaQuery.of(context).size.height * 0.020),
            alignment: Alignment.centerLeft,
            child: Text(
              "Departamentos listados: ${widget.porpagina}",
              textAlign: TextAlign.left,
            ),
          ),

          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // Center horizontally
              children: [
                GestureDetector(
                  onTap: () async {
                    await listarVisitasRetro();
                  },
                  child: Image.asset(Resources.inconflechaD, width: 48, height: 48), //
                ),


                Text(
                  "${widget.page}/${widget.totalPage}", //DEBO PONER EL TOTAL ENTRE 1
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
                GestureDetector(
                  onTap: () async {
                    await listarVisitasAvanzar();
                  },
                  child: Image.asset(Resources.inconflechaI, width: 48, height: 48),
                )

                // Add Textfield with appropriate margin
              ],
            ),
          ),


          //PARTE 3 CUERPO
//
          Visibility(
            visible: mostrarCargar,
            child: Container(
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
            Padding(
                padding: const EdgeInsets.only(left: 10), // POR ALGUN MOTIVO NO SE CENTRA ASI QUE PONGO POR EL MOMENTO
                child:
                  SizedBox(
                  width: double.maxFinite,
                  height: MediaQuery.of(context).size.height * 0.62,
                  child:
                      widget.listApartamentos.isNotEmpty
                                ? ListView.builder(itemCount: widget.listApartamentos!.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  //margin: EdgeInsets.zero,
                                  child: InkWell(
                                    onTap: () {
                                      //IR A DETALLE
                                      Apartamento objaux = Apartamento();
                                      objaux = widget.listApartamentos![index];
                                      //CambiarPagina(objaux);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => Detalle(objaux)),
                                      );

                                    },
                                    child: ListTile(
                                      title:
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10.0), // Adjust as desired
                                          child: Image.network(
                                            widget.listApartamentos![index].images?.first != null
                                                ? widget.listApartamentos![index].images?.first
                                                : 'https://picsum.photos/250?image=3',
                                            width: double.maxFinite,
                                            height: 200.0,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              // Handle the error here
                                              return
                                                //Center(child: Text('Error loading image'));
                                                Image.network('https://picsum.photos/250?image=3',
                                                  width: double.maxFinite,
                                                  height: 200.0,
                                                  fit: BoxFit.cover
                                                );
                                            },
                                          ),
                                        ),

                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          SizedBox(height: MediaQuery.of(context).size.height * 0.020,),

                                          Text("${widget.listApartamentos![index].id} ${widget.listApartamentos![index].descripcion}",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: const TextStyle(
                                              fontSize: 15.0,
                                            ),
                                          ),

                                          SizedBox(height: 20),
                                          HelpersViewLetrasSubs.formItemsDesignSubSinexpandir(widget.listApartamentos[index].mensualidad ?? 'SIN DEFINIR PRECIO', "€"), //NULL CHECK OPERATOR USED ON A NULL VALUE //
                                          SizedBox(height: 20),

                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },)
                                : Center(
                        child: HelpersViewLetrasSubs.formItemsDesign(
                            "Seleccione los filtros para buscar"),
                      ),
                  ),
            ),
          ),





        ],),
    );

  }


}
