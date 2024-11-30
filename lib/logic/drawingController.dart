import 'dart:convert';

import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';

void paintStreamUse(DrawingController drawingController2, snapshots) {
  if (snapshots.hasData) {
    List list = json.decode(snapshots.data.toString()).toList(); //!//!//!

    if (list.isEmpty) {
      drawingController2.clear();
    }
    for (int i = 0; i < list.length; i++) {
      if (list.isEmpty) {
        drawingController2.clear();

        break;
      }

      if (list[i]["type"] == "SimpleLine") {
        drawingController2
            .addContents(<PaintContent>[SimpleLine.fromJson(list[i])]);
      }
      if (list[i]["type"] == "SmoothLine") {
        drawingController2
            .addContents(<PaintContent>[SmoothLine.fromJson(list[i])]);
      }
      if (list[i]["type"] == "StraightLine") {
        drawingController2
            .addContents(<PaintContent>[StraightLine.fromJson(list[i])]);
      }
      if (list[i]["type"] == "Rectangle") {
        drawingController2
            .addContents(<PaintContent>[Rectangle.fromJson(list[i])]);
      }
      if (list[i]["type"] == "Circle") {
        drawingController2
            .addContents(<PaintContent>[Circle.fromJson(list[i])]);
      }
    }
  }
}
