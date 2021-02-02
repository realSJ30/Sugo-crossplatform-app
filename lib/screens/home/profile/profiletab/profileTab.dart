import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:sugoapp/screens/home/profile/cashout.dart';
import 'package:sugoapp/screens/home/profile/profiletab/editprofile.dart';
import 'package:sugoapp/screens/home/profile/topup.dart';
import 'package:sugoapp/services/auth.dart';
import 'package:sugoapp/services/profiledatabase.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';
import 'package:sugoapp/shared/string_extension.dart';

class ProfileTab extends StatefulWidget {
  final String uid;
  ProfileTab({@required this.uid});

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final AuthService _auth = AuthService();
  //gallery and image//

  String imagePath;
  PickedFile imageFile;
  // String imagePath;
  // PickedFile imageFile;
  ImagePicker _picker = new ImagePicker();

  //converts data to displayable data e.g names,birthdays
  String fullName(String first, String mid, String last) {
    print('okayss: $first');
    return "${first.capitalize()} ${mid[0].capitalize()}. ${last.capitalize()}";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSnap(context),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return loadingWidget();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            profilePic(snapshot.data['imgpath']),
            name(this.fullName(snapshot.data['firstname'],
                snapshot.data['middlename'], snapshot.data['lastname'])),
            gender(snapshot.data['gender']),
            contact(snapshot.data['contact'].toString().isEmpty
                ? 'Not set'
                : snapshot.data['contact']),
            email(snapshot.data['email'].toString().isEmpty
                ? 'Not set'
                : snapshot.data['email']),
            topUpContainer(double.parse(snapshot.data['credits'].toString())),
            if (snapshot.data['skills'] != null)
              skills(skills: snapshot.data['skills']),
            buttonEditProfile(callback: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => EditProfile(
                            snapshot: snapshot,
                            uid: widget.uid,
                          )));
            })
          ],
        );
      },
    );
  }

  Widget profilePic(String url) {
    return url.isNotEmpty
        ? InkWell(
            onTap: () {
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
                              viewProfilePic(url);
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
                                  buildLabelText('View Profile', 14.0,
                                      Colors.grey, FontWeight.normal)
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              _showChoiceDialog();
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
                                  buildLabelText('Upload Photo', 14.0,
                                      Colors.grey, FontWeight.normal)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            },
            child: Container(
              child: SizedBox(
                height: getMediaQueryHeightViaDivision(context, 4.5),
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
          )
        : Container(
            color: Colors.grey[200],
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.person,
                    size: getMediaQueryHeightViaDivision(context, 4.5),
                    color: Colors.grey[50],
                  ),
                  ButtonTheme(
                    child: RaisedButton(
                        onPressed: () async {
                          // ignore: unnecessary_statements
                          print('choose profile');
                          _showChoiceDialog();
                        },
                        color: Colors.grey[400],
                        splashColor: Colors.grey[600],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        child: buildLabelText('Choose profile', 12.0,
                            Colors.white, FontWeight.normal)),
                  ),
                ],
              ),
            ),
          );
  }

  Widget name(String name) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: buildLabelText(name, 24.0, Colors.black, FontWeight.bold),
      ),
    );
  }

  Widget gender(String gndr) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSubLabelText('Gender', 11.0, Colors.grey, FontWeight.normal),
          Row(
            children: [
              buildLabelText(gndr, 14.0, Colors.black, FontWeight.bold),
              Icon(
                gndr == 'Male' ? FontAwesome.male : FontAwesome.female,
                size: 15,
                color: gndr == 'Male' ? Colors.blue[200] : Colors.pink[200],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget contact(String contact) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSubLabelText('Contact', 11.0, Colors.grey, FontWeight.normal),
          buildLabelText(contact, 14.0, Colors.black, FontWeight.bold),
        ],
      ),
    );
  }

  Widget email(String email) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSubLabelText('Email', 11.0, Colors.grey, FontWeight.normal),
          buildLabelText(email, 14.0, Colors.black, FontWeight.bold),
        ],
      ),
    );
  }

  Widget skills({List<dynamic> skills}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSubLabelText('Skills', 11.0, Colors.grey, FontWeight.normal),
          Container(
            height: getMediaQueryHeightViaDivision(context, 21),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue[400],
                        borderRadius: BorderRadius.circular(6)),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: buildLabelText(
                          skills[index], 14, Colors.white, FontWeight.normal),
                    ),
                  ),
                );
              },
              itemCount: skills.length,
            ),
          )
        ],
      ),
    );
  }

  Widget topUpContainer(double credits) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 0.5, color: Colors.grey)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: buildSubLabelText('SUGO COINS', 18.0,
                        Colors.blue[900], FontWeight.normal),
                  ),
                  buildLabelText(
                      '$credits', 16.0, Colors.black, FontWeight.bold),
                  SizedBox(width: 20.0),
                  // if (Platform.isAndroid)
                  InkWell(
                    onTap: () {
                      print('top up');
                      showTopUp(credits);
                    },
                    child: buildSubLabelText(
                        'Top up', 16.0, Colors.blue, FontWeight.normal),
                  ),
                  SizedBox(width: 10.0),
                  InkWell(
                    onTap: () {
                      print('cash out');
                      showCashOut(credits);
                    },
                    child: buildSubLabelText(
                        'Cash out', 16.0, Colors.grey, FontWeight.normal),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonEditProfile({VoidCallback callback}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              child: ButtonTheme(
            child: RaisedButton(
                onPressed: callback,
                color: primaryColor,
                splashColor: secondaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                child: buildLabelText(
                    'Edit Profile', 14.0, Colors.white, FontWeight.normal)),
          ))
        ],
      ),
    );
  }

  Future getSnap(BuildContext context) async {
    final userprofile = Provider.of<DocumentSnapshot>(context);
    print('USERPROFILE ${userprofile.data()['credits']}');
    return userprofile.data();
  }

  void showTopUp(double oldvalue) {
    showBarModalBottomSheet(
        context: context,
        builder: (context, scrollControl) {
          return TopUp(
            oldvalue: oldvalue,
          );
        });
  }

  void showCashOut(double value) {
    showBarModalBottomSheet(
        context: context,
        builder: (context, scrollControl) {
          return CashOut(
            sugoCoins: value,
            uid: widget.uid,
          );
        });
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
        uploadImage(imagePath);
      }
    });
    Navigator.of(context).pop();
  }

  _openGallery() async {
    //async kay dugay mgpili og picture takes time to process kng unsa mapili
    var picture = await _picker.getImage(source: ImageSource.gallery);

    this.setState(() {
      if (picture != null) {
        imageFile = picture;
        imagePath = imageFile.path;
        uploadImage(imagePath);
      }
    });

    Navigator.of(context).pop();
  }

  Future uploadImage(String _imagePath) async {
    fb_auth.User user = await _auth.getCurrentUser();
    String uid = user.uid;
    StorageReference ref =
        FirebaseStorage.instance.ref().child(uid).child('profilepicture.jpg');
    StorageUploadTask uploadTask = ref.putFile(File(_imagePath));

    String url = await (await uploadTask.onComplete).ref.getDownloadURL();
    print(url);
    await ProfileDatabase(uid: user.uid)
        .updateUserData(field: 'imgpath', data: url);
  }

  void viewProfilePic(String url) {
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
