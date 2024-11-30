import 'package:flutter/material.dart';

TweenAnimationBuilder<double> animationBar() {
  return TweenAnimationBuilder(
    duration: const Duration(milliseconds: 19500),
    tween: Tween<double>(begin: 0, end: 300),
    builder: (BuildContext context, dynamic value, Widget? child) {
      return Container(
        height: 20,
        width: value,
        color: Colors.deepOrange,
      );
    },
  );
}
