import 'package:http/http.dart';

const String apiKey = '2346803f4bfbab4af89fe8afd6b55dbb';
const String apiId = 'd7a79077';
const String apiUrl = 'https://api.edamam.com/search';

class RecipeService {

  Future getData(String url) async {
    print('Calling url: $url');
    final response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      print(response.statusCode);
    }
  }

  Future<dynamic> getRecipes(String query, int from, int to) async {
    final recipeData = await getData(
        '$apiUrl?app_id=$apiId&app_key=$apiKey&q=$query&from=$from&to=$to');
    return recipeData;
  }
}