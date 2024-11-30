import "package:flutter/material.dart";

Container messageContainer(List listOfMessage) {
  return Container(
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
  );
}
