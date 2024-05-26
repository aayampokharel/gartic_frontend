//simple example

import 'dart:async';
import 'dart:convert';
//import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
//import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:x/main.dart';

class Painter extends StatefulWidget {
  @override
  State<Painter> createState() => _PainterState();
  String currentName;
  String currentTurn;
  Function localStreamForTextField;
  Future Function() getListOfWords;

  Painter(this.currentName, this.currentTurn, this.localStreamForTextField,
      this.getListOfWords);
}

class _PainterState extends State<Painter> {
  DrawingController drawingController2 = DrawingController();

  void _getJsonList() async {
    var x = json.encode(drawingController.getJsonList());

    paintChannel.sink.add(x);
  }

//@ alertWebsocket() is for adding true so that the input field is readonly:true
  void alertWebSocket() {
    checkChannel.sink.add("true");
  }

  var paintStream;
  var checkStream;

  @override
  void initState() {
    //@ alertWebsocket() is called to make input field is readonly while player is drawing
    super.initState();
    widget.getListOfWords().then((value) {
      setState(() {
        singleValue = jsonDecode(value).toString();
      });
    });
    if (widget.currentName == widget.currentTurn) {
      alertWebSocket();
    }
    paintStream = paintChannel.stream.asBroadcastStream();
    checkStream = checkChannel.stream.asBroadcastStream();
  }

  final DrawingController drawingController = DrawingController();
  final paintChannel =
      WebSocketChannel.connect(Uri.parse('ws://localhost:8080/paint'));

  final checkChannel =
      WebSocketChannel.connect(Uri.parse('ws://localhost:8080/check'));
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: checkStream,

        /// this is for checking if the turn is this particular user or not
        builder: (context, snapshott) {
          drawingController.clear();
          drawingController2.clear();
          if (snapshott.data == widget.currentName) {
            //   print("hello brother");
            print(snapshott.data);
            widget.localStreamForTextField(true);

            ///again setting readonly for the input field for drawer
          }
          if (snapshott.data == widget.currentName && snapshott.hasData) {
            return Column(
              children: [
                Container(
                  //# THis is the text displayed for drawer.
                  width: 300,
                  padding: EdgeInsets.all(10),
                  color: Colors.pink,
                  child: Text(singleValue.toString()),
                ),
                Container(
                  width: 300,
                  height:
                      300, //# for drawer calls getJsonList() to send the points.
                  color: Colors.yellow,
                  child: Listener(
                    onPointerCancel: (s) {
                      _getJsonList();
                    },
                    onPointerDown: (s) {
                      _getJsonList();
                    },
                    onPointerMove: (s) {
                      _getJsonList();
                    },
                    onPointerUp: (s) {
                      _getJsonList();
                    },
                    child: DrawingBoard(
                      controller: drawingController,
                      background: Container(width: 300, height: 300),
                      showDefaultActions: true,
                      showDefaultTools: true,
                    ),
                  ),
                ),
              ],
            );

            ///break is the data sent in the stream after a certain time for drawer to change the drawing power to someone else.
          } else if ((snapshott.data.toString() == "Break")) {
            widget.localStreamForTextField(false);

            widget.getListOfWords().then((value) {
              singleValue = jsonDecode(value).toString();
            });
            return Container(
              color: Colors.red,
              child: Text("take a break guys...... "),
            );

            /// below code is for display of drawn elements.
          } else {
            //@ THIS is called for non-drawers ones.
            widget.localStreamForTextField(false);
            return StreamBuilder(
                stream: paintStream,
                builder: (context, snapshots) {
                  if (snapshots.hasData) {
                    List list = json
                        .decode(snapshots.data.toString())
                        .toList(); //!//!//!

                    if (list.length == 0) {
                      drawingController2.clear();
                    }
                    for (int i = 0; i < list.length; i++) {
                      if (list.length == 0) {
                        drawingController2.clear();
                        break;
                      }

                      if (list[i]["type"] == "SimpleLine") {
                        drawingController2.addContents(
                            <PaintContent>[SimpleLine.fromJson(list[i])]);
                      }
                      if (list[i]["type"] == "SmoothLine") {
                        drawingController2.addContents(
                            <PaintContent>[SmoothLine.fromJson(list[i])]);
                      }
                      if (list[i]["type"] == "StraightLine") {
                        drawingController2.addContents(
                            <PaintContent>[StraightLine.fromJson(list[i])]);
                      }
                      if (list[i]["type"] == "Rectangle") {
                        drawingController2.addContents(
                            <PaintContent>[Rectangle.fromJson(list[i])]);
                      }
                      if (list[i]["type"] == "Circle") {
                        drawingController2.addContents(
                            <PaintContent>[Circle.fromJson(list[i])]);
                      }
                    }
                  }
                  return IgnorePointer(
                    child: Container(
                      width: 700,
                      height: 700,
                      color: Color.fromARGB(255, 11, 185, 109),
                      child: DrawingBoard(
                        controller: drawingController2,
                        background: Container(width: 700, height: 600),
                        showDefaultActions: false,
                        showDefaultTools: false,
                      ),
                    ),
                  );
                });
          }
        });
  }

  @override
  void dispose() {
    // Close the WebSocket channels
    paintChannel.sink.close();
    paintChannel.stream.drain();
    checkChannel.sink.close();
    checkChannel.stream.drain();

    // Dispose the drawing controllers
    drawingController.dispose();
    drawingController2.dispose();

    // Close the streams if they have subscriptions
    if (paintStream is StreamSubscription) {
      paintStream.cancel();
    }
    if (checkStream is StreamSubscription) {
      checkStream.cancel();
    }

    super.dispose();
  }
}
