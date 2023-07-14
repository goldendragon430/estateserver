import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(color: Colors.white,),
        padding: const EdgeInsets.all(25), child: const Center(
      child:Text(
        'Hello World!', style: TextStyle(
        color: Colors.black, letterSpacing: 0.5, fontSize: 20,
      ),
        textDirection: TextDirection.ltr,
      ),
    )
    );
  }
}
