import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:celestial/entities/gallery_entities.dart';

abstract class NetworkInterface {
  factory NetworkInterface() => DerpibooruService();

  Future<List<Picture>> getListOfPictures(
      {String tags = '', int page = 1}) async {
    return <Picture>[];
  }
}

//TODO Ask Vitya if I should Image.network() out of a class

class DerpibooruService implements NetworkInterface {
  //TODO Add filters to a Map?
  static const filterDefaultSafe = 100073;

  //static const filterDefaultSpoilered = 37430;
  //static const filterDefaultLegacy = 37431;
  //static const filterEverything = 56027;
  //static const filterR34 = 37432;
  //static const filterDark = 37429;
  static const additionalFilterTags = ',safe,-seizure warning';
  static const notSupportedTags = ',-webm';
  static const picsPerPage = 50;

  @override
  Future<List<Picture>> getListOfPictures(
      {String tags = 'fluttershy,safe,solo',
      String sortDirection = 'desc',
      String sortField = 'score',
      int page = 1,
      String size = 'small'}) async {
    List<Picture> listOfImages = [];
    var searchedTagsData = await getSearchedTagsData(tags: tags, page: page);

    for (int i = 0; i < searchedTagsData.images.length; i++) {
      ApiPicture apiPic = searchedTagsData.images[i];
      String apiPicUrl = apiPic.downloadUrls[size];

      Image image = downloadImage(apiPicUrl);
      var tags = List<String>.from(apiPic.tags);
      var imageUris = Map<String, String?>.from(apiPic.downloadUrls);

      var picture = Picture(smallPic: image, tags: tags, imageUris: imageUris);

      listOfImages.add(picture);
    }
    return listOfImages;
  }

  //TODO Ask Витя if I should return json instead of Map, because I don't see any difference and if it should return json in general
  Future<ApiPicturesData> getSearchedTagsData(
      {tags = 'fluttershy,safe,solo,-animated',
      String sortDirection = 'desc',
      String sortField = 'score',
      int page = 1}) async {
    //TODO Add WebM support
    var url =
        'https://derpibooru.org//api/v1/json/search/images?q=$tags$additionalFilterTags$notSupportedTags&sd=$sortDirection&sf=$sortField&filter_id=$filterDefaultSafe&page=$page&per_page=$picsPerPage';

    var parsedUri = Uri.parse(url);
    final response = await http.get(parsedUri);
    if (response.statusCode == 200) {
      return ApiPicturesData.fromJson(jsonDecode(response.body));
    } else {
      //TODO Delete
      throw Exception(
          '${response.statusCode} ${response.headers} ${response.reasonPhrase}');
    }
  }

  Image downloadImage(String url) {
    return Image.network(url);
  }
}

class ApiPicturesData {
  List<ApiPicture> images;
  int total;

  ApiPicturesData({required this.images, required this.total});

  factory ApiPicturesData.fromJson(Map<String, dynamic> json) {
    var imagesList = <ApiPicture>[];

    for (var image in json['images']) {
      imagesList.add(ApiPicture.fromJson(image));
    }

    return ApiPicturesData(
      images: imagesList,
      total: json['total'],
    );
  }
}

class ApiPicture {
  //TODO Maybe add final
  //TODO !!! Use nullability
  Map<String, dynamic> downloadUrls;
  List<dynamic> tags;
  int id;
  int width;
  int height;
  double aspectRatio;
  String? sourceUrl;
  bool animated;
  bool spoilered;

  //TODO Add this to a Map
  int faves;
  int score;
  int downvotes;
  double wilsonScore;
  int commentCount;

  ApiPicture(
      {required this.downloadUrls,
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

  factory ApiPicture.fromJson(Map<String, dynamic> json) {
    return ApiPicture(
      downloadUrls: json['representations'],
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
