import 'package:flutter/material.dart';

TweenAnimationBuilder<double> animationBar(BuildContext context) {
  return TweenAnimationBuilder(
    duration: const Duration(milliseconds: 19500),
    tween:
        Tween<double>(begin: 0, end: MediaQuery.of(context).size.width * 0.75),
    //! in this app , MEDIAQUERY is not to be used , as it rebuilds all the container depending on it and erases all drawing as it gets refreshed .Here , only for testing purpose .
    //@ SOLUTION : the solution for this is use 2 layout one for small mobile phones , and another one is for pc .ELSE LIKE GARTIC CLONE <horizontally scrollable .
    builder: (BuildContext context, dynamic value, Widget? child) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2, color: Colors.black),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(928163), Color.fromARGB(255, 129, 215, 241)]),
        ),
        height: 20,
        width: value,
        // color: Color.fromARGB(255, 52, 51, 50),
      );
    },
  );
}
