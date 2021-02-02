import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sugoapp/models/photos.dart';
import 'package:sugoapp/services/profiledatabase.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';

class PhotoTile extends StatefulWidget {
  final Photos photos;
  final String uid;
  PhotoTile({this.photos, this.uid});
  @override
  _PhotoTileState createState() => _PhotoTileState();
}

class _PhotoTileState extends State<PhotoTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        showBottomModal();
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

  void showBottomModal() {
    showMaterialModalBottomSheet(
        context: context,
        builder: (context, scroll) {
          return Container(
            height: getMediaQueryHeightViaDivision(context, 5),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    viewPhoto(widget.photos.imgPath);
                  },
                  child: ListTile(
                    title: Row(
                      children: [
                        Icon(
                          Icons.image,
                          size: 20.0,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        buildLabelText('View Profile', 14.0, Colors.grey,
                            FontWeight.normal)
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    deleteImage();
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    title: Row(
                      children: [
                        Icon(
                          Icons.upload_file,
                          size: 20.0,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        buildLabelText(
                            'Delete', 14.0, Colors.grey, FontWeight.normal)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future deleteImage() async {
    print(widget.photos.photouid);
    await ProfileDatabase(uid: widget.uid)
        .deletePhoto(photouid: widget.photos.photouid);
    StorageReference ref = await FirebaseStorage.instance
        .getReferenceFromUrl(widget.photos.imgPath);
    await ref.delete();
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
