import 'package:http/http.dart' as http;
import 'dart:async';

class DerpibooruService {
  static const filterDefaultSafe = 100073;
  static const filterDefaultSpoilered = 37430;
  static const filterDefaultLegacy = 37431;
  static const filterEverything = 56027;
  static const filterR34 = 37432;
  static const filterDark = 37429;

  List<String>? _picturesURL;

  //TODO Reset dynamic
  Future<dynamic> getGalleryJson({String tags = 'fluttershy,safe,solo', String sortDirection = 'desc', String sortField = 'score'}) async {
    var url = 'https://derpibooru.org//api/v1/json/search/images?q=$tags&sd=$sortDirection&sf=$sortField&per_page=50';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      print(response.statusCode);
    }
    }
}

