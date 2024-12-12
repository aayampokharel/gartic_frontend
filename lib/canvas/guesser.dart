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
        width: MediaQuery.of(context).size.width *
            0.75, //! media query not recommended!!!!!__________
        height: 300,
        color: Colors.white,
        child: DrawingBoard(
          controller: guesserController,
          background: SizedBox(
              width: MediaQuery.of(context).size.width * 0.75, height: 300),
          showDefaultActions: false,
          showDefaultTools: false,
        ),
      ),
    );
  }
}
