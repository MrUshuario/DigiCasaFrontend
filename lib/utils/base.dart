import 'dart:async';
import 'dart:convert';
import 'package:digicasa/obj/OBJapartamentos.dart';
import 'package:digicasa/utils/HelpersViewAlertaInfo.dart';
import 'package:digicasa/utils/resources.dart';
import 'package:digicasa/vistas/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class Modelo_vacio extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _Modelo_vacio();
}
enum TipoEmprendimiento {Si, No}
class _Modelo_vacio extends State<Modelo_vacio> {
  TipoEmprendimiento? _TipoEmprendimiento;
  @override
  void initState() {
    funcion();
    super.initState();

  }

  void funcion()  {

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
