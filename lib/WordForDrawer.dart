import 'package:flutter/material.dart';

class WordForDrawer extends StatelessWidget {
  var singleValue;
  WordForDrawer(this.singleValue, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      //# THis is the text displayed for drawer.
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        color: Color.fromARGB(255, 237, 174, 29),
        border: Border.all(width: 3, color: Colors.white),
      ),
      padding: const EdgeInsets.all(10),

      child: Text(singleValue.toString()),
    );
  }
}
