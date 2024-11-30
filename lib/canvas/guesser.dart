import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:x/logic/drawingController.dart';

class guesserContainer extends StatelessWidget {
  DrawingController guesserController;
  var snapshots;
  guesserContainer(this.guesserController, this.snapshots, {super.key});

  @override
  Widget build(BuildContext context) {
    paintStreamUse(guesserController, snapshots);
    return IgnorePointer(
      child: Container(
        width: 300,
        height: 300,
        color: const Color.fromARGB(255, 11, 185, 109),
        child: DrawingBoard(
          controller: guesserController,
          background: const SizedBox(width: 300, height: 300),
          showDefaultActions: false,
          showDefaultTools: false,
        ),
      ),
    );
  }
}
