import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:x/logic/drawerStream.dart';

class Body extends StatefulWidget {
  final DrawerStream drawerStream;
  // final StreamController drawerStream = StreamController();
  const Body({required this.drawerStream, super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  DrawerStream drawerStream = DrawerStream();
  @override
  Widget build(BuildContext context) {
    //  StreamBuilder(
    //               stream: drawerStream.broadcastStream,
    //               builder: (context, snap) {
    //                 if (snap.hasData) {
    //                   List responseList = [];

    //                   responseList = json.decode((snap.data!));
    //                   return Body(drawerStream: drawerStream);
    //                 } else {
    //                   return const CircularProgressIndicator();
    //                 }
    //               }),
    return StreamBuilder(
        stream: drawerStream.broadcastStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
              height: 200,
              width: 200,
              child: StreamBuilder(
                  stream: widget.drawerStream.broadcastStream,
                  builder: (context, snap) {
                    if (snap.hasData) {
                      List responseList = [];

                      responseList = json.decode((snap.data!));
                      return ListView.builder(
                          itemCount: responseList.length,
                          itemBuilder: (build, count) {
                            return ListTile(
                              leading: const Padding(
                                padding:
                                    EdgeInsets.only(left: 10.0, right: 20.0),
                                child: Icon(Icons.person_2_sharp),
                              ),
                              title: Text(responseList[count].toString()),
                            );
                          });
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
