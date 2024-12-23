import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:x/MyApp.dart';
import 'package:x/logic/paintChannel.dart';

class Drawing extends StatelessWidget {
  PaintChannel paintChannel;

  DrawingController drawingController;
  Drawing(this.paintChannel, this.drawingController, {super.key});

  @override
  Widget build(BuildContext context) {
    toogleValueForBlur = false;
    return Container(
      width: MediaQuery.of(context).size.width * .75,
      height: 300, //# for drawer calls getJsonList() to send the points.
      color: Colors.white,
      child: Listener(
        onPointerCancel: (s) {
          paintChannel.getListJson(drawingController.getJsonList());
        },
        onPointerDown: (s) {
          paintChannel.getListJson(drawingController.getJsonList());
        },
        onPointerMove: (s) {
          paintChannel.getListJson(drawingController.getJsonList());
        },
        onPointerUp: (s) {
          paintChannel.getListJson(drawingController.getJsonList());
        },
        child: DrawingBoard(
          controller: drawingController,
          background: SizedBox(
              width: MediaQuery.of(context).size.width * .75, height: 300),
          showDefaultActions: true,
          showDefaultTools: true,
        ),
      ),
    );
  }
}
