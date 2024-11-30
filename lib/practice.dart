import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const red());
}

class red extends StatefulWidget {
  const red({super.key});

  @override
  State<red> createState() => _redState();
}

class _redState extends State<red> {
  StreamController c = StreamController();
  String x = "first initial";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    c.sink.add("kyahai");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("hello"),
        ),
        body: StreamBuilder(
            stream: c.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print(true);
                return Column(
                  children: [
                    cntr1(x),
                    Container(
                      child: Text(x),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          c.sink.add("a");
                        },
                        child: const Text("ok")),
                  ],
                );
              } else {
                return const CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}

class cntr1 extends StatefulWidget {
  String x;

  cntr1(this.x, {super.key});

  @override
  State<cntr1> createState() => _cntr1State();
}

class _cntr1State extends State<cntr1> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 5), () {
      print("done");
      setState(() {
        widget.x = "hello second";
      });
    });

    return Container(
      child: Text(widget.x),
    );
  }
}
