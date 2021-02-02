import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:sugoapp/services/profiledatabase.dart';
import 'dart:math';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';

class UploadPhoto extends StatefulWidget {
  final String imgPath;
  final String uid;
  UploadPhoto({this.imgPath, this.uid});

  @override
  _UploadPhotoState createState() => _UploadPhotoState();
}

class _UploadPhotoState extends State<UploadPhoto> {
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LoadingOverlay(
        isLoading: isloading,
        child: Scaffold(
          appBar: appBar('Upload Photo'),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: RaisedButton(
            color: primaryColor,
            splashColor: secondaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            onPressed: () {
              uploadImage(this.widget.imgPath, context);
            },
            child: buildLabelText(
                'Upload Photo', 14.0, Colors.white, FontWeight.normal),
          ),
          body: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.blue)),
                    child: SizedBox(
                      width: getMediaQueryWidthViaDivision(context, 1),
                      height: getMediaQueryHeightViaDivision(context, 2),
                      child: Image.file(
                        File(widget.imgPath),
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future uploadImage(String _imagePath, BuildContext context) async {
    this.setState(() {
      this.isloading = true;
    });

    Random random = new Random();
    String randomRef =
        '${DateTime.now().toIso8601String()}_${random.nextInt(10)}_${random.nextInt(100)}';
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child(widget.uid)
        .child('photos')
        .child('$randomRef.jpg');
    StorageUploadTask uploadTask = ref.putFile(File(_imagePath));

    String url = await (await uploadTask.onComplete).ref.getDownloadURL();

    print(url);
    await ProfileDatabase(uid: widget.uid)
        .uploadPhoto(name: randomRef, url: url);
    Navigator.pop(context);
  }
}
