import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:sugoapp/services/auth.dart';
import 'package:sugoapp/services/profiledatabase.dart';
import 'package:sugoapp/services/servicesdatabase.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class SubmitReqErrand extends StatefulWidget {
  final String tags;
  final String notes;
  final String fee;
  final String paymenttype;
  final String address1;
  final String latlng;
  final List<File> imgPath;
  final List<Asset> imgAsset;
  SubmitReqErrand(
      {this.tags,
      this.notes,
      this.fee,
      this.paymenttype,
      this.address1,
      this.latlng,
      this.imgPath,
      this.imgAsset});
  @override
  _SubmitReqErrandState createState() => _SubmitReqErrandState();
}

class _SubmitReqErrandState extends State<SubmitReqErrand> {
  TextEditingController _address2Controller = new TextEditingController();
  AuthService _auth = new AuthService();
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LoadingOverlay(
        isLoading: isloading,
        child: Scaffold(
          appBar: appBar('Post Errand'),
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    buildSubLabelText('Request Information', 18.0, Colors.grey,
                        FontWeight.normal)
                  ],
                ),
              ),
              addressContainer('Address', widget.address1),
              address2Container('Specific Address'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    buildSubLabelText(
                        'Description', 18.0, Colors.grey, FontWeight.normal)
                  ],
                ),
              ),
              Divider(),
              notesContainer()
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: bottomActionBar(),
        ),
      ),
    );
  }

  Widget bottomActionBar() {
    return Container(
      height: getMediaQueryHeightViaDivision(context, 4.5),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black, blurRadius: 1.5, spreadRadius: 0.0)
        ],
        color: Colors.white,
      ),
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ListTile(
                title: buildSubLabelText(
                    'Service fee', 16.0, Colors.grey, FontWeight.normal),
                subtitle: Row(
                  children: [
                    buildSubLabelText(
                        widget.fee, 30, Colors.black, FontWeight.normal),
                    buildSubLabelText(
                        'PHP', 14, Colors.black, FontWeight.normal),
                    Expanded(
                      child: Container(),
                    ),
                    buildLabelText(
                        widget.paymenttype, 14, Colors.black, FontWeight.bold)
                  ],
                ),
              )),
          postErrandButton()
        ],
      ),
    );
  }

  Widget postErrandButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: ButtonTheme(
              height: 50.0,
              child: RaisedButton(
                  onPressed: () async {
                    fb_auth.User user = await _auth.getCurrentUser();
                    // ignore: unnecessary_statements
                    print('submit');
                    if (_address2Controller.text.isEmpty) {
                      showDialog(
                          context: context,
                          builder: (dialogcontext) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              content: buildLabelText(
                                  "You haven't fill up Address 2",
                                  16.0,
                                  Colors.grey,
                                  FontWeight.normal),
                              actions: <Widget>[
                                FlatButton(
                                    onPressed: () {
                                      Navigator.pop(dialogcontext);
                                    },
                                    child: buildLabelText('Cancel', 14.0,
                                        Colors.black, FontWeight.normal)),
                                FlatButton(
                                    // ignore: missing_return
                                    onPressed: () async {
                                      Navigator.pop(dialogcontext);
                                      if (widget.fee == 'SUGO Coins') {
                                        double credits =
                                            await ProfileDatabase(uid: user.uid)
                                                .getCredits();
                                        //minus coins
                                        await ProfileDatabase(uid: user.uid)
                                            .minusCredits(
                                                minusvalue:
                                                    double.parse(widget.fee),
                                                oldvalue: credits);
                                      }
                                      List<String> urls = await uploadImage(
                                          widget.imgPath, widget.imgAsset);

                                      //insert data to cloud
                                      await ServicesDatabase(uid: user.uid)
                                          .postRequest(
                                              userid: user.uid,
                                              tags: widget.tags,
                                              notes: widget.notes,
                                              fee: widget.fee,
                                              paymentType: widget.paymenttype,
                                              address1: widget.address1,
                                              address2:
                                                  _address2Controller.text,
                                              latlng: widget.latlng,
                                              date: dateTime(),
                                              status: 'posted',
                                              urls: urls)
                                          .whenComplete(() =>
                                              Navigator.popUntil(this.context,
                                                  (route) => route.isFirst));
                                    },
                                    child: buildLabelText('Proceed anyway',
                                        14.0, primaryColor, FontWeight.normal)),
                              ],
                            );
                          });
                    } else {
                      //insert data to cloud
                      if (widget.paymenttype == 'SUGO Coins') {
                        double credits =
                            await ProfileDatabase(uid: user.uid).getCredits();
                        //minus coins
                        await ProfileDatabase(uid: user.uid).minusCredits(
                            minusvalue: double.parse(widget.fee),
                            oldvalue: credits);
                      }
                      List<String> urls =
                          await uploadImage(widget.imgPath, widget.imgAsset);

                      await ServicesDatabase(uid: user.uid)
                          .postRequest(
                              userid: user.uid,
                              tags: widget.tags,
                              notes: widget.notes,
                              fee: widget.fee,
                              paymentType: widget.paymenttype,
                              address1: widget.address1,
                              address2: _address2Controller.text,
                              latlng: widget.latlng,
                              date: dateTime(),
                              status: 'posted',
                              urls: urls)
                          .whenComplete(() => Navigator.popUntil(
                              this.context, (route) => route.isFirst));
                    }
                    print('assets = >${widget.imgAsset.length}');
                  },
                  color: primaryColor,
                  splashColor: secondaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  child: buildLabelText(
                      'Post', 18.0, Colors.white, FontWeight.normal)),
            ),
          ),
        ],
      ),
    );
  }

  Widget notesContainer() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        child:
            buildLabelText(widget.notes, 18.0, Colors.black, FontWeight.normal),
      ),
    );
  }

  Widget addressContainer(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.grey, width: 1.0)),
        child: ListTile(
          leading: Icon(Icons.home, color: Colors.grey, size: 35),
          title: buildSubLabelText(title, 16.0, Colors.grey, FontWeight.normal),
          subtitle:
              buildLabelText(subtitle, 16.0, Colors.black, FontWeight.bold),
        ),
      ),
    );
  }

  Widget address2Container(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.grey, width: 1.0)),
          child: ListTile(
            leading: Icon(Icons.home, color: Colors.grey, size: 35),
            title:
                buildSubLabelText(title, 16.0, Colors.grey, FontWeight.normal),
            subtitle: TextFormField(
              maxLines: null,
              controller: _address2Controller,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add specific address...'),
            ),
          )),
    );
  }

  //uploads image to firebase storage then gets list of urls
  Future<List<String>> uploadImage(
      List<File> _imagePath, List<Asset> _imgAsset) async {
    List<String> urls = [];
    this.setState(() {
      this.isloading = true;
    });

    try {
      fb_auth.User user = await _auth.getCurrentUser();

      if (Platform.isAndroid) {
        for (int i = 0; i < _imagePath.length; i++) {
          Random random = new Random();
          String randomRef =
              '${DateTime.now().toIso8601String()}_${random.nextInt(10)}_${random.nextInt(100)}';
          StorageReference ref = FirebaseStorage.instance
              .ref()
              .child(user.uid)
              .child('posts')
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
              .child('posts')
              .child('$randomRef.jpg');
          StorageUploadTask uploadTask = ref.putData(imageData);

          String url = await (await uploadTask.onComplete).ref.getDownloadURL();
          urls.add(url);
        }
      }
      return urls;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
