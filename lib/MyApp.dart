import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'dart:async';

import 'package:x/CorrectDialogue.dart';

import 'package:x/drawer/body.dart';
import 'package:x/drawer/header.dart';
import 'package:x/logic/apiservice.dart';
import 'package:x/logic/boolStream.dart';
import 'package:x/logic/channel.dart';
import 'package:x/logic/drawerStream.dart';
import 'package:x/messsagecontainer.dart';
import 'package:x/okButtonControl.dart';
import 'package:x/painterStructure.dart';
import 'package:x/main.dart';
import 'package:http/http.dart' as http;
import 'package:x/logic/ChatController.dart';

class MyApp extends StatefulWidget {
  final String currentName;
  final Future Function() getListOfWords;
  @override
  const MyApp(this.currentName, this.getListOfWords, {super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

bool toogleReadOnly = false; //! for textfield.

var toogleForTextFieldIfTrue =
    false; //@ if true after hitting correct answer , the client should be able to talk in break

var toogleValueForBlur = true;

class _MyAppState extends State<MyApp> {
  void toogleBlurSetState() {
    setState(() {
      toogleValueForBlur = false;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Channel channel = Channel();

  final ChatController chatController = ChatController();
  final BoolStream boolStreamController = BoolStream();

  String currentTurn = "nope"; //! dummy value as nope.
  List listOfMessage = [];
  DrawerStream drawerStream = DrawerStream();
//! names channel is to get the lit of players wheen drawer is

  var responses;

  var messageStream;
  var forDrawerVariable;
  Map<String, int> drawerMap = {};

  @override
  void initState() {
    super.initState();

    channel.sendDataToChannel(
        widget.currentName, " JOINED THE CONVERSATION=========");
    // forDrawer().then((value) => drawerStream.add(value));
    responses = ApiService.post(widget.currentName);

    messageStream = channel.broadcastStream();
  }

  dynamic insideOnPressed(String str) {
    // toogleHasData = false;
    if (singleValue == str) {
      if (singleValue != "") {
        toogleForTextFieldIfTrue =
            true; //@ if true , the client should be able to talk in break
        boolStreamController.add(true);

        channel.sendDataToChannel(widget.currentName, str);

        return showCorrectDialog(context);
      }
    } else {
      channel.sendDataToChannel(widget.currentName, str);
    }
  }

  List namelist = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // drawer: Drawer(
      //   child: Column(
      //     children: [
      //       // const Header(),
      //       SizedBox(
      //         height: 200,
      //         width: 200,
      //         child: Body(drawerStream: drawerStream),
      //       ),
      //     ],
      //   ),
      // ),
      appBar: AppBar(
        title: const Text(
            'Drawsaurus '), //! I HAVENOT ADDED THE REBUILD OF THE TOOGLEREADONLY ABA TYO KASARI GARNE HO BASED ON SOME VALUE GARNE HO KI HOINA BHANERA DISCUSS GARNA PARCHA .
        // leading: IconButton(
        //   onPressed: () async {
        //     var res =
        //         await http.get(Uri.parse('http://localhost:8080/listofnames'));

        //     Future.delayed(const Duration(seconds: 1), () {
        //       drawerStream.add(res.body);
        //     });
        //     _scaffoldKey.currentState?.openDrawer();
        //   },
        //   icon: const Icon(Icons.menu),
        // ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          FutureBuilder(
              future:
                  responses, //! responses compulsory cha cause esle add ni garirako cha the currentName to the list in the backend an return ing first  element which is irrelevant OR RETURNS BREAK IF ALL ARE IN BREAK but the thiing will only be returned after the adding of element in the liist
              builder: (context, snapshots) {
                if (snapshots.connectionState == ConnectionState.done) {
                  currentTurn = snapshots.data.toString();
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Painter(
                            widget.currentName,
                            currentTurn,
                            boolStreamController.add,
                            widget.getListOfWords,
                            toogleBlurSetState),
                        messageStreamBuilder(),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                  );
                }
              }),
          Visibility(
            //! this is for the blurred initializer.JUST DISPLAYED INITIALLY.
            visible: toogleValueForBlur,
            child: IgnorePointer(
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                      color: Colors.white.withOpacity(0.5),
                      height: double.infinity,
                      width: double.infinity,
                      child: Center(
                          child: SizedBox(
                              height: 200,
                              width: 200,
                              child: const CircularProgressIndicator())))),
            ),
          ),
        ],
      ),
    );
  }

  StreamBuilder<Object?> messageStreamBuilder() {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          listOfMessage.add(json.decode(snapshot.data.toString()));

          return Center(
            child: SingleChildScrollView(
              //#  BLUE ONE displayed after the first msg is sent else black color one.
              child: Container(
                width: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(
                      0xfff1f1f1), //@ for sizing width and height of the message box .
                ),
                child: Column(
                  children: [
                    containerForMessage(listOfMessage), //!problem here  BELOW:
                    StreamBuilder<bool>(
                        //! this controls the nullness of the ok button when answer is right .
                        stream: boolStreamController.stream,
                        builder: (context, noEntrySnapshot) {
                          return okButtonControl(
                              snapshot: snapshot,
                              noEntrySnapshot: noEntrySnapshot,
                              chatController: chatController,
                              insideOnPressed: insideOnPressed);
                        }),
                  ],
                ),
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        //? never used below.
        return const CircularProgressIndicator();
      },
    );
  }

  @override
  void dispose() {
    // Close the WebSocket channels
    channel.close();

    // Close the StreamControllers
    drawerStream.close();
    boolStreamController.close();

    // Dispose the TextEditingController
    chatController.dispose();

    super.dispose();
  }
}
