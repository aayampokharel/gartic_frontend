// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:x/painter.dart';

// class message extends StatefulWidget {
//   var messageStream;
//   var boolStreamController;
//   //var chatController;
//   var listOfMessage;
//   var currentName;
//   // var currentName;

//   message(this.messageStream, this.boolStreamController, this.listOfMessage,
//       this.currentName);

//   @override
//   State<message> createState() => _messageState();
// }

// class _messageState extends State<message> {
//   TextEditingController chatController = TextEditingController();
//   List listOfMessage = [];
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     void insideOnPressed(String text) {}
//     return  StreamBuilder(
//                       stream: messageStream,
//                       builder: (context, snapshot) {
//                         if (snapshot.hasData) {
//                           listOfMessage
//                               .add(json.decode(snapshot.data.toString()));

//                           return SingleChildScrollView(
//                             //#  BLUE ONE displayed after the first msg is sent else black color one.
//                             child: Column(
//                               children: [
//                                 Container(
//                                   height: 300,
//                                   color: Colors.blueAccent,
//                                   width: double.infinity,
//                                   child: ListView.builder(
//                                       itemCount: listOfMessage.length,
//                                       itemBuilder: (context, ind) {
//                                         return Padding(
//                                           padding: const EdgeInsets.all(10),
//                                           child: SizedBox(
//                                             width: 222,
//                                             height: 83,
//                                             child: Text(
//                                               " ${listOfMessage[ind]["Name"]} :${listOfMessage[ind]["Message"]}",
//                                             ),
//                                           ),
//                                         );
//                                       }),
//                                 ),
//                                 StreamBuilder<bool>(
//                                     //! this controls the nullness of the ok button when answer is right .
//                                     stream: boolStreamController.stream,
//                                     builder: (context, noEntrySnapshot) {
//                                       if (snapshot.hasData) {
//                                         //? this below is not required as ?? false ko use nai bhaena ni after data is there .

//                                         return Row(
//                                           children: [
//                                             Container(
//                                               color: Colors.purple,
//                                               width: 500,
//                                               child: TextField(
//                                                 readOnly:
//                                                     noEntrySnapshot.data ??
//                                                         false,
//                                                 controller: chatController,
//                                                 onSubmitted: (text) {
//                                                   if (noEntrySnapshot.data ==
//                                                       false) {
//                                                     insideOnPressed(text);
//                                                     chatController.text = "";
//                                                   } else {
//                                                     null;
//                                                   }
//                                                 },
//                                               ),
//                                             ),
//                                             ElevatedButton(
//                                                 onPressed: () {
//                                                   if (noEntrySnapshot.data ==
//                                                       false) {
//                                                     insideOnPressed(
//                                                         chatController.text);
//                                                     chatController.text = "";
//                                                   } else {
//                                                     null;
//                                                   }
//                                                 },
//                                                 child: Text("OK")),
//                                           ],
//                                         );
//                                         // }
//                                         // else {
//                                         //   localStreamForTextField(true);

//                                         //   return Row(
//                                         //     //@ this is for boolean stream controller. only displayed when no data i.e. at first

//                                         //     //! this is the row which is displayed after one click on ok as yo streambuilder returns below code first when no data . after press, there is data and never that code is repeated, and this is the one which again goes for snapshot.hasdata==false as initially it has no data.
//                                       } else {
//                                         return const CircularProgressIndicator();
//                                       }
//                                     }),
//                               ],
//                             ),
//                           );
//                         }
//                         if (snapshot.hasError) {
//                           return Text('Error: ${snapshot.error}');
//                         }

//                         //? this is returned when there is not data(only once) but if msg is not sent then this is the one that persists for blue messgage.but anyone once sends message this is never displayed in anyone except absolute new players.
//                         return Column(
//                           children: [
//                             Container(
//                               height: 300,
//                               color: Colors.black,
//                               width: double.infinity,
//                             ),
//                             StreamBuilder<bool>(
//                                 //# this controls the nullness of the ok button when answer is right .
//                                 stream: boolStreamController.stream,
//                                 builder: (context, initialSnapshot) {
//                                   return Row(
//                                     children: [
//                                       Container(
//                                         color: Colors.brown,
//                                         width: 500,
//                                         child: TextField(
//                                           readOnly:
//                                               initialSnapshot.data ?? false,
//                                           controller: chatController,
//                                           onSubmitted: (txts) {
//                                             // if (initialSnapshot.data == false) {
//                                             //  print("inside brown once and false");
//                                             insideOnPressed(
//                                                 chatController.text);
//                                             chatController.text = "";
//                                             // } else {
//                                             //   null;
//                                             // }
//                                           },
//                                         ),
//                                       ),
//                                       ElevatedButton(
//                                           onPressed: () {
//                                             if (initialSnapshot.data == false) {
//                                               insideOnPressed(
//                                                   chatController.text);
//                                               chatController.text = "";
//                                             } else {
//                                               null;
//                                             }
//                                           },
//                                           child: const Text("OK")),
//                                     ],
//                                   );

//                                   //     //@ this is the row which is displayed after one click on ok as yo streambuilder returns below code first when no data . after press, there is data and never that code is repeated, and this is the one which again goes for snapshot.hasdata==false as initially it has no data.
//                                 }),
//                           ],
//                         );
//                       },
//                     )
//   }

//   @override
//   void dispose() {
//     // Dispose the TextEditingController
//     chatController.dispose();

//     super.dispose();
//   }
// }
