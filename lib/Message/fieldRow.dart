import 'package:flutter/material.dart';
import 'package:x/logic/ChatController.dart';

Widget fieldRow(AsyncSnapshot noEntrySnapshot, ChatController chatCtrl,
    dynamic Function(String) insideOnPressed) {
  return Row(
    children: [
      Container(
        color: Colors.purple,
        width: 500,
        child: TextField(
          //! redundant code here and below .
          readOnly: noEntrySnapshot.data ?? false,
          controller: chatCtrl.controller(),
          onSubmitted: (text) {
            if (noEntrySnapshot.data == false) {
              insideOnPressed(text);
              chatCtrl.txtReader(""); //for inputing value when false.
            } else {
              null;
            }
          },
        ),
      ),
      ElevatedButton(
          onPressed: () {
            if (noEntrySnapshot.data == false) {
              insideOnPressed(chatCtrl.txt());
              chatCtrl.txtReader("");
            } else {
              null;
            }
          },
          child: const Text("OK")),
    ],
  );
}
