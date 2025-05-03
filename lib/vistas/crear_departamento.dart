import 'dart:async';
import 'dart:convert';
import 'package:digicasa/obj/OBJapartamentos.dart';
import 'package:digicasa/utils/HelpersViewAlertaInfo.dart';
import 'package:digicasa/utils/helpersviewLetrasSubs.dart';
import 'package:digicasa/utils/resources.dart';
import 'package:digicasa/vistas/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/helpers.dart';



class crear_departamento extends StatefulWidget {

  bool parte1 = true;
  bool parte2 = true;
  bool parte3 = true;
  bool parte4 = true;
  bool parte5 = true;

  TextEditingController P01CrearDepaCtrl = TextEditingController();
  final Param01CrearDepaCtrl= List.filled(3, "", growable: false);

  TextEditingController P02CrearDepaCtrl = TextEditingController();
  final Param02CrearDepaCtrl= List.filled(3, "", growable: false);

  TextEditingController P03CrearDepaCtrl = TextEditingController();
  final Param03CrearDepaCtrl= List.filled(3, "", growable: false);

  TextEditingController P04CrearDepaCtrl = TextEditingController();
  final Param04CrearDepaCtrl= List.filled(3, "", growable: false);

  @override
  State<StatefulWidget> createState() => _crear_departamento();
}

enum TipoConstruccion {casa, departamento}

class _crear_departamento extends State<crear_departamento> {

  String? horaFecha;
  String? PREFnroDoc;
  //String? PREFtoken;

  bool Fase1 = true;
  bool Fase2 = false;
  bool Fase3 = false;
  bool Fase4 = false;
  bool Fase5 = false;
  bool Fase6 = false;

  TipoConstruccion? _TipoConstruccion;

  @override
  void initState() {
    datosiniciales();
    super.initState();

  }

  void cleanForm() {
    setState(() {
      Fase1 = true;
      Fase2 = false;
      Fase3 = false;
      Fase4 = false;
      Fase5 = false;
      Fase6 = false;
    });
  }

