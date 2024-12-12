import 'dart:async';
import 'dart:convert';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter/material.dart';
import 'package:x/Canvas/AniBar.dart';
import 'package:x/Canvas/AnimationService.dart';
import 'package:x/Canvas/break.dart';
import 'package:x/Canvas/drawing.dart';
import 'package:x/Canvas/guesserStructure.dart';
import 'package:x/WordForDrawer.dart';
import 'package:x/logic/checkChannel.dart';
import 'package:x/logic/paintChannel.dart';
import 'package:x/main.dart';

class Painter extends StatefulWidget {
  @override
  State<Painter> createState() => _PainterState();
  String currentName;
  String currentTurn;
  Function(bool) localStreamForTextField;
  Future Function() getListOfWords;
  void Function() toogleBlurSetState;

  Painter(this.currentName, this.currentTurn, this.localStreamForTextField,
      this.getListOfWords, this.toogleBlurSetState,
      {super.key});
}

class _PainterState extends State<Painter> {
  late bool runBlurOnce;
  var localName;
  final DrawingController guesserController = DrawingController();
  final DrawingController drawingController = DrawingController();
  final paintChannel = PaintChannel();

  final checkChannel = CheckChannel();
//@ alertWebsocket() is for adding true so that the input field is readonly:true

  late Stream paintStream;
  late Stream checkStream;

  var toogleValueForProgressBar = false;

  AnimationService forProgressBar = AnimationService();

  @override
  void initState() {
    //@ alertWebsocket() is called to make input field is readonly while player is drawing
    super.initState();
    runBlurOnce = true;
    _initializer();

    if (widget.currentName == widget.currentTurn) {
      checkChannel.alertWebSocket();
    }
    paintStream = paintChannel.broadcastStream();
    checkStream = checkChannel
        .broadcastStream(); //@ this makes other things depend on it .
  }

  Future<void> _initializer() {
    return widget.getListOfWords().then((value) {
      setState(() {
        singleValue = jsonDecode(value).toString();
        localName =
            singleValue; //! this is causing the initial rebuild of widget which is not good dbecause of setstate. or its another issue. but 500ms bhitra there is setstate running .ELSE USE CIRCULAR PROGRESS INDICATOR.
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Color(0xffd2507583),
      child: StreamBuilder(
          stream: checkStream,

          /// this is for checking if the turn is this particular user or not
          builder: (context, snapshott) {
            drawingController.clear();
            guesserController.clear();
            singleValue = localName;
            if (snapshott.data == widget.currentName) {
              widget.localStreamForTextField(true);

              ///again setting readonly for the input field for drawer
            }
            if (snapshott.data == widget.currentName && snapshott.hasData) {
              if (runBlurOnce) {
                Future.delayed(const Duration(milliseconds: 300),
                    () => widget.toogleBlurSetState());
                runBlurOnce = false;
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  animationBar(context),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: Colors.white,
                      border: Border.all(width: 3),
                    ),
                    child: Column(
                      children: [
                        WordForDrawer(singleValue),
                        Drawing(paintChannel, drawingController),
                      ],
                    ),
                  ),
                ],
              );

              ///break is the data sent in the stream after a certain time for drawer to change the drawing power to someone else.
            } else if ((snapshott.data.toString() == "Break")) {
              singleValue = "";

              //! this is for not letting yellow player to write. working ...feri kina rewrite bhayo bhanda cause this painter is inside the streambuilder and already said its like server and setstate waiting for data and rebuilding the thing . so painter lai bahira pathaune from main.

              widget.getListOfWords().then((value) {
                localName = jsonDecode(value).toString();
              });

              toogleValueForProgressBar = true;
              return const BreakContainer();

              /// below code is for display of drawn elements.
            } else {
              //@ THIS is called for non-drawers ones.
              widget.localStreamForTextField(false);
              if (runBlurOnce) {
                Future.delayed(
                    const Duration(
                        milliseconds:
                            300), //initially even in drawer this future runs initially because else condition run huncha initially and then drawer ko ma espachi yellow display huncha , so this will run initially.so timer will be effective of this only. JUST FOR SAFETY ABOVE IS NOT REMOVED.
                    () => widget.toogleBlurSetState());
                runBlurOnce = false;
              }
              return guesserStructure(toogleValueForProgressBar, forProgressBar,
                  paintStream, guesserController);
            }
          }),
    );
  }

  @override
  void dispose() {
    // Close the WebSocket channels
    paintChannel.close();
    paintChannel.drain();
    checkChannel.close();
    checkChannel.drain();

    // Dispose the drawing controllers
    drawingController.dispose();
    guesserController.dispose();

    // Close the streams if they have subscriptions
    if (paintStream is StreamSubscription) {
      (paintStream as StreamSubscription).cancel();
    }
    if (checkStream is StreamSubscription) {
      (checkStream as StreamSubscription).cancel();
    }

    super.dispose();
  }
}
