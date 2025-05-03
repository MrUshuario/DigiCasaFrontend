import 'package:digicasa/utils/resources.dart';
import 'package:digicasa/vistas/home.dart';
import 'package:flutter/material.dart';


class HelpersViewAlertProgressCircle extends StatelessWidget {

    const HelpersViewAlertProgressCircle({super.key,
      required this.mostrar,
      required this.texto,
    });

    final bool mostrar;
    final String texto;

    final double width = 100.0;
    final double height = 100.0;

    @override
    Widget build(BuildContext context) {

      return  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: !mostrar,
                child:Column(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),

               Container(
                      width: width,
                      height: height,
                      child: CircularProgressIndicator(
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation(Resources.AzulTema),
                      strokeWidth: 10,
                    ),
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),

               ],),

              ),

              Visibility(
                visible: mostrar,
              child:Column(
              children: <Widget>[

                Align(
                  alignment: Alignment.topLeft, // Align to top left corner
                  child: Container(
                    padding: const EdgeInsets.only(left: 15, top: 20, right: 20),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.black,),
                        Expanded(
                          child: Text(
                            "Mensaje Informativo",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                    padding: EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text (texto, style: TextStyle(fontSize: 16),)
                        ),
                        const Icon(Icons.save, color: Colors.black,)
                      ],
                    ),
                  ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  // Align row to the end
                  children: [
                    Spacer(), // Push remaining space to the left

                    InkWell(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 20, right: 20, bottom: 20),
                        child: const Text(
                          "Ir al menú",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: () {

                        Navigator.of(context).pop();

                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 20, right: 20, bottom: 20),
                        child: const Text(
                          "Cerrar",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),

                  ],
                ),

              ],),
              ),

        ],);
    }

}