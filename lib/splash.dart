import 'dart:async';

import 'package:digicasa/utils/resources.dart';
import 'package:digicasa/utils/constantes.dart';
import 'package:digicasa/vistas/home.dart';
import 'package:digicasa/vistas/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {

  static Route<dynamic> route() =>
      MaterialPageRoute(builder: (context) => SplashPage());

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late String PREFUsuario;

  @override
  void initState() {
    super.initState();
    toHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            width: 420,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Resources.fondo),
                fit: BoxFit.fill,
              ),
            ),
            child: Stack(
              children: [
                Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: EdgeInsets.only(top: 100),
                      child: Image.asset(
                        Resources.loginlargo, //
                        width: 250,
                        height: 60,
                      ),
                    )),

                Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 515,
                      height: 255,
                      margin: EdgeInsets.all(20),
                      child: Image.asset(Resources.loginLogo2),
                    )), /*
                Align(
                  //alignment: Alignment.topCenter,
                    child: Container(
                      width: 200,
                      //height: 65,
                      margin: EdgeInsets.only(bottom: 110),
                      child: Image.asset(Resources.ministerio),
                    )),
                */
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(
                        bottom: 200), // Add your desired margin value
                    child: const Text(
                      "Versión " + Constantes.versionapp,
                      textAlign:
                      TextAlign.center, // Align text within the container
                      style: TextStyle(
                        fontSize: 20, // Adjust font size as needed
                        fontWeight:
                        FontWeight.bold, // Adjust font weight as needed
                        color: Colors.red, // Change color as needed
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  void toHome() {



    Timer.periodic(Duration(seconds: 3), (time) async {
        _login();
      time.cancel();

    });
  }

  _login() async {
    Navigator.pushAndRemoveUntil(context, login.route(), (route) => false);
    /*
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => login()),
    );*/
  }

  _home() async {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  Home()));
  }



}

