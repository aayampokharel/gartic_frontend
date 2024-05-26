import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:x/painter.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApps());
}

class MyApps extends StatelessWidget {
  const MyApps({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Name(),
    );
  }
}

class Name extends StatefulWidget {
  const Name({super.key});

  @override
  State<Name> createState() => _NameState();
}

// var singleValue = http.get(Uri.parse("http://localhost:8080/listofwords"));
var singleValue;
var listOfName = [];

class _NameState extends State<Name> {
  TextEditingController loginController = TextEditingController();
  //
  //
  //? getkustofwords() returns a single word from backend in thee break section in painter
  Future getListOfWords() async {
    var response = await http.get(Uri.parse(
        "http://localhost:8080/listofwords")); //! not list of word but the neext word in queue from backend
    return response.body;
  }

  //
  //
  //? end

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("keep your name"),
      ),
      body: Column(
        children: [
          TextField(
            controller: loginController, //@ this is useful for login with name
            onSubmitted: (t) {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MyApp(loginController.text, getListOfWords);
              }));
            },
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return MyApp(loginController.text, getListOfWords);
                }));
              },
              child: Text("Ok")),
        ],
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  final String currentName;
  final Future Function() getListOfWords;
  @override
  MyApp(this.currentName, this.getListOfWords);
  State<MyApp> createState() => _MyAppState();
}

//bool toogleHasData = true;
bool toogleReadOnly = false;

