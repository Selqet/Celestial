//TODO This function doesn't belong here. Maybe converge with function above, but it will do too much. Ask Витя
//TODO Delete function, I need aspectRatio for GridView from corresponding class
Future<List<String>> getImagesList(
    {String tags = 'fluttershy,safe,solo',
      String sortDirection = 'desc',
      String sortField = 'score',
      int page = 1,
      String size = 'medium'}) async {
  final imagesJson = await getSearchImagesJson(tags: tags, sortDirection: sortDirection, sortField: sortField, page: page);
  final searchImages = APISearchImages.fromJson(imagesJson);
  var imagesList = <String>[];
  for (var image in searchImages.images) {
    imagesList.add(image.representations['$size']);
  }
  return imagesList;
}