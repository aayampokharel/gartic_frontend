import 'dart:async';


class DrawerStream {
  StreamController drawerStream;
  DrawerStream() : drawerStream = StreamController();

  Stream<dynamic> get broadcastStream => drawerStream.stream;

  void add(String value) => drawerStream.add(value);

  void close() => drawerStream.close();
}
