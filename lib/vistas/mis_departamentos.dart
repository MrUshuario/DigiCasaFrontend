import 'dart:async';
import 'dart:convert';
import 'package:digicasa/obj/OBJapartamentos.dart';
import 'package:digicasa/utils/HelpersViewAlertaInfo.dart';
import 'package:digicasa/utils/resources.dart';
import 'package:digicasa/vistas/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/helpers.dart';



class mis_departamentos extends StatefulWidget {

  bool parte1 = true;
  bool parte2 = true;
  bool parte3 = true;
  bool parte4 = true;
  bool parte5 = true;

  TextEditingController formP03EspecificarCtrl = TextEditingController();
  final ParamP03EspecificarCtrl = List.filled(3, "", growable: false);

  @override
  State<StatefulWidget> createState() => _mis_departamentos();



}

enum TipoEmprendimiento {Si, No}

class _mis_departamentos extends State<mis_departamentos> {

  String? horaFecha;
  String? PREFnroDoc;
  String? PREFtoken;

  TipoEmprendimiento? _TipoEmprendimiento;
  
  @override
  void initState() {
    datosiniciales();
    super.initState();

  }

  Future<void> datosiniciales()  async {

    //HORA
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      horaFecha = Helpers.formatDate("dd/MM/yyyy hh:mm:ss", DateTime.now());
      PREFnroDoc;
      PREFtoken;
    });

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
                MaterialPageRoute(builder: (context) => Home()),
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


        ],),
    );

  }


}
