import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:x/painterStructure.dart';
import 'package:http/http.dart' as http;

class MyApp extends StatefulWidget {
  var singleValue;
  final String currentName;
  final Future Function() getListOfWords;
  @override
  MyApp(this.currentName, this.getListOfWords, this.singleValue, {super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

//bool toogleHasData = true;
bool toogleReadOnly = false;

var toogleForTextFieldIfTrue =
    false; //@ if true after hitting correct answer , the client should be able to talk in break

class _MyAppState extends State<MyApp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final channel = WebSocketChannel.connect(Uri.parse('ws://localhost:8080/'));

  TextEditingController chatController = TextEditingController();
  List listOfMessage = [];
  StreamController<bool> boolStreamController = StreamController.broadcast();

  void localStreamForTextField(bool value) {
    //! this is used for the readonly for textfield after right answr setting thing .
    boolStreamController.add(value);
  }

  // StreamController drawerStream = StreamController();
  String currentTurn = "nope";
  StreamController drawerStream = StreamController();
//! names channel is to get the lit of players wheen drawer is
  // void forDrawer()async  {
  //    var response=await http.get(Uri.parse('http://localhost:8080/listofnames'));
  // drawerStream.add(response.body);

  // }

  Future timerForName() async {
    // currentName=await http.get(Uri.parse("http://localhost:8080/listofwords"));
    var x = await http.post(
        Uri.parse(
            "http://localhost:8080/currentcheck"), //!adds the current player in the list and returns the first player ELSE THIS SHOULD BE MADE TO RECEIVE IF ALL ARE IN BREAK, THEN INSTEAD OF NAME I SHOULD GET THE BREAK THING .
        body: json.encode(widget.currentName));
    return x.body;
  }

  var responses;
  void sendDataToChannel(String text) {
    //@ SEND MESSAGE .
    Map<String, String> mapOfDataEntered = {
      "Name": widget.currentName,
      "Message": text,
    };
    channel.sink.add(json.encode(mapOfDataEntered));
  }

  var messageStream;
  var forDrawerVariable;
  Map<String, int> drawerMap = {};
  @override
  void initState() {
    super.initState();
    // forDrawer().then((value) => drawerStream.add(value));
    responses = timerForName();

    messageStream = channel.stream.asBroadcastStream();
    sendDataToChannel(
        " JOINED THE CONVERSATION========="); //this is actually for removing the bug of null value in textfield.
  }

  dynamic insideOnPressed(String str) {
    // toogleHasData = false;
    if (widget.singleValue == str) {
      if (widget.singleValue != "") {
        toogleForTextFieldIfTrue = true;
        localStreamForTextField(true);
        //  sendDataToChannel("GAVE CORRECT ANSWER");
        sendDataToChannel(str);

        return showDialog(
            context: context,
            builder: ((context) => AlertDialog(
                  title: const Text("Congratulations"),
                  content: const Text("that's the correct answer"),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("OK"),
                    ),
                  ],
                )));
      }
    } else {
      sendDataToChannel(str);
    }
  }

