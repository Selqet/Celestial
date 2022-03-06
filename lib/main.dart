import 'package:flutter/material.dart';
import './ui/screens/main_gallery.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.deepPurple.shade300,
              foregroundColor: Colors.black,

          ),
      ),
      home: MainGallery(),
    );
  }
}
