import 'dart:async';
import 'dart:convert';
import 'package:digicasa/obj/OBJapartamentos.dart';
import 'package:digicasa/obj/OBJtarjeta.dart';
import 'package:digicasa/utils/HelpersViewAlertaInfo.dart';
import 'package:digicasa/utils/helpersviewLetrasSubs.dart';
import 'package:digicasa/utils/resources.dart';
import 'package:digicasa/vistas/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



class Opcionescartera extends StatefulWidget {

  //LISTA QUE SE MUESTRA SEGUNDO
  List<Tarjeta> listTarjetas = List.empty(growable: true);
  
  Opcionescartera({super.key});

  @override
  State<StatefulWidget> createState() => _Opcionescartera();
}

class _Opcionescartera extends State<Opcionescartera> {

  @override
  void initState() {
    cargardataprueba();
    super.initState();

  }

  void cargardataprueba()  {

    for (int i = 1; i <= 9; i++) {

      Tarjeta objaux = Tarjeta();
      objaux.codigotarjeta = i;
      objaux.numero = "9999999999999999";
      objaux.numeroinicio = "000$i";
      objaux.fechavencimiento = "a";
      objaux.tipo = "VISA";
      objaux.token = "a";
      widget.listTarjetas.add(objaux);
    }

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
                            Icon(Icons.credit_card, size: 50.0, color: Colors.black),
                          ],
                        ),
                      ),
                    ),


                    Expanded(
                      flex: 5,
                      child:
                      Column(
                        children: [
                          HelpersViewLetrasSubs.formItemsDesign("Agregar Tarjeta"),
                        ],),
                    ),

                    Expanded(
                      flex: 2,
                      child:
                      IconButton(
                        icon: const Icon(Icons.add, size: 50.0, color: Colors.black),
                        onPressed: () {
                          /*
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Usuario_perfil()),
                          );
                           */
                        },
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
                    widget.listTarjetas.isNotEmpty
                        ? ListView.builder(itemCount: widget.listTarjetas!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child:

                            Padding(
                              padding: const EdgeInsets.all(5), // POR ALGUN MOTIVO NO SE CENTRA ASI QUE PONGO POR EL MOMENTO
                              child:

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  SizedBox(height: MediaQuery.of(context).size.height * 0.020,),

                                  HelpersViewLetrasSubs.formItemsDesignBig(
                                      "${widget.listTarjetas![index].numeroinicio} **** **** ****"),

                                  Row(
                                    children: [

                                       Expanded(
                                        flex: 2,
                                        child: Icon(FontAwesomeIcons.ccVisa, size: 50.0, color: Colors.black),
                                      ),

                                      const Expanded(
                                        flex: 1,
                                        child: SizedBox(height: 2.0),
                                      ),

                                      Expanded(
                                        flex: 4,
                                        child: Text(
                                          "${widget.listTarjetas![index].tipo}",
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),

                                      const Expanded(
                                        flex: 1,
                                        child: SizedBox(height: 2.0),
                                      ),

                                      Expanded(
                                        flex: 2,
                                        child: IconButton(
                                          icon: const Icon(Icons.delete, size: 50.0, color: Colors.black),
                                          onPressed: () {
                                            Tarjeta objaux = Tarjeta();
                                            objaux = widget.listTarjetas![index];

                                          },
                                        ),
                                      ),

                                    ],
                                  )






                                ],
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


}
