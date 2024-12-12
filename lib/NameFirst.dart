import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:x/MyApp.dart';
import 'package:http/http.dart' as http;
import 'package:gradient_borders/gradient_borders.dart';

//@ for initial name page.
class Name extends StatefulWidget {
  const Name({super.key});

  @override
  State<Name> createState() => _NameState();
}

class _NameState extends State<Name> {
  late double mediaHeight = MediaQuery.of(context).size.height;
  late double mediaWidth = MediaQuery.of(context).size.width;
  TextEditingController loginController = TextEditingController();

  //? getkustofwords() returns a single word from backend in thee break section in painter
  Future getListOfWords() async {
    var response = await http.get(Uri.parse(
        "http://localhost:8080/listofwords")); //! not list of word but the neext word in queue from backend
    return response.body;
  }

  //
  //
  //? end

  @override
  Widget build(BuildContext context) {
    mediaHeight = MediaQuery.of(context).size.height;
    mediaWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                //  color: Colors.red,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      'photos/Gartic.png',
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16), // Rounded corners
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 10),
                child: LayoutBuilder(builder: (context, constraints) {
                  return Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(169, 255, 153, 0)
                              .withOpacity(0.24),
                        ),
                      ],
                      color: Colors.white24,
                      border: const GradientBoxBorder(
                          gradient: LinearGradient(
                              colors: [Colors.orange, Colors.blue]),
                          width: 4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(10),
                    width: constraints.maxWidth * 0.9,
                    height: 500,
                    constraints: BoxConstraints(
                      maxWidth: constraints.maxWidth * 0.9,
                      minWidth: constraints.maxWidth * 0.9,
                      maxHeight: 250,
                      minHeight: 0,
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Enter your name ",
                          style: TextStyle(
                            fontSize: constraints.maxWidth < 975 ? 40 : 60,
                            fontFamily: "fsgravity",
                            color: const Color.fromARGB(255, 11, 81, 138),
                          ),
                        ),
                        TextField(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontFamily: "fsgravity",
                          ),
                          controller:
                              loginController, //@ this is useful for login with name
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          onSubmitted: (t) {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return MyApp(
                                    loginController.text, getListOfWords);
                              }),
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return MyApp(
                                    loginController.text, getListOfWords);
                              }));
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              width: 80,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.grey,
                                      Color.fromARGB(141, 166, 164, 164)
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                  border: GradientBoxBorder(
                                    width: 4,
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color.fromARGB(139, 255, 153, 0),
                                        const Color.fromARGB(151, 33, 149, 243)
                                      ],
                                    ),
                                  )),
                              child: Center(
                                  child: const Text(
                                "OK",
                                style: TextStyle(
                                    fontSize: 25, fontFamily: "fsgravity"),
                              )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
