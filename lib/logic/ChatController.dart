import 'package:flutter/material.dart';

class ChatController {
  TextEditingController chatController;
  ChatController() : chatController = TextEditingController();

  void dispose() {
    chatController.dispose();
  }

  TextEditingController controller() {
    return chatController;
  }

  String txt() {
    return chatController.text;
  }

  void txtReader(String text) {
    chatController.text = text;
  }
}
