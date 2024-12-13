import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/src/drawing_controller.dart';
import 'package:x/Canvas/guesser.dart';
import 'package:x/Canvas/guesserAniBar.dart';

class guesserStructure extends StatelessWidget {
  bool toogleValueForProgressBar;

  var forProgressBar;

  var paintStream;

  DrawingController guesserController;

  guesserStructure(this.toogleValueForProgressBar, this.forProgressBar,
      this.paintStream, this.guesserController,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GuesserAnimationBar(
          toogleValueForProgressBar,
          forProgressBar,
        ),
        StreamBuilder(
          stream: paintStream,
          builder: (context, snapshots) {
            return guesserContainer(guesserController, snapshots);
          },
        ),
      ],
    );
  }
}
