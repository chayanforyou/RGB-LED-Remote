import 'package:flutter/material.dart';
import 'package:rgbremote/screens/remote_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: Colors.white,
      ),
      home: const ColoredBox(
        color: Color(0xFF16202A),
        child: RemoteScreen(),
      ),
    );
  }
}
