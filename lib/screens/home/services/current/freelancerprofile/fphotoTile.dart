import 'package:flutter/material.dart';
import 'package:sugoapp/models/photos.dart';
import 'package:sugoapp/shared/constants.dart';

class FPhotoTile extends StatefulWidget {
  final Photos photos;
  final String uid;
  FPhotoTile({this.photos, this.uid});
  @override
  _FPhotoTileState createState() => _FPhotoTileState();
}

class _FPhotoTileState extends State<FPhotoTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        viewPhoto(widget.photos.imgPath);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Image.network(
            widget.photos.imgPath,
            fit: BoxFit.cover,
            errorBuilder: (context, exception, stacktrace) {
              print('error');
              return Icon(
                Icons.image_not_supported,
                size: 35,
                color: Colors.grey,
              );
            },
          ),
        ),
      ),
    );
  }

  void viewPhoto(String url) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              child: SizedBox(
                height: getMediaQueryHeightViaDivision(context, 2),
                width: getMediaQueryHeightViaDivision(context, 1),
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (context, exception, stacktrace) {
                    return Icon(
                      Icons.image_not_supported,
                      size: 35,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            ),
          );
        });
  }
}