  Future<void> datosiniciales()  async {

    //HORA
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      horaFecha = Helpers.formatDate("dd/MM/yyyy hh:mm:ss", DateTime.now());
      PREFnroDoc = prefs.getString('documento') ?? "ERROR";
     //var token = prefs.getString('token') ?? "ERROR";
    });

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


  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
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
                MaterialPageRoute(builder: (context) => Home()),
              );
            },
          ),
        ),
        body: Center (
          child: SingleChildScrollView(
            controller: scrollController,
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(41.0),
              child: Form(
                //key: widget.keyForm,
                child: formUI(scrollController),
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget formUI(ScrollController scrollController) {
    return Container(
        child: Column(
        children: [

          //FASE 1
          Visibility(
            visible: Fase1,
            child:Column(
              children: <Widget>[

                const SizedBox(height: 16.0),
                HelpersViewLetrasSubs.titulocolor( "Categorizando el espacio"),


                Column(
                  children: <Widget>[
                    const SizedBox(height: 16.0),
                    HelpersViewLetrasSubs.formItemsDesign( "¿Elija el tipo de construcción que va alquilar?"),
                    //HelpersViewLetrasSubs.formItemsDesignGris("A"),

                    Row(
                      children: [
                        HelpersViewLetrasSubs.formItemsDesignOPTIONTEXT("Casa"),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Radio<TipoConstruccion>(
                            value: TipoConstruccion.casa,
                            groupValue: _TipoConstruccion,
                            onChanged: (TipoConstruccion? value) {
                              setState(() {
                                _TipoConstruccion = value;
                              });
                            },),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        HelpersViewLetrasSubs.formItemsDesignOPTIONTEXT("Departamento"),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Radio<TipoConstruccion>(
                            value: TipoConstruccion.departamento,
                            groupValue: _TipoConstruccion,
                            onChanged: (TipoConstruccion? value) {
                              setState(() {
                                _TipoConstruccion = value;
                              });
                            },),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16.0),
                  ]),


                    GestureDetector(
                        onTap: ()  async {
                          if(  _TipoConstruccion != null ){
                            setState(() {
                              Fase1 = false;
                              Fase2 = true;
                            });

                          } else {
                            AvisoDialog("Falta rellenar algunos campos");
                          }

                          scrollController.animateTo(
                            0.0,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );

                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                          alignment: Alignment.center,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            color: Color.fromARGB(255, 27, 65, 187),
                          ),
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: const Text("Siguiente",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500)),
                        )),


              ],),
          ),


          //FASE 2
          Visibility(
            visible: Fase2,
            child:Column(
              children: <Widget>[

                Row(
                    children: [

                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                          GestureDetector(
                              onTap: ()  async {
                                if( widget.P01CrearDepaCtrl.text != null && widget.P01CrearDepaCtrl.text != "" ){
                                  setState(() {
                                    Fase2 = false;
                                    Fase1 = true;
                                  });

                                } else {
                                  AvisoDialog("Falta rellenar algunos campos");
                                }

                                scrollController.animateTo(
                                  0.0,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );

                              },
                              child: Container(
                                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                                alignment: Alignment.center,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0)),
                                  color: Color.fromARGB(255, 27, 65, 187),
                                ),
                                padding: const EdgeInsets.only(top: 10, bottom: 10),
                                child: const Text("Atras",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                              )),
                        ),
                      ),

                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                          GestureDetector(
                              onTap: ()  async {
                                if( widget.P01CrearDepaCtrl.text != null && widget.P01CrearDepaCtrl.text != "" ){
                                  setState(() {
                                    Fase2 = false;
                                    Fase3 = true;
                                  });

                                } else {
                                  AvisoDialog("Falta rellenar algunos campos");
                                }

                                scrollController.animateTo(
                                  0.0,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );

                              },
                              child: Container(
                                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                                alignment: Alignment.center,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0)),
                                  color: Color.fromARGB(255, 27, 65, 187),
                                ),
                                padding: const EdgeInsets.only(top: 10, bottom: 10),
                                child: const Text("Siguiente",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                              )),
                        ),
                      ),



                    ]
                ),

              ],),
          ),

          //FASE 3
          Visibility(
            visible: Fase3,
            child:Column(
              children: <Widget>[

                Row(
                    children: [

                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                          GestureDetector(
                              onTap: ()  async {
                                if( widget.P01CrearDepaCtrl.text != null && widget.P01CrearDepaCtrl.text != "" ){
                                  setState(() {
                                    Fase3 = false;
                                    Fase2 = true;
                                  });

                                } else {
                                  AvisoDialog("Falta rellenar algunos campos");
                                }

                                scrollController.animateTo(
                                  0.0,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );

                              },
                              child: Container(
                                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                                alignment: Alignment.center,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0)),
                                  color: Color.fromARGB(255, 27, 65, 187),
                                ),
                                padding: const EdgeInsets.only(top: 10, bottom: 10),
                                child: const Text("Atras",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                              )),
                        ),
                      ),

                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                          GestureDetector(
                              onTap: ()  async {
                                if( widget.P01CrearDepaCtrl.text != null && widget.P01CrearDepaCtrl.text != "" ){
                                  setState(() {
                                    Fase3 = false;
                                    Fase4 = true;
                                  });

                                } else {
                                  AvisoDialog("Falta rellenar algunos campos");
                                }

                                scrollController.animateTo(
                                  0.0,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );

                              },
                              child: Container(
                                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                                alignment: Alignment.center,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0)),
                                  color: Color.fromARGB(255, 27, 65, 187),
                                ),
                                padding: const EdgeInsets.only(top: 10, bottom: 10),
                                child: const Text("Siguiente",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                              )),
                        ),
                      ),



                    ]
                ),

              ],),
          ),

          //FASE 4
          Visibility(
            visible: Fase4,
            child:Column(
              children: <Widget>[

                Row(
                    children: [

                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                          GestureDetector(
                              onTap: ()  async {
                                if( widget.P01CrearDepaCtrl.text != null && widget.P01CrearDepaCtrl.text != "" ){
                                  setState(() {
                                    Fase4 = false;
                                    Fase3 = true;
                                  });

                                } else {
                                  AvisoDialog("Falta rellenar algunos campos");
                                }

                                scrollController.animateTo(
                                  0.0,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );

                              },
                              child: Container(
                                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                                alignment: Alignment.center,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0)),
                                  color: Color.fromARGB(255, 27, 65, 187),
                                ),
                                padding: const EdgeInsets.only(top: 10, bottom: 10),
                                child: const Text("Atras",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                              )),
                        ),
                      ),

                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                          GestureDetector(
                              onTap: ()  async {
                                if( widget.P01CrearDepaCtrl.text != null && widget.P01CrearDepaCtrl.text != "" ){
                                  setState(() {
                                    Fase4 = false;
                                    Fase3 = true;
                                  });

                                } else {
                                  AvisoDialog("Falta rellenar algunos campos");
                                }

                                scrollController.animateTo(
                                  0.0,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );

                              },
                              child: Container(
                                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                                alignment: Alignment.center,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0)),
                                  color: Color.fromARGB(255, 27, 65, 187),
                                ),
                                padding: const EdgeInsets.only(top: 10, bottom: 10),
                                child: const Text("Siguiente",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                              )),
                        ),
                      ),



                    ]
                ),

              ],),
          ),

          //FASE 5
          Visibility(
            visible: Fase5,
            child:Column(
              children: <Widget>[

                Row(
                    children: [

                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                          GestureDetector(
                              onTap: ()  async {
                                if( widget.P01CrearDepaCtrl.text != null && widget.P01CrearDepaCtrl.text != "" ){
                                  setState(() {
                                    Fase5 = false;
                                    Fase4 = true;
                                  });

                                } else {
                                  AvisoDialog("Falta rellenar algunos campos");
                                }

                                scrollController.animateTo(
                                  0.0,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );

                              },
                              child: Container(
                                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                                alignment: Alignment.center,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0)),
                                  color: Color.fromARGB(255, 27, 65, 187),
                                ),
                                padding: const EdgeInsets.only(top: 10, bottom: 10),
                                child: const Text("Atras",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                              )),
                        ),
                      ),

                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                          GestureDetector(
                              onTap: ()  async {
                                if( widget.P01CrearDepaCtrl.text != null && widget.P01CrearDepaCtrl.text != "" ){
                                  setState(() {
                                    Fase5 = false;
                                    Fase6 = true;
                                  });

                                } else {
                                  AvisoDialog("Falta rellenar algunos campos");
                                }

                                scrollController.animateTo(
                                  0.0,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );

                              },
                              child: Container(
                                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                                alignment: Alignment.center,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0)),
                                  color: Color.fromARGB(255, 27, 65, 187),
                                ),
                                padding: const EdgeInsets.only(top: 10, bottom: 10),
                                child: const Text("Siguiente",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                              )),
                        ),
                      ),



                    ]
                ),

                //FASE 6



              ],),
          ),

        ],),
    );

  }


}
