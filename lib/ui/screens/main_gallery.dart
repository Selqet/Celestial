import 'package:celestial/network/derpibooru_service.dart';
import 'package:flutter/material.dart';

class MainGallery extends StatefulWidget {
  const MainGallery({Key? key}) : super(key: key);

  @override
  _MainGalleryState createState() => _MainGalleryState();
}

class _MainGalleryState extends State<MainGallery> {
  final derpiService = DerpibooruService();
  int currentPage = 1;
  int currentCount = 0;
  List<APIImage> currentDisplayImages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final triggerFetchMoreSize =
          0.7 * _scrollController.position.maxScrollExtent;

      if (_scrollController.position.pixels > triggerFetchMoreSize) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.search),
            Expanded(
              child: TextField(
                decoration: InputDecoration(hintText: 'Please enter some text'),
              ),
            )
          ],
        ),
      ),
      body: _buildImageGallery(context),
    );
  }

  Widget _buildImageGallery(BuildContext context) {
    return FutureBuilder<APISearchImages>(
      future: derpiService.getSearchImages(page: currentPage),
      builder: (context, snapshot) {
        //TODO Add error handling
        if (snapshot.connectionState == ConnectionState.done) {
          currentDisplayImages.addAll(snapshot.data!.images);
          currentCount += snapshot.data!.images.length;
          currentPage++;
          //TODO Locate to custom widget
          //TODO Add list size handling
          return GridView.builder(
            controller: _scrollController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Image.network(
                  currentDisplayImages[index].representations['small']);
            },
            itemCount: currentCount,
          );
        } else {
          //TODO Return GridView
          return Opacity(
            opacity: 0.45,
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
