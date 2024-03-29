import 'package:celestial/network/network_interface.dart';
import 'package:flutter/material.dart';
import 'package:celestial/entities/gallery_entities.dart';
import 'package:celestial/ui/screens/picture_screen.dart';

class MainGallery extends StatefulWidget {
  const MainGallery({Key? key}) : super(key: key);

  @override
  _MainGalleryState createState() => _MainGalleryState();
}

class _MainGalleryState extends State<MainGallery> {
  final derpiService = NetworkInterface();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchTextController =
      TextEditingController(text: '');

  int currentPage = 1;
  int currentCount = 0;
  bool loading = false;
  List<Picture> currentDisplayImages = [];
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
            ),
          ],
        ),
      ),
      body: _buildImageGallery(context),
    );
  }


  Widget _buildImageGallery(BuildContext context) {
    //TODO Think about creating stream to add pictures to list
    return FutureBuilder<List<Picture>>(
      // ignore: argument_type_not_assignable
      future: derpiService.getListOfPictures(
          tags: currentSearchText, page: currentPage),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            //TODO Add cute error message
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
                  pictureInfo(context, currentDisplayImages[index])),
        );
      },
    );
  }
}
