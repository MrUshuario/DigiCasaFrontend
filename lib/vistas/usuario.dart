import 'dart:async';
import 'dart:convert';
import 'package:digicasa/obj/OBJapartamentos.dart';
import 'package:digicasa/utils/HelpersViewAlertaInfo.dart';
import 'package:digicasa/utils/resources.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class usuario extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _usuario();
}

class _usuario extends State<usuario> {

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
        /*appBar: AppBar(
          title: const Text(
            Resources.usuario,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color.fromARGB(255, 27, 65, 187),
          actions: [
            IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: () {
                  logoutFunction();
                }
            )
          ],
        ), */
        //drawer: const MenuLateral(),
        body: Stack(
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

          IconButton(
              icon: const Icon(Icons.person, color: Colors.black),
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => usuario()),
                );

              }
          )

        ],),
    );

  }


}
