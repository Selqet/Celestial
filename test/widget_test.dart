// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/network/derpibooru_service.dart';
import 'package:celestial/main.dart';

Future<void> main() async {
    test('test', () async {
      final dbSer = DerpibooruService();
      var pictureList = await dbSer.getImagesList();
      print(pictureList[0].runtimeType);
    });
}
