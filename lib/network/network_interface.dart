import '../entities/gallery_entities.dart';

abstract class NetworkInterface {
  Future<List<GalleryPictureInfo>> getListOfImages() async {
    return <GalleryPictureInfo>[];
  }
}