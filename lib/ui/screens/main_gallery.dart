import 'package:flutter/material.dart';


class MainGallery extends StatefulWidget {
  const MainGallery({Key? key}) : super(key: key);

  @override
  _MainGalleryState createState() => _MainGalleryState();
}

class _MainGalleryState extends State<MainGallery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.search),
            Expanded(
              child: TextField(
                decoration: InputDecoration(hintText: 'Please enter some text'),
              ),
            )
          ],
        ),
      ),
      drawer: Drawer(),
    );
  }
}
