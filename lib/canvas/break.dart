import 'package:flutter/material.dart';

class BreakContainer extends StatelessWidget {
  //Future Function() getListOfWords;
  //void Function() setSingleValueWhenBreak;

  const BreakContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * .75,
          //   color: const Color.fromARGB(255, 11, 81, 138),
          child: Center(
            child: const Text(
              "Resuming After A Short Break....... ",
              style: TextStyle(
                  fontFamily: "fsgravity", fontSize: 30, color: Colors.white),
            ),
          ),
        ),
        Container(
          child: Image.asset(
            "photos/flashClock.gif",
            fit: BoxFit.contain,
          ),
        ),
      ],
    );

    /// below code is for display of drawn elements.
  }
}
