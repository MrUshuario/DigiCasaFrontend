
import 'package:digicasa/utils/resources.dart';
import 'package:flutter/material.dart';

class HelpersViewAlertaInfo {

  static Widget formItemsDesign(String text, String textoI) {
    return Column(
      children: [
        // Align:
        Align(
          alignment: Alignment.topLeft, // Align to top left corner
          child: Container(
            padding: const EdgeInsets.only(left: 15, top: 20, right: 20),
            child: Row(
              children: [
                Image.asset(Resources.iconInfo),
                Expanded(
                  child: Text(
                    textoI,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Separators (optional):
        const SizedBox(height: 10),

        // Second text:
        Container(
          padding: const EdgeInsets.all(20),
          child:  Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ),

        // Separators (optional):
        const SizedBox(height: 10),


      ],
    );
  }
}