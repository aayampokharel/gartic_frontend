import "package:flutter/material.dart";

Future showCorrectDialog(BuildContext context) {
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
