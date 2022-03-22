import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'network_interface.dart';
import '../entities/gallery_entities.dart';

//TODO Ask Vitya if I should Image.network() out of a class

class DerpibooruService implements NetworkInterface{
  //TODO Add filters to a Map?
  static const filterDefaultSafe = 100073;
  static const filterDefaultSpoilered = 37430;
  static const filterDefaultLegacy = 37431;
  static const filterEverything = 56027;
  static const filterR34 = 37432;
  static const filterDark = 37429;

  //TODO Ask Витя if I should return json instead of Map, because I don't see any difference and if it should return json in general
  Future<APISearchImages> getSearchImages(
      {tags = 'fluttershy,safe,solo,-animated',
      String sortDirection = 'desc',
      String sortField = 'score',
      int page = 1}) async {
    // !!! Url is a bit hard-coded
    //TODO Add WebM support
    var url =
        'https://derpibooru.org//api/v1/json/search/images?q=$tags,-webm&sd=$sortDirection&sf=$sortField&filter_id=$filterEverything&page=$page&per_page=50';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return APISearchImages.fromJson(jsonDecode(response.body));
    } else {
      //TODO Delete
      throw Exception('${response.statusCode} ${response.headers} ${response.reasonPhrase}');
    }
  }

  //TODO Refactor this garbage
  @override
  Future<List<GalleryPictureInfo>> getListOfImages(
      {String tags = 'fluttershy,safe,solo',
        String sortDirection = 'desc',
        String sortField = 'score',
        int page = 1,
        String size = 'small'}) async {

    List<GalleryPictureInfo> ListOfImages = [];

    var searchImages = await getSearchImages(
      tags: tags,
        page: page);
      for (int i = 0; i < searchImages.images.length; i++) {
        Image picture = Image.network(searchImages.images[i].representations['$size']);

        List<String> tags = [];
        searchImages.images[i].tags.forEach((element) {
          tags.add(element.toString());
        });

        Map<String,String?> imageRepresentations = {};
        searchImages.images[i].representations.forEach((key, value) {
          imageRepresentations[key] = value?.toString();
        });

        ListOfImages.add(GalleryPictureInfo(
            smallPic: picture,
            tags: tags,
            representations: imageRepresentations
        ));
      }
      return ListOfImages;
    }
}

class APISearchImages {
  List<APIImage> images;
  int total;

  APISearchImages({required this.images, required this.total});

  factory APISearchImages.fromJson(Map<String, dynamic> json) {
    var imagesList = <APIImage>[];

    for (var image in json['images']) {
      imagesList.add(APIImage.fromJson(image));
    }

    return APISearchImages(
      images: imagesList,
      total: json['total'],
    );
  }
}

class APIImage {
  //TODO Maybe add final
  //TODO !!! Use nullability
  Map<String, dynamic> representations;
  List<dynamic> tags;
  int id;
  int width;
  int height;
  double aspectRatio;
  String? sourceUrl;
  bool animated;
  bool spoilered;

  //TODO Add this to Map
  int faves;
  int score;
  int downvotes;
  double wilsonScore;
  int commentCount;

  APIImage(
      {required this.representations,
      required this.tags,
      required this.id,
      required this.width,
      required this.height,
      required this.aspectRatio,
      required this.sourceUrl,
      required this.animated,
      required this.spoilered,
      required this.faves,
      required this.score,
      required this.downvotes,
      required this.wilsonScore,
      required this.commentCount});

  factory APIImage.fromJson(Map<String, dynamic> json) {
    return APIImage(
      representations: json['representations'],
      tags: json['tags'],
      id: json['id'],
      width: json['width'],
      height: json['height'],
      aspectRatio: json['aspect_ratio'],
      sourceUrl: json['source_url'],
      animated: json['animated'],
      spoilered: json['spoilered'],
      faves: json['faves'],
      score: json['score'],
      downvotes: json['downvotes'],
      wilsonScore: json['wilson_score'],
      commentCount: json['comment_count'],
    );
  }
}
