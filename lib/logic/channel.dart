import 'dart:convert';

// import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Channel {
  final WebSocketChannel channel;
  Channel()
      : channel = WebSocketChannel.connect(Uri.parse('ws://localhost:8080/'));

  void add(dynamic str) {
    channel.sink.add(str);
  }

  Stream broadcastStream() => channel.stream.asBroadcastStream();

  void sendDataToChannel(String currentName, String text) {
    //@ SEND MESSAGE .
    Map<String, String> mapOfDataEntered = {
      "Name": currentName,
      "Message": text,
    };
    // channel.sink.add(json.encode(mapOfDataEntered));
    channel.sink.add(json.encode(mapOfDataEntered));
  }

  void close() => channel.sink.close();
}
