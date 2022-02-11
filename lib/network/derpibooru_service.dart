import 'dart:convert';

import 'package:http/http.dart' as http;

class DerpibooruService {
  //TODO Add filters to Map?
  static const filterDefaultSafe = 100073;
  static const filterDefaultSpoilered = 37430;
  static const filterDefaultLegacy = 37431;
  static const filterEverything = 56027;
  static const filterR34 = 37432;
  static const filterDark = 37429;

  //TODO Add filter_id and page handling
  //TODO Rename to be more representative
  Future<Map<String, dynamic>> getGalleryJson(
      {String tags = 'fluttershy,safe,solo',
      String sortDirection = 'desc',
      String sortField = 'score'}) async {
    var url =
        'https://derpibooru.org//api/v1/json/search/images?q=$tags&sd=$sortDirection&sf=$sortField&per_page=50';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get derpibooru response');
    }
  }

  //TODO Delete this function
  List<String> getImagesUrl(Map<String, dynamic> gallery) {
    var imagesInfo = gallery['images'];
    var imagesUrl = <String>[];
    for (final image in imagesInfo) {
      imagesUrl.add(image['representations']['full']);
    }
    return imagesUrl;
  }
}

//TODO Add Constructors
class APIImage {
  //TODO Google if I need add final
  int width;
  int height;
  String sourceUrl;
  int id;

  //TODO Add this to Map
  int faves;
  int score;
  int downvotes;
  int commentCount;

  List<String> tags;
  //TODO Add else useful info
}