import 'package:flutter/material.dart';

class GuesserAnimationBar extends StatelessWidget {
  var forProgressBar;

  bool toogleValueForProgressBar;

  GuesserAnimationBar(this.toogleValueForProgressBar, this.forProgressBar,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: forProgressBar.forProgressBar(),
        builder: (context, fsnapshot) {
          if (fsnapshot.hasData) {
            if (!toogleValueForProgressBar) {
              toogleValueForProgressBar = true;
              var responseDoubleTime =
                  double.parse(fsnapshot.data!.toString()) * 1000 + 600;
              responseDoubleTime =
                  responseDoubleTime >= 19600 ? 19450 : responseDoubleTime;

              return TweenAnimationBuilder(
                duration: Duration(
                    milliseconds:
                        19600 - int.parse(responseDoubleTime.toString())),
                tween: Tween<double>(
                  begin: (responseDoubleTime / 1000) * 15,
                  end: MediaQuery.of(context).size.width *
                      0.75, //! instead of using mediaquery i can use layoutbuilder as it will refresh once the dimension changes and the speed is itself adjusted for animation bar .
                ),
                builder: (BuildContext context, dynamic value, Widget? child) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 2, color: Colors.black),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(928163),
                            Color.fromARGB(255, 129, 215, 241)
                          ]),
                    ),
                    height: 20,
                    width: value,
                    //  color: Colors.deepOrange,
                  );
                },
              );
            } else {
              return TweenAnimationBuilder(
                duration: const Duration(milliseconds: 19600),
                tween: Tween<double>(
                    begin: 0, end: MediaQuery.of(context).size.width * 0.75),
                builder: (BuildContext context, dynamic value, Widget? child) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 2, color: Colors.black),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(928163),
                            Color.fromARGB(255, 129, 215, 241)
                          ]),
                    ),
                    height: 20,
                    width: value,
                    //   color: Colors.deepOrange,
                  );
                },
              );
            }
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
