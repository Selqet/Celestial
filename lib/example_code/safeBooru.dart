import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:async';

Future<Picture> fetchPicture(String tags) async {
  final response = await http.get(Uri.parse(
      'https://derpibooru.org//api/v1/json/search/images?q=safe,$tags&sd=desc&sf=score&per_page=50'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Picture.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Picture {
  final String pictureURL;

  Picture({
    required this.pictureURL,
  });

  factory Picture.fromJson(Map<String, dynamic> json) {
    List images = json['images'];

    var rng = Random();

    return Picture(
      pictureURL:
          images[rng.nextInt(50)]['representations']['large'].toString(),
    );
  }
}

class SafeBooruWidget extends StatelessWidget {
  SafeBooruWidget({Key? key}) : super(key: key);

  String tags = 'fluttershy,solo';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CelesteFinder',
      theme: ThemeData.dark(),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: TextField(
            onSubmitted: (text) {
              this.tags = (text);
              print(this.tags);
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'CelesteFinder',
            ),
          ),
        ),
        body: SafeMainImageWidget(
          tags: this.tags,
        )
      ),
    );
  }
}

class SafeMainImageWidget extends StatefulWidget {
  SafeMainImageWidget({Key? key,
  required this.tags}) : super(key: key);
  String tags;

  @override
  _SafeMainImageWidgetState createState() => _SafeMainImageWidgetState();

}

class _SafeMainImageWidgetState extends State<SafeMainImageWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {setState(() {});
        print(widget.tags);},
        child: FutureBuilder<Picture>(
          future: fetchPicture(widget.tags),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Image.network(snapshot.data!.pictureURL);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
      //ElevatedButton(onPressed: () => setState(() {}), child: Text('Click'))
    );
  }
}
