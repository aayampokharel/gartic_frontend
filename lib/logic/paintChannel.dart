import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class PaintChannel {
  final paintChannel;

  PaintChannel()
      : paintChannel =
            WebSocketChannel.connect(Uri.parse('ws://localhost:8080/paint'));

  dynamic broadcastStream() {
    return paintChannel.stream.asBroadcastStream();
  }

  // void getJsonList(String str) async {
  //   paintChannel.add(str);
  // }

  void getListJson(List<Map<String, dynamic>> value) async {
    var str = json.encode(value);
    paintChannel.sink.add(str);
  }

  void add(String str) {
    paintChannel.sink.add(str);
  }

  void close() {
    paintChannel.sink.close();
  }

  void drain() {
    paintChannel.stream.drain();
  }
}
