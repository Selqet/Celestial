import 'package:flutter/material.dart';

class GalleryPictureInfo {
  Image smallPic;
  Image? largePic;
  List<String> tags;

  GalleryPictureInfo({required this.smallPic, required this.tags});
}