//#c5c5c5 (background colorof the speed clockimage ) is the required color theme here . i am going to create some old magic thing here.
//@ for background
import 'package:flutter/material.dart';
import 'package:x/NameFirst.dart';

void main() {
  runApp(const MyApps());
}

var singleValue;
var listOfName = [];

class MyApps extends StatelessWidget {
  const MyApps({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: const Color(0xffc5c5c5))),
      home: const Name(),
    );
  }
}
