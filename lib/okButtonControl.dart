import 'package:flutter/material.dart';
import 'package:x/logic/ChatController.dart';
import 'package:x/Message/fieldRow.dart';

class okButtonControl extends StatelessWidget {
  AsyncSnapshot<Object?> snapshot;
  AsyncSnapshot<bool> noEntrySnapshot;
  ChatController chatController;
  dynamic Function(String) insideOnPressed;
  okButtonControl({super.key, 
    required this.snapshot,
    required this.noEntrySnapshot,
    required this.chatController,
    required this.insideOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      //? this below is not required as ?? false ko use nai bhaena ni after data is there .

      return fieldRow(noEntrySnapshot, chatController, insideOnPressed);

      //     //@ this is for boolean stream controller. only displayed when no data i.e. at first

      //     //! this is the row which is displayed after one click on ok as yo streambuilder returns below code first when no data . after press, there is data and never that code is repeated, and this is the one which again goes for snapshot.hasdata==false as initially it has no data.
    } else {
      return const CircularProgressIndicator();
    }
  }
}
