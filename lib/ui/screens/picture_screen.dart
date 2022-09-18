import 'package:celestial/entities/gallery_entities.dart';
import 'package:flutter/material.dart';

//TODO Think if I should do valuechecking for small pic
Widget pictureInfo(BuildContext context, Picture picture) {
  picture.largePic = Image.network(picture.imageUris['large']!);

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
          children: listOfChipTags,
        )
      ],
    ),
  );
}