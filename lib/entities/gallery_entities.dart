import 'package:flutter/material.dart';

class Picture {
  String? artist;
  Image smallPic;
  Image? largePic;
  List<String> tags;
  //TODO Use enums for resolutions 'cause it can differ with different API
  Map<String, String?> imageUris;

  Picture(
      {required this.smallPic,
      required this.tags,
      required this.imageUris});
}
