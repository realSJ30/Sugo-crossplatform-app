import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sugoapp/models/photos.dart';
import 'package:sugoapp/screens/home/profile/floatingactionbutton.dart';
import 'package:sugoapp/screens/home/profile/photostab/photoList.dart';
import 'package:sugoapp/screens/home/profile/photostab/uploadphoto.dart';
import 'package:sugoapp/services/profiledatabase.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';

class PhotosTab extends StatefulWidget {
  final String uid;

  PhotosTab({this.uid});
  @override
  _PhotosTabState createState() => _PhotosTabState();
}

class _PhotosTabState extends State<PhotosTab> {
  String imagePath;
  PickedFile imageFile;
  ImagePicker _picker = new ImagePicker();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: UploadActionButton(
        callback: () {
          print('float');
          _showChoiceDialog();
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: info(),
          ),
          Expanded(
              child: StreamProvider<List<Photos>>.value(
            value: ProfileDatabase(uid: widget.uid).photos,
            child: PhotoList(
              uid: widget.uid,
            ),
          ))
        ],
      ),
    ));
  }

  Widget info() {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.grey,
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: buildLabelText(
                  'Upload photos wherein you can showcase your skills and proof of transacts.',
                  14.0,
                  Colors.grey,
                  FontWeight.normal),
            )
          ],
        ),
        separator(5.0),
        Container(
          decoration:
              BoxDecoration(border: Border.all(width: 2, color: Colors.grey)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: buildSubLabelText(
                  'My Photos', 18.0, Colors.grey, FontWeight.normal),
            ),
          ),
        )
      ],
    );
  }

  Future<void> _showChoiceDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: buildSubLabelText(
                'Choose Option: ', 14.0, Colors.grey, FontWeight.normal),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  InkWell(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.image,
                          color: primaryColor,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        buildLabelText(
                            'Gallery', 14.0, primaryColor, FontWeight.normal),
                      ],
                    ),
                    onTap: () {
                      _openGallery();
                    },
                  ),
                  separator(25.0),
                  InkWell(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.camera_alt,
                          color: primaryColor,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        buildLabelText(
                            'Camera', 14.0, primaryColor, FontWeight.normal),
                      ],
                    ),
                    onTap: () {
                      _openCamera();
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  _openCamera() async {
    //async kay dugay mgpili og picture takes time to process kng unsa mapili
    var picture = await _picker.getImage(source: ImageSource.camera);
    this.setState(() {
      if (picture != null) {
        imageFile = picture;
        imagePath = imageFile.path;
      }
    });
    Navigator.of(context).pop();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UploadPhoto(
                  uid: widget.uid,
                  imgPath: this.imagePath,
                )));
  }

  _openGallery() async {
    //async kay dugay mgpili og picture takes time to process kng unsa mapili
    var picture = await _picker.getImage(source: ImageSource.gallery);

    this.setState(() {
      if (picture != null) {
        imageFile = picture;
        imagePath = imageFile.path;
      }
    });

    Navigator.of(context).pop();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UploadPhoto(
                  imgPath: this.imagePath,
                  uid: widget.uid,
                )));
  }
}
