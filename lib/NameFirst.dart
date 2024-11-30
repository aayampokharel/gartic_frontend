import 'package:flutter/material.dart';
import 'package:x/MyApp.dart';
import 'package:http/http.dart' as http;

//@ for initial name page.
class Name extends StatefulWidget {
  const Name({super.key});

  @override
  State<Name> createState() => _NameState();
}

class _NameState extends State<Name> {
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
    return Scaffold(
      backgroundColor: const Color(0xffc5c5c5),
      appBar: AppBar(
        title: const Text("keep your name"),
      ),
      body: Column(
        children: [
          TextField(
            controller: loginController, //@ this is useful for login with name
            onSubmitted: (t) {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MyApp(loginController.text, getListOfWords);
              }));
            },
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return MyApp(loginController.text, getListOfWords);
                }));
              },
              child: const Text("Ok")),
        ],
      ),
    );
  }
}