class _MyAppState extends State<MyApp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final channel = WebSocketChannel.connect(Uri.parse('ws://localhost:8080/'));

  TextEditingController chatController = TextEditingController();
  List listOfMessage = [];
  StreamController<bool> boolStreamController = StreamController();

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
            "http://localhost:8080/currentcheck"), //!adds the current player in the list and returns the first player
        body: json.encode(widget.currentName));
    return x.body;
  }

  var responses;
  void sendDataToChannel(String text) {
    print("ready to send ");
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

    //
    messageStream = channel.stream.asBroadcastStream();
  }

  dynamic insideOnPressed(String str) {
    // toogleHasData = false;
    if (singleValue == str) {
      localStreamForTextField(true);
      sendDataToChannel("GAVE CORRECT ANSWER");

      return showDialog(
          context: context,
          builder: ((context) => AlertDialog(
                title: Text("Congratulation"),
                content: Text("that the correct answer"),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("OK"),
                  ),
                ],
              )));
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
            DrawerHeader(
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
            Container(
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
                              leading: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 20.0),
                                child: Icon(Icons.person_2_sharp),
                              ),
                              title: Text(responseList[count].toString()),
                            );
                          });
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
            'clone '), //! I HAVENOT ADDED THE REBUILD OF THE TOOGLEREADONLY ABA TYO KASARI GARNE HO BASED ON SOME VALUE GARNE HO KI HOINA BHANERA DISCUSS GARNA PARCHA .
        leading: IconButton(
          onPressed: () async {
            var res =
                await http.get(Uri.parse('http://localhost:8080/listofnames'));

            Future.delayed(Duration(seconds: 2), () {
              drawerStream.add(res.body);
            });
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: Icon(Icons.menu),
        ),
      ),
      body: FutureBuilder(
          future:
              responses, //! responses compulsory cha cause esle add ni garirako cha the currentName to the list in the backend an return ing first  element which is irrelevant but the thiing will only be returned after the adding of element in the liist
          builder: (context, snapshots) {
            if (snapshots.connectionState == ConnectionState.done) {
              print(snapshots.data);
              print("🔥🔥🔥🔥");
              currentTurn = snapshots.data.toString();
              return StreamBuilder(
                stream: messageStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    listOfMessage.add(json.decode(snapshot.data.toString()));
                    print(listOfMessage);

                    return SingleChildScrollView(
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
                                    padding: EdgeInsets.all(10),
                                    child: Container(
                                      width: 222,
                                      height: 83,
                                      child: Text(
                                        " ${listOfMessage[ind]["Name"]} :${listOfMessage[ind]["Message"]}",
                                      ),
                                    ),
                                  );
                                }),
                          ), //!problem here  BEELOW:
                          StreamBuilder<bool>(
                              //! this controls the nullness of the ok button when answer is right .
                              stream: boolStreamController.stream,
                              builder: (context, snapshot) {
                                print(snapshot.data);
                                print("|||||||||||||||||||||||");
                                if (snapshot.hasData) {
                                  print(snapshot.data);
                                  print("🔥🔥🔥🔥🔥");
                                  return Row(
                                    children: [
                                      Container(
                                        color: Colors.green,
                                        width: 500,
                                        child: TextField(
                                          readOnly: snapshot.data ?? false,
                                          controller: chatController,
                                          onSubmitted: (text) {
                                            if (snapshot.data == false) {
                                              insideOnPressed(text);
                                              chatController.text = "";
                                            } else {
                                              null;
                                            }
                                          },
                                        ),
                                      ),
                                      // ElevatedButton(
                                      //     onPressed: () {
                                      //       if (snapshot.data == false) {
                                      //         insideOnPressed(
                                      //             chatController.text);
                                      //         chatController.text = "";
                                      //       } else {
                                      //         null;
                                      //       }
                                      //     },
                                      //     child: Text("OK")),
                                    ],
                                  );
                                } else {
                                  localStreamForTextField(true);

                                  return Row(
                                    //! this is the row which is displayed after one click on ok as yo streambuilder returns below code first when no data . after press, there is data and never that code is repeated, and this is the one which again goes for snapshot.hasdata==false as initially it has no data.
                                    children: [
                                      Container(
                                        color: Colors.white,
                                        width: 500,
                                        child: TextField(
                                          readOnly: false,
                                          controller: chatController,
                                          onSubmitted: (txt) {
                                            insideOnPressed(txt);
                                            chatController.text = "";
                                          },
                                        ),
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            insideOnPressed(
                                                chatController.text);
                                            chatController.text = "";
                                          },
                                          child: Text("OK")),
                                    ],
                                  );
                                }
                              }),

                          Painter(widget.currentName, currentTurn,
                              localStreamForTextField, widget.getListOfWords),
                        ],
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  //! this is returned when there i no daat a (only once)
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: 300,
                          color: Colors.black,
                          width: double.infinity,
                        ),
                        StreamBuilder<bool>(
                            //! this controls the nullness of the ok button when answer is right .
                            stream: boolStreamController.stream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Row(
                                  children: [
                                    Container(
                                      color: Colors.green,
                                      width: 500,
                                      child: TextField(
                                        readOnly: snapshot.data ?? false,
                                        controller: chatController,
                                        onSubmitted: (txts) {
                                          if (snapshot.data == false) {
                                            insideOnPressed(
                                                chatController.text);
                                            chatController.text = "";
                                          } else {
                                            null;
                                          }
                                        },
                                      ),
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          if (snapshot.data == false) {
                                            insideOnPressed(
                                                chatController.text);
                                            chatController.text = "";
                                          } else {
                                            null;
                                          }
                                        },
                                        child: Text("OK")),
                                  ],
                                );
                              } else {
                                localStreamForTextField(true);

                                return Row(
                                  //! this is the row which is displayed after one click on ok as yo streambuilder returns below code first when no data . after press, there is data and never that code is repeated, and this is the one which again goes for snapshot.hasdata==false as initially it has no data.
                                  children: [
                                    Container(
                                      color: Colors.white,
                                      width: 500,
                                      child: TextField(
                                        readOnly: false,
                                        controller: chatController,
                                        onSubmitted: (t) {
                                          insideOnPressed(chatController.text);
                                          chatController.text = "";
                                        },
                                      ),
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          insideOnPressed(chatController.text);
                                          chatController.text = "";
                                        },
                                        child: Text("OK")),
                                  ],
                                );
                              }
                            }),
                        Painter(widget.currentName, currentTurn,
                            localStreamForTextField, widget.getListOfWords),
                      ],
                    ),
                  );
                },
              );
            } else {
              return CircularProgressIndicator();
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
