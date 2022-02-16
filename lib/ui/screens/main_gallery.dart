import 'dart:io';

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
  bool loading = false;
  List<Image> currentDisplayImages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final triggerFetchMoreSize =
          0.5 * _scrollController.position.maxScrollExtent;

      if (_scrollController.position.pixels > triggerFetchMoreSize) {
        if (!loading) {
          setState(() {
            loading = true;
          });
        }
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
    return FutureBuilder<List<Image>>(
      future: derpiService.getListOfImages(page: currentPage),
      builder: (context, snapshot) {
        //TODO Add error handling
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString(),
                  textAlign: TextAlign.center, textScaleFactor: 1.3),
            );
          }
          loading = false;
          final data = snapshot.data;
          if (data != null) {
            currentDisplayImages.addAll(data);
            currentCount += data.length;
            currentPage++;
          }
          return _buildGalleryGrid(context);
        } else {
          return _buildGalleryGrid(context);
        }
      },
    );
  }

  Widget _buildGalleryGrid(BuildContext context) {
    return GridView.builder(
      controller: _scrollController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (BuildContext context, int index) {
        return currentDisplayImages[index];
      },
      //padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
      itemCount: currentCount,
    );
  }
}
