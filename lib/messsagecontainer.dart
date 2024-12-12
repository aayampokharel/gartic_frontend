import 'package:flutter/material.dart';

Container containerForMessage(List<dynamic> listOfMessage) {
  return Container(
    height: 200,
    color: const Color(0xfff1f1f1),
    width: double.infinity,
    child: ListView.builder(
        itemCount: listOfMessage.length,
        itemBuilder: (context, ind) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  " ${listOfMessage[ind]["Name"]} :${listOfMessage[ind]["Message"]}",
                ),
              ),
            ),
          );
        }),
  );
}
