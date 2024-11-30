import 'dart:async';

class BoolStream {
  StreamController<bool> boolStreamController;
  BoolStream() : boolStreamController = StreamController.broadcast();

  void add(bool val) {
    boolStreamController.add(val);
  }

  Stream<bool> get stream => boolStreamController
      .stream; //#get ma no () reqd as in function . tyo faida.

  void localStreamForTextField(bool value) {
    //! this is used for the readonly for textfield after right answr setting thing .
    boolStreamController.add(value);
  }

  void close() {
    boolStreamController.close();
  }
}