  // bool forDrawerUrl = true;
  List namelist = [];
  @override
  Widget build(BuildContext context) {
    // toogleReadOnly = false;
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Column(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Players Online',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(
              height: 200,
              width: 200,
              child: StreamBuilder(
                  stream: drawerStream.stream.asBroadcastStream(),
                  builder: (context, snap) {
                    if (snap.hasData) {
                      List responseList = [];
                      //responseList.add(json.decode(snap.data!.toString()));
                      responseList = json.decode((snap.data!));
                      return ListView.builder(
                          itemCount: responseList.length,
                          itemBuilder: (build, count) {
                            return ListTile(
                              leading: const Padding(
                                padding:
                                    EdgeInsets.only(left: 10.0, right: 20.0),
                                child: Icon(Icons.person_2_sharp),
                              ),
                              title: Text(responseList[count].toString()),
                            );
                          });
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text(
            'gartic clone By Aayam Pokharel and Sahil Lamsal  '), //! I HAVENOT ADDED THE REBUILD OF THE TOOGLEREADONLY ABA TYO KASARI GARNE HO BASED ON SOME VALUE GARNE HO KI HOINA BHANERA DISCUSS GARNA PARCHA .
        leading: IconButton(
          onPressed: () async {
            var res =
                await http.get(Uri.parse('http://localhost:8080/listofnames'));

            Future.delayed(const Duration(seconds: 1), () {
              drawerStream.add(res.body);
            });
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(Icons.menu),
        ),
      ),
      body: FutureBuilder(
          future:
              responses, //! responses compulsory cha cause esle add ni garirako cha the currentName to the list in the backend an return ing first  element which is irrelevant OR RETURNS BREAK IF ALL ARE IN BREAK but the thiing will only be returned after the adding of element in the liist
          builder: (context, snapshots) {
            if (snapshots.connectionState == ConnectionState.done) {
              currentTurn = snapshots.data.toString();
              return SingleChildScrollView(
                child: Column(
                  children: [
                    StreamBuilder(
                      stream: messageStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          listOfMessage
                              .add(json.decode(snapshot.data.toString()));

                          return SingleChildScrollView(
                            //#  BLUE ONE displayed after the first msg is sent else black color one.
                            child: Column(
                              children: [
                                Container(
                                  height: 300,
                                  color: Colors.blueAccent,
                                  width: double.infinity,
                                  child: ListView.builder(
                                      itemCount: listOfMessage.length,
                                      itemBuilder: (context, ind) {
                                        return Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: SizedBox(
                                            width: 222,
                                            height: 83,
                                            child: Text(
                                              " ${listOfMessage[ind]["Name"]} :${listOfMessage[ind]["Message"]}",
                                            ),
                                          ),
                                        );
                                      }),
                                ), //!problem here  BELOW:
                                StreamBuilder<bool>(
                                    //! this controls the nullness of the ok button when answer is right .
                                    stream: boolStreamController.stream,
                                    builder: (context, noEntrySnapshot) {
                                      if (snapshot.hasData) {
                                        //? this below is not required as ?? false ko use nai bhaena ni after data is there .
                                        print(noEntrySnapshot.data);
                                        print("==================");
                                        return Row(
                                          children: [
                                            Container(
                                              color: Colors.purple,
                                              width: 500,
                                              child: TextField(
                                                readOnly:
                                                    noEntrySnapshot.data ??
                                                        false,
                                                controller: chatController,
                                                onSubmitted: (text) {
                                                  if (noEntrySnapshot.data ==
                                                      false) {
                                                    insideOnPressed(text);
                                                    chatController.text = "";
                                                  } else {
                                                    null;
                                                  }
                                                },
                                              ),
                                            ),
                                            ElevatedButton(
                                                onPressed: () {
                                                  if (noEntrySnapshot.data ==
                                                      false) {
                                                    insideOnPressed(
                                                        chatController.text);
                                                    chatController.text = "";
                                                  } else {
                                                    null;
                                                  }
                                                },
                                                child: const Text("OK")),
                                          ],
                                        );
                                        // }
                                        // else {
                                        //   localStreamForTextField(true);

                                        //   return Row(
                                        //     //@ this is for boolean stream controller. only displayed when no data i.e. at first

                                        //     //! this is the row which is displayed after one click on ok as yo streambuilder returns below code first when no data . after press, there is data and never that code is repeated, and this is the one which again goes for snapshot.hasdata==false as initially it has no data.
                                        //     children: [
                                        //       Container(
                                        //         color: Colors.orange,
                                        //         width: 500,
                                        //         child: TextField(
                                        //           readOnly: false,
                                        //           controller: chatController,
                                        //           onSubmitted: (txt) {
                                        //             insideOnPressed(txt);
                                        //             chatController.text = "";
                                        //           },
                                        //         ),
                                        //       ),
                                        //       ElevatedButton(
                                        //           onPressed: () {
                                        //             insideOnPressed(
                                        //                 chatController.text);
                                        //             chatController.text = "";
                                        //           },
                                        //           child: const Text("OK")),
                                        //     ],
                                        //   );
                                      } else {
                                        return const CircularProgressIndicator();
                                      }
                                    }),
                              ],
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        //? this is returned when there is not data(only once) but if msg is not sent then this is the one that persists for blue messgage.but anyone once sends message this is never displayed in anyone except absolute new players.
                        return Column(
                          children: [
                            Container(
                              height: 300,
                              color: Colors.black,
                              width: double.infinity,
                            ),
                            StreamBuilder<bool>(
                                //# this controls the nullness of the ok button when answer is right .
                                stream: boolStreamController.stream,
                                builder: (context, initialSnapshot) {
                                  return Row(
                                    children: [
                                      Container(
                                        color: Colors.brown,
                                        width: 500,
                                        child: TextField(
                                          readOnly:
                                              initialSnapshot.data ?? false,
                                          controller: chatController,
                                          onSubmitted: (txts) {
                                            // if (initialSnapshot.data == false) {
                                            //  print("inside brown once and false");
                                            insideOnPressed(
                                                chatController.text);
                                            chatController.text = "";
                                            // } else {
                                            //   null;
                                            // }
                                          },
                                        ),
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            if (initialSnapshot.data == false) {
                                              insideOnPressed(
                                                  chatController.text);
                                              chatController.text = "";
                                            } else {
                                              null;
                                            }
                                          },
                                          child: const Text("OK")),
                                    ],
                                  );

                                  //     //@ this is the row which is displayed after one click on ok as yo streambuilder returns below code first when no data . after press, there is data and never that code is repeated, and this is the one which again goes for snapshot.hasdata==false as initially it has no data.
                                }),
                          ],
                        );
                      },
                    ),
                    Painter(
                        widget.currentName,
                        currentTurn,
                        localStreamForTextField,
                        widget.getListOfWords,
                        widget.getListOfWords),
                  ],
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }

  @override
  void dispose() {
    // Close the WebSocket channels
    channel.sink.close();

    // Close the StreamControllers
    drawerStream.close();
    boolStreamController.close();

    // Dispose the TextEditingController
    chatController.dispose();

    super.dispose();
  }
}
