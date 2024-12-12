import 'package:flutter/material.dart';
import 'package:x/logic/ChatController.dart';

Widget fieldRow(AsyncSnapshot noEntrySnapshot, ChatController chatCtrl,
    dynamic Function(String) insideOnPressed) {
  return Container(
    width: double.infinity,
    color: Color.fromARGB(221, 245, 242, 242),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Type Your  Guess...',
            ),

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
    ),
  );
}
