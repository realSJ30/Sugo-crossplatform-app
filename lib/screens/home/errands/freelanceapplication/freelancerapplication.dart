import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:sugoapp/services/database.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';
import 'package:sugoapp/services/auth.dart';

class FreelanceApplication extends StatefulWidget {
  @override
  _FreelanceApplicationState createState() => _FreelanceApplicationState();
}

class _FreelanceApplicationState extends State<FreelanceApplication> {
  AuthService _auth = new AuthService();
  String _value;
  List<String> _values = [
    'UMID',
    'Drivers License',
    'Senior Citizen ID',
    'Postal ID'
  ];
  //gallery and image//

  Map<String, String> imagePath = {'id': null, 'nbi': null, 'selfie': null};
  Map<String, PickedFile> imageFile = {'id': null, 'nbi': null, 'selfie': null};
  List<Asset> images = List<Asset>();
  bool isloading = false;

  // String imagePath;
  // PickedFile imageFile;
  ImagePicker _picker = new ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _value = _values.elementAt(0);
    // print('emtpy img:${imagePaths[0]['id']}');
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isloading,
      child: Scaffold(
        appBar: appBar('Application Form'),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: applyNowButton(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Container(
            width: getMediaQueryWidthViaDivision(context, 1),
            color: primaryColor,
            child: mainContainer()),
      ),
    );
  }

  Widget mainContainer() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            separator(20.0),
            buildSubLabelText(
                'Requirements', 14.0, Colors.grey, FontWeight.normal),
            separator(5),
            requirementsList(
                'Must provide a clear photo of \none valid government ID.',
                Icons.looks_one),
            separator(15),
            requirementsList('Must provide an NBI clearance.', Icons.looks_two),
            separator(15),
            requirementsList('Must provide one good selfie.', Icons.looks_3),
            separator(15),
            separator(10),
            Divider(
              thickness: 1.2,
            ),
            idValidationCard(),
            nbiValidationCard(),
            selfieValidationCard(),
            Divider(
              thickness: 1.2,
            ),
            buildSubLabelText('Skills', 14.0, Colors.grey, FontWeight.normal),
            separator(5),
            requirementsList(
                'Upload proof of your expertise \nsuch as certificates, licenses \nand badges.',
                Icons.looks_one),
            separator(10),
            photosContainer(),
            separator(20),
            separator(40),
          ],
        ),
      ),
    );
  }

  Widget requirementsList(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            icon,
            size: 15.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: buildLabelText(text, 12.0, Colors.black, FontWeight.normal),
          )
        ],
      ),
    );
  }

  Widget idValidationCard() {
    return InkWell(
      onTap: () {
        print('idvalidated');
        _showChoiceDialog('id');
      },
      child: Container(
        child: Card(
          shadowColor: Colors.greenAccent,
          color: imageFile['id'] == null ? Colors.white : Colors.greenAccent,
          elevation: 2.0,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    print('show picture');
                  },
                  child: imageFile['id'] == null
                      ? Container(
                          color: Colors.black,
                          height: 60,
                          width: 70,
                        )
                      : Container(
                          height: 60,
                          width: 70,
                          child: Image.file(
                            File(imagePath['id']),
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: buildLabelText('Upload government ID', 14.0,
                        Colors.black, FontWeight.normal),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 5.0),
                  //   child: buildSubLabelText(
                  //       'ID Type', 12.0, Colors.grey, FontWeight.normal),
                  // ),
                ],
              ),
              Expanded(
                  child: Icon(
                Icons.camera_alt,
                size: 25,
                color: Colors.black,
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget nbiValidationCard() {
    return InkWell(
      onTap: () {
        print('nbivalidated');
        _showChoiceDialog('nbi');
      },
      child: Container(
        child: Card(
          shadowColor: Colors.greenAccent,
          color: imageFile['nbi'] == null ? Colors.white : Colors.greenAccent,
          elevation: 2.0,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    print('show picture');
                  },
                  child: imageFile['nbi'] == null
                      ? Container(
                          color: Colors.black,
                          height: 60,
                          width: 70,
                        )
                      : Container(
                          height: 60,
                          width: 70,
                          child: Image.file(
                            File(imagePath['nbi']),
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: buildLabelText('Upload NBI Clearance', 14.0,
                    Colors.black, FontWeight.normal),
              ),
              Expanded(
                  child: Icon(
                Icons.camera_alt,
                size: 25,
                color: Colors.black,
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget selfieValidationCard() {
    return InkWell(
      onTap: () {
        print('selfieValidated');
        _showChoiceDialog('selfie');
      },
      child: Container(
        child: Card(
          shadowColor: Colors.greenAccent,
          color:
              imageFile['selfie'] == null ? Colors.white : Colors.greenAccent,
          elevation: 2.0,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    print('show picture');
                  },
                  child: imageFile['selfie'] == null
                      ? Container(
                          color: Colors.black,
                          height: 60,
                          width: 70,
                        )
                      : Container(
                          height: 60,
                          width: 70,
                          child: Image.file(
                            File(imagePath['selfie']),
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: buildLabelText('Upload a clean selfie  ', 14.0,
                    Colors.black, FontWeight.normal),
              ),
              Expanded(
                  child: Icon(
                Icons.camera_alt,
                size: 25,
                color: Colors.black,
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget applyNowButton() {
    return ButtonTheme(
      minWidth: getMediaQueryWidthViaDivision(context, 1),
      child: RaisedButton(
          onPressed: () async {
            //Firebase Storage
            if (imagePath['id'] == null ||
                imagePath['nbi'] == null ||
                imagePath['selfie'] == null) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      title: buildLabelText('Please upload some images!', 12.0,
                          primaryColor, FontWeight.normal),
                      actions: <Widget>[
                        FlatButton(
                            // ignore: missing_return
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            child: buildLabelText(
                                'Okay', 14.0, primaryColor, FontWeight.normal)),
                      ],
                    );
                  });
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      title: buildLabelText('Confirm submit?', 12.0,
                          primaryColor, FontWeight.normal),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: buildLabelText('Cancel', 14.0, Colors.black,
                                FontWeight.normal)),
                        FlatButton(
                            // ignore: missing_return
                            onPressed: () async {
                              Navigator.pop(context);
                              List<File> imgPaths = await getAbsolutePath();
                              uploadImage(imagePath);
                              await uploadSkillsImage(imgPaths, images);
                            },
                            child: buildLabelText('Confirm', 14.0, primaryColor,
                                FontWeight.normal)),
                      ],
                    );
                  });
            }
          },
          color: primaryColor,
          splashColor: secondaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: buildSubLabelText(
                'Submit requirements', 18.0, Colors.white, FontWeight.normal),
          )),
    );
  }

  Widget customDropDown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(
            color: Colors.greenAccent, style: BorderStyle.solid, width: 1.0),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
              value: _value,
              items: _values
                  .map((e) => new DropdownMenuItem(
                      value: e,
                      child: new Row(
                        children: <Widget>[
                          buildLabelText(
                              e, 14.0, Colors.black, FontWeight.normal),
                        ],
                      )))
                  .toList(),
              onChanged: (e) => _onChanged(e)),
        ),
      ),
    );
  }

  void _onChanged(String value) {
    setState(() {
      _value = value;
    });
  }

  _openCamera(String key) async {
    //async kay dugay mgpili og picture takes time to process kng unsa mapili
    var picture = await _picker.getImage(source: ImageSource.camera);
    this.setState(() {
      if (picture != null) {
        imageFile[key] = picture;
        imagePath[key] = imageFile[key].path;

        print('imagefile: $imageFile');
        print('imagePath: $imagePath');
      }
    });
    Navigator.of(context).pop();
  }

  _openGallery(String key) async {
    //async kay dugay mgpili og picture takes time to process kng unsa mapili
    var picture = await _picker.getImage(source: ImageSource.gallery);

    this.setState(() {
      if (picture != null) {
        imageFile[key] = picture;
        imagePath[key] = imageFile[key].path;
        print('imagefile: $imageFile');
        print('imagePath: $imagePath');
      }
    });
    Navigator.of(context).pop();
  }

  Future<void> _showChoiceDialog(String key) {
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
                      _openGallery(key);
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
                      _openCamera(key);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Future uploadImage(Map _imagePath) async {
    fb_auth.User user = await _auth.getCurrentUser();
    _imagePath.forEach((key, value) {
      String uid = user.uid;
      StorageReference ref =
          FirebaseStorage.instance.ref().child(uid).child('$key.jpg');
      ref.putFile(File(_imagePath[key]));
    });
    await DatabaseService(uid: user.uid)
        .updateUserProfileData('account', 'PENDING');
  }

  Widget photosContainer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
          onTap: () async {
            print('show gallery');
            loadAssets();
          },
          child: Container(
            height: getMediaQueryHeightViaDivision(context, 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey[400], width: 1),
            ),
            child: images.length > 0
                ? FutureBuilder(
                    builder: (context, snap) {
                      if (!snap.hasData) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 10),
                            buildLabelText('Add Photos', 14.0, Colors.grey,
                                FontWeight.normal)
                          ],
                        );
                      }
                      return Carousel(
                        boxFit: BoxFit.cover,
                        images: List.generate(snap.data.length, (index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.file(
                              snap.data[index],
                              fit: BoxFit.cover,
                            ),
                          );
                        }),
                        autoplay: false,
                        dotSize: 4.0,
                        indicatorBgPadding: 4.0,
                        dotBgColor: Colors.transparent,
                      );
                    },
                    future: getAbsolutePath(),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 10),
                      buildLabelText(
                          'Add Photos', 14.0, Colors.grey, FontWeight.normal)
                    ],
                  ),
          )),
    );
  }

  Future<List<File>> getAbsolutePath() async {
    List<File> files = [];
    for (int i = 0; i < images.length; i++) {
      final filePath =
          await FlutterAbsolutePath.getAbsolutePath(images[i].identifier);
      files.add(File(filePath));
    }
    return files;
  }

  Future loadAssets() async {
    List<Asset> resultList = List<Asset>();
    try {
      resultList = await MultiImagePicker.pickImages(
          maxImages: 20,
          enableCamera: true,
          selectedAssets: images,
          cupertinoOptions: CupertinoOptions(takePhotoIcon: 'chat'));
    } catch (e) {
      print(e);
    }
    if (!mounted) return;

    if (resultList.length > 0) {
      setState(() {
        images = resultList;
      });
    }

    print('image count: ${images.length}');
    // print('image asset: ${images.first.identifier}');
  }

  Future<List<String>> uploadSkillsImage(
      List<File> _imagePath, List<Asset> _imgAsset) async {
    List<String> urls = [];

    try {
      fb_auth.User user = await _auth.getCurrentUser();
      setState(() {
        this.isloading = true;
      });
      if (Platform.isAndroid) {
        for (int i = 0; i < _imagePath.length; i++) {
          Random random = new Random();
          String randomRef =
              '${DateTime.now().toIso8601String()}_${random.nextInt(10)}_${random.nextInt(100)}';
          StorageReference ref = FirebaseStorage.instance
              .ref()
              .child(user.uid)
              .child('skills')
              .child('$randomRef.jpg');
          StorageUploadTask uploadTask = ref.putFile(_imagePath[i]);

          String url = await (await uploadTask.onComplete).ref.getDownloadURL();
          urls.add(url);
        }
      } else {
        for (int i = 0; i < _imgAsset.length; i++) {
          Random random = new Random();
          ByteData byteData = await _imgAsset[i].getByteData();
          List<int> imageData = byteData.buffer.asUint8List();
          String randomRef =
              '${DateTime.now().toIso8601String()}_${random.nextInt(10)}_${random.nextInt(100)}';
          StorageReference ref = FirebaseStorage.instance
              .ref()
              .child(user.uid)
              .child('skills')
              .child('$randomRef.jpg');
          StorageUploadTask uploadTask = ref.putData(imageData);

          String url = await (await uploadTask.onComplete).ref.getDownloadURL();
          urls.add(url);
        }
      }
      Navigator.popUntil(context, (route) => route.isFirst);

      return urls;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
