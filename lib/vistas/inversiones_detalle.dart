import 'dart:async';

import 'package:digicasa/obj/OBJinversion.dart';
import 'package:digicasa/utils/helpersviewAlertProgressCircle.dart';
import 'package:digicasa/utils/helpersviewInputs.dart';
import 'package:digicasa/utils/helpersviewLetrasSubs.dart';
import 'package:digicasa/utils/resources.dart';
import 'package:digicasa/vistas/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



class Inversiondetalle extends StatefulWidget {

    TextEditingController montoInvertir = TextEditingController();
    TextEditingController montoRetirar = TextEditingController();
    AportacionEmpresarial? formData;
    Inversiondetalle(this.formData, {super.key});



  @override
  State<StatefulWidget> createState() => _Inversiondetalle();
}


enum TipoPago { Visa, PayPal}

class _Inversiondetalle extends State<Inversiondetalle> {
  TipoPago? _TipoPago;
  int currentPageIndex = 0;
  int metodopago = 0;

  @override
  void initState() {
    funcion();
    super.initState();
  }

  void funcion()  {

  }

  //ALERTDIALGO API
  final _mostrarLoadingStreamController = StreamController<bool>.broadcast();
  void ConfirmarDialog(String monto, String palabra) {
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
                  '¿Desea confirmar la $palabra de: $monto€?',
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
                    Navigator.pop(context);
                    SeleccionMetodo();
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

  void SeleccionMetodo(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text(
                'Método de Pago:',
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

                        const Expanded(
                          flex: 3,
                          child: Icon(FontAwesomeIcons.ccVisa, size: 50.0, color: Colors.black),
                        ),

                       HelpersViewLetrasSubs.formItemsDesignGris("VISA"),

                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:  Radio<TipoPago>(
                            value: TipoPago.Visa,
                            groupValue: _TipoPago,
                            onChanged: (TipoPago? value) {
                              setState(() {
                                _TipoPago = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [

                        const Expanded(
                          flex: 3,
                          child: Icon(FontAwesomeIcons.ccPaypal, size: 50.0, color: Colors.black),
                        ),

                        HelpersViewLetrasSubs.formItemsDesignGris("PayPal"),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:  Radio<TipoPago>(
                            value: TipoPago.PayPal,
                            groupValue: _TipoPago,
                            onChanged: (TipoPago? value) {
                              setState(() {
                                _TipoPago = value;
                              });
                            },),
                        ),
                      ],
                    ),

                    GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                          CargaDialog();
                          Timer.periodic(Duration(seconds: 3), (time) async {
                            _mostrarLoadingStreamController.add(true);
                            time.cancel();
                          });

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
                          child: const Text("Continuar",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500)),
                        )),

                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

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
                mostrarLOADING = value;
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
            icon: Icon(Icons.arrow_back, size: 40.0, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
            },
          ),
        ),
        body: <Widget>[
          Stack(
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
          ],
        ),

          //FORM2 OPCIONES.
          Stack(
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
                    child: formUI2(),
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
              selectedIcon: Icon(Icons.list_alt),
              icon: Icon(Icons.list_alt_sharp),
              label: 'Detalle',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.monetization_on),
              icon: Icon(Icons.monetization_on_outlined),
              label: 'Movimientos',
            ),
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

          Text("${widget.formData?.codigoInversion} Nombre: ${widget.formData?.montoInversion}",
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 15.0,
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.020,),

          Text(
            "Monto Invertido: ${widget.formData?.montoInversion}",
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 15.0,
            ),
          ),

          HelpersViewLetrasSubs.formItemsDesignLineaGris(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.020,),

          //BOTON FILTRO
          GestureDetector(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
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
                child: const Text("Volver al menú",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500)),
              )),


        ],),
    );

  }

  Widget formUI2() {
    return Container(
      child: Column(
        children: [

          Row(
            children: [
              const Text('Monto Agregar:', style: TextStyle(
                fontSize: 12.0,
                //color: Colors.white,
              ),),

              HelpersViewInputs.formItemsDesigndocumento(
                  TextFormField(
                    controller: widget.montoInvertir,
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


          SizedBox(height: MediaQuery.of(context).size.height * 0.020,),
          //BOTON FILTRO
          GestureDetector(
              onTap: () async {
                String monto = widget.montoInvertir!.text;
                String palabra = "Inversión";
                ConfirmarDialog(monto, palabra);
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
                child: const Text("Invertir",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500)),
              )),

          SizedBox(height: MediaQuery.of(context).size.height * 0.020,),
          HelpersViewLetrasSubs.formItemsDesignLineaGris(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.020,),

          Row(
            children: [
              const Text('Monto Retirar:', style: TextStyle(
                fontSize: 12.0,
                //color: Colors.white,
              ),),

              HelpersViewInputs.formItemsDesigndocumento(
                  TextFormField(
                    controller: widget.montoRetirar,
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


          SizedBox(height: MediaQuery.of(context).size.height * 0.020,),
          //BOTON FILTRO
          GestureDetector(
              onTap: () async {
                String monto = widget.montoRetirar!.text;
                String palabra = "Retiración";
                ConfirmarDialog(monto, palabra);
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
                child: const Text("Retirar",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500)),
              )),




        ],),
    );

  }


}
