// import 'dart:ui';

// import 'package:flutter/material.dart';

// void main() {
//   runApp(const StackPractice());
// }

// class StackPractice extends StatelessWidget {
//   const StackPractice({Key? key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Stack Practice'),
//       ),
//       body: SizedBox(
//         // Wrap with SizedBox to provide height constraint
//         height: 200, // Set desired height
//         child: Stack(
//           alignment: Alignment.bottomRight,
//           children: [
//             Container(
//               color: Colors.red,
//               height: 200,
//               width: 200,
//               child: Text(
//                 "Hello, this is a long text!",
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//             Container(
//               color: Colors.green,
//               height: 100,
//               width: 100,
//             ),
//             BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//               child: Container(
//                 color: Colors.blue.withOpacity(0.5),
//                 height: 50,
//                 width: 50,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
