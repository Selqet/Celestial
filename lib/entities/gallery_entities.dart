import 'package:flutter/material.dart';

class GalleryPictureInfo {
  String? artist;
  Image smallPic;
  Image? largePic;
  List<String> tags;
  Map<String, String?> representations;

  GalleryPictureInfo(
      {required this.smallPic,
      required this.tags,
      required this.representations});
}
