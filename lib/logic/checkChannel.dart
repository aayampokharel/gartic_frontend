import 'package:web_socket_channel/web_socket_channel.dart';

class CheckChannel {
  final checkChannel;

  CheckChannel()
      : checkChannel =
            WebSocketChannel.connect(Uri.parse('ws://localhost:8080/check'));

  dynamic broadcastStream() {
    return checkChannel.stream.asBroadcastStream();
  }

  void close() {
    checkChannel.sink.close();
  }

  void alertWebSocket() {
    checkChannel.sink.add(
        "true"); ////watch out for the UI AS THIS THING  IS REBUILT 3 TIMES INITIALLY.(Not good)
  }

  void add(String str) {
    checkChannel.sink.add(str);
  }

  void drain() {
    checkChannel.stream.drain();
  }
}
