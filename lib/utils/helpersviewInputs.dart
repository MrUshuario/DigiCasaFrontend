import 'package:digicasa/utils/resources.dart';
import 'package:flutter/material.dart';

class HelpersViewInputs{

  static Widget formItemsDesign(icon, item, context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Card(
          elevation: 0,
          shape: const RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.blue,
              //color: Theme.of(context).colorScheme.outline,
            ),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: ListTile(
          leading:  Icon(icon, color: Colors.red,),
          title: item
      )),
    );
  }

  static Widget formItemsDesignlogin(String text, item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Card(
        elevation: 0,
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.black,
            //color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: ListTile(
          leading: Text(text, style: const TextStyle(fontSize: 20.0)), // Use Text widget for text
          title: item,
        ),
      ),
    );
  }

  static Widget formItemsDesignloginIcon(icon, item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Card(
        elevation: 0,
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.black,
            //color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: ListTile(
          leading:  Icon(icon, color: Colors.black,),
          title: item,
        ),
      ),
    );
  }

  static Widget formItemsAmenidades(icon, String text) {
    return Padding(
        padding: EdgeInsets.all(5.0),
        child: Container(
          height: 75,
          width: 75,
          decoration: BoxDecoration(
            color: Resources.botoniconActivado,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 35.0, color: Colors.black),
              Text(text, style: TextStyle(color: Colors.black)), // Your text
              const SizedBox(height: 5.0),
            ],
          ),
        )
    );
  }

  static Widget formItemsDesignInput(IconData icon, item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Card(
        elevation: 0,
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.black,
            //color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: ListTile(
          leading: Icon(icon, size: 20.0, color: Colors.black),
          title: item,
        ),
      ),
    );
  }

  static Widget formItemsDesigndocumento(item, context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.35,
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Resources.AzulTema,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: ListTile(
              title: item
          )),
    );
  }

  static String? validateField(String value, List<String> paramsValidate) {
    RegExp regExp = RegExp(paramsValidate[0]);
    if (value.isEmpty) {
      return paramsValidate[1];
    } else if (!regExp.hasMatch(value)) {
      return paramsValidate[2];
    }
    return null;
  }

  static Widget headerColumn(String? value) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            value.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blue)
          ),
        ],
      ),
    );
  }

  static Widget column(String? value, bool? flagEdit, bool? flagSync) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            value.toString(),
            style: flagEdit == true && flagSync == true
                ? const TextStyle(fontSize: 14, color: Colors.green)
                : (flagEdit == true ? const TextStyle(fontSize: 14, color: Colors.blue) : const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}