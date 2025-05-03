import 'package:digicasa/obj/OBJinversion.dart';
import 'package:digicasa/obj/OBJmensualidad.dart';
import 'package:digicasa/utils/helpersviewLetrasSubs.dart';
import 'package:digicasa/utils/resources.dart';
import 'package:digicasa/vistas/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';



class Inversiongeneral extends StatefulWidget {
  List<Mensualidad> listMensualidad = List.empty(growable: true);
  Inversiongeneral({super.key});
  @override
  State<StatefulWidget> createState() => _Inversiongeneral();
}

class _Inversiongeneral extends State<Inversiongeneral> {



  @override
  void initState() {
    funcionAgregarMensualidad();
    super.initState();

  }

  void funcionAgregarMensualidad()  {

    Mensualidad objaux = Mensualidad();
    objaux.codigomes = 1;
    objaux.mes = "Enero";
    objaux.montopagado = 100+(1*10);
    widget.listMensualidad.add(objaux);

    Mensualidad objaux2 = Mensualidad();
    objaux2.codigomes = 2;
    objaux2.mes = "Febrero";
    objaux2.montopagado = 100+(2*10);
    widget.listMensualidad.add(objaux2);

    Mensualidad objaux3 = Mensualidad();
    objaux3.codigomes = 3;
    objaux3.mes = "Marzo";
    objaux3.montopagado = 100+(3*10);
    widget.listMensualidad.add(objaux3);

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
            icon: const Icon(Icons.arrow_back, size: 40.0, color: Colors.black),
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

          /*
          Align(
            alignment: Alignment.center,
            child: //widget.formData?.urlimagen
            Image.network(
              widget.formData?.urlimagen != null
                  ? widget.formData!.urlimagen!
                  : 'path/to/placeholder_image.jpg',
              width: 200.0,
              height: 200.0,
              fit: BoxFit.cover,
            ),
          ), */

          SizedBox(height: MediaQuery.of(context).size.height * 0.030,),

          Text("Ha contribuido con un total de: 900",
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 15.0,
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.020,),

          Text(
            "ACEPTABLE",
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 15.0,
            ),
          ),

          SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // Chart title
              title: ChartTitle(text: 'Half yearly sales analysis'),
              // Enable legend
              legend: Legend(isVisible: true),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CartesianSeries<Mensualidad, String>>[
                LineSeries<Mensualidad, String>(
                    dataSource: widget.listMensualidad,
                    xValueMapper: (Mensualidad sales, _) => sales.mes,
                    yValueMapper: (Mensualidad sales, _) => sales.montopagado,
                    name: 'Sales',
                    // Enable data label
                    dataLabelSettings: DataLabelSettings(isVisible: true))
              ]),





          HelpersViewLetrasSubs.formItemsDesignLineaGris(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.020,),

          //BOTON VOLVER
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


}
