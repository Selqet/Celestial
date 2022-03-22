import 'dart:math';

import 'package:celestial/network/derpibooru_service.dart';
import 'package:flutter/material.dart';
import '../../entities/gallery_entities.dart';

class MainGallery extends StatefulWidget {
  const MainGallery({Key? key}) : super(key: key);

  @override
  _MainGalleryState createState() => _MainGalleryState();
}

class _MainGalleryState extends State<MainGallery> {
  //TODO Add/Ask Vitya if I should add abstract factory
  final derpiService = DerpibooruService();

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchTextController =
      TextEditingController(text: '');
  int currentPage = 1;
  int currentCount = 0;
  bool loading = false;
  List<GalleryPictureInfo> currentDisplayImages = [];
  String currentSearchText = 'fluttershy,safe,solo,-animated';

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
            const Icon(Icons.search),
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: TextField(
                controller: _searchTextController,
                decoration:
                    const InputDecoration(hintText: 'Please enter some text'),
                onSubmitted: (String text) {
                  setState(() {
                    currentPage = 1;
                    currentCount = 0;
                    currentDisplayImages.clear();
                    currentSearchText = text;
                  });
                },
              ),
            )
          ],
        ),
      ),
      body: _buildImageGallery(context),
    );
  }

  Widget _buildImageGallery(BuildContext context) {
    return FutureBuilder<List<GalleryPictureInfo>>(
      future: derpiService.getListOfImages(
          tags: currentSearchText, page: currentPage),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            //TODO Add beautiful error message
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
        return _galleryPicture(context, index);
      },
      //padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
      itemCount: currentCount,
    );
  }

  Widget _galleryPicture(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        //TODO Try shape:
        child: FittedBox(
          child: currentDisplayImages[index].smallPic,
          fit: BoxFit.cover,
          clipBehavior: Clip.hardEdge,
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  _pictureInfo(context, currentDisplayImages[index])),
        );
      },
    );
  }

  //TODO Locate to another file
  //TODO Think if I should do valuechecking for small pic
  Widget _pictureInfo(BuildContext context, GalleryPictureInfo picture) {
    picture.largePic = Image.network(picture.representations['large']!);

    for (var tag in picture.tags) {
      if (tag.contains('artist:')) {
        picture.artist = tag.substring('artist:'.length);
      }
    }

    List<Chip> listOfChipTags = [];
    for (var tag in picture.tags) {
      listOfChipTags.add(Chip(
        label: Text(
          tag,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pink.shade200,
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('✨🦄✨'),
      ),
      body: ListView(
        children: [
          Container(child: picture.largePic),
          const SizedBox(height: 20),
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: <TextSpan>[
                const TextSpan(
                    text: 'Artist: ', style: TextStyle(color: Colors.black87)),
                TextSpan(
                    text: picture.artist,
                    style: const TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold))
              ])),
          const SizedBox(height: 20),
          Wrap(
            spacing: 5.0,
            alignment: WrapAlignment.spaceEvenly,
            direction: Axis.horizontal,
            children: [...listOfChipTags],
          )
        ],
      ),
    );
  }
}
