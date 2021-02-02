import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:sugoapp/models/msg.dart';
import 'package:sugoapp/models/posts.dart';
import 'package:sugoapp/screens/home/communication/convolist.dart';
import 'package:sugoapp/screens/home/errand%20details.dart/details.dart';
import 'package:sugoapp/screens/home/services/current/ongoing/reportmodal.dart';
import 'package:sugoapp/services/auth.dart';
import 'package:sugoapp/services/chatdatabase.dart';
import 'package:sugoapp/services/database.dart';
import 'package:sugoapp/services/profiledatabase.dart';
import 'package:sugoapp/services/pushnotifications.dart';
import 'package:sugoapp/services/servicesdatabase.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:url_launcher/url_launcher.dart';

class Convo extends StatefulWidget {
  final Post post;
  final String displayname;
  final String contact;
  final String usertype;
  final String postID;
  final String myUID;
  final String status;
  final String toUID;
  Convo(
      {this.toUID,
      this.post,
      this.myUID,
      this.postID,
      this.status,
      this.displayname,
      this.contact,
      this.usertype});
  @override
  _ConvoState createState() => _ConvoState();
}

class _ConvoState extends State<Convo> {
  AuthService _auth = new AuthService();
  TextEditingController _messageController = new TextEditingController();
  ScrollController scrollController = new ScrollController();
  String _status = '';
  //gallery and image//

  String imagePath;
  PickedFile imageFile;
  ImagePicker _picker = new ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.post == null) {
      this.setState(() {
        this._status = widget.status;
      });
    } else {
      this.setState(() {
        this._status = widget.post.status;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('status: ${widget.status}');
    var posted = widget.post == null ? Provider.of<Post>(context) : widget.post;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildLabelText(
                  widget.displayname, 16.0, Colors.white, FontWeight.bold),
              buildSubLabelText(
                  widget.usertype, 14.0, Colors.white60, FontWeight.normal),
            ],
          ),
          elevation: 0.1,
          actions: widget.status != 'finished' && widget.status != 'cancelled'
              ? <Widget>[
                  PopupMenuButton<String>(onSelected: (value) async {
                    switch (value) {
                      case 'Details':
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => Details(
                                      post: widget.post == null
                                          ? posted
                                          : widget.post,
                                    )));
                        break;
                      case 'Call':
                        await launch('tel: ${widget.contact}');
                        break;
                      case 'Report':
                        showREPORTDIALOG(posted);
                        break;
                      case 'Cancel':
                        if (widget.usertype == 'Client') {
                          _showConfirmCancelDialog(posted);
                        } else {
                          showCancelDialog();
                        }

                        break;
                      case 'Finish':
                        _showConfirmFinishDialog(context, posted);
                        break;
                    }
                  }, itemBuilder: (context) {
                    List<String> choices = [
                      'Details',
                      'Call',
                      'Report',
                      'Cancel',
                      'Finish'
                    ];
                    return choices.map((e) {
                      IconData iconData;
                      switch (e) {
                        case 'Details':
                          iconData = Icons.notes;
                          break;
                        case 'Call':
                          iconData = Icons.call;
                          break;
                        case 'Report':
                          iconData = Icons.report_problem;
                          break;
                        case 'Cancel':
                          iconData = Icons.close;
                          break;
                        case 'Finish':
                          iconData = Icons.check;
                          break;
                      }
                      return e == 'Finish'
                          ? widget.usertype == 'Client'
                              ? PopupMenuItem<String>(
                                  value: e,
                                  child: Container(
                                    width: getMediaQueryWidthViaDivision(
                                        context, 4.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          iconData,
                                          color: e == 'Cancel'
                                              ? Colors.red
                                              : Colors.grey,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        buildLabelText(
                                            e,
                                            14.0,
                                            e == 'Cancel'
                                                ? Colors.red
                                                : Colors.grey,
                                            FontWeight.normal),
                                      ],
                                    ),
                                  ))
                              : null
                          : PopupMenuItem<String>(
                              value: e,
                              child: Container(
                                width:
                                    getMediaQueryWidthViaDivision(context, 4.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      iconData,
                                      color: e == 'Cancel'
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    buildLabelText(
                                        e,
                                        14.0,
                                        e == 'Cancel'
                                            ? Colors.red
                                            : Colors.grey,
                                        FontWeight.normal),
                                  ],
                                ),
                              ));
                    }).toList();
                  })
                ]
              : null,
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  child: Container(
                color: Colors.grey[100],
                child: StreamProvider<List<Msg>>.value(
                  value: ChatDatabase(
                          errandID: widget.post == null
                              ? widget.postID
                              : widget.post.postID)
                      .msgs,
                  child: ConvoList(
                      myUID: widget.myUID,
                      scrollController: scrollController,
                      postID: widget.postID),
                ),
              )),
              this._status == 'on going' ? textField(posted) : passiveField()
            ],
          ),
        ),
      ),
    );
  }

  Widget passiveField() {
    return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Row(
            children: [
              Expanded(
                child: buildLabelText(
                  'You can no longer reply to this \nconversation.',
                  14.0,
                  Colors.grey,
                  FontWeight.normal,
                ),
              ),
              InkWell(
                onTap: () {
                  print('show information');
                  showInformationDialog();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: buildLabelText(
                    'Info',
                    14.0,
                    Colors.blue,
                    FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget textField(Post post) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.blueGrey, blurRadius: 0.5, spreadRadius: 0.0)
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: Row(
            children: <Widget>[
              sendPhotoButton(post),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 4.0, bottom: 4.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'Write a message...'),
                  maxLines: null,
                  controller: _messageController,
                ),
              )),
              sendButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget sendButton() {
    return IconButton(
      icon: Icon(
        Icons.send,
        color: primaryColor,
        size: 25,
      ),
      splashColor: Colors.blue,
      onPressed: () async {
        fb_auth.User user = await _auth.getCurrentUser();
        var poststatus =
            await ServicesDatabase(postid: widget.postID).getPostStatus();
        if (poststatus == 'on going') {
          String msg = _messageController.text;
          if (_messageController.text.length > 0) {
            _messageController.clear();
            List<DocumentSnapshot> tokens =
                await ProfileDatabase(uid: widget.toUID).getProfileToken();
            String fromName =
                await ProfileDatabase(uid: widget.myUID).getProfileName();
            await ChatDatabase(errandID: widget.postID).sendMessage(
              createdAt: dateTime(),
              from: user.uid,
              msg: msg,
            );
            String notifmsg = msg.length > 20 ? msg.substring(0, 20) : msg;
            // print('token: ${tokens[0].data()}');
            await PushNotifications().sendPushMessageChatMessage(
                receiverToken: tokens[0].id.toString(),
                from: fromName,
                msg: notifmsg);
            // updateChatView();
          }
        } else {
          showInformationDialog();
        }
      },
    );
  }

  Widget sendPhotoButton(Post post) {
    return IconButton(
      icon: Icon(
        Icons.image,
        color: primaryColor,
        size: 30,
      ),
      splashColor: Colors.blue,
      onPressed: () async {
        var poststatus =
            await ServicesDatabase(postid: widget.postID).getPostStatus();
        if (poststatus == 'on going') {
          _showChoiceDialog(post);
        } else {
          showInformationDialog();
        }
      },
    );
  }

  void updateChatView() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  void showInformationDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: buildLabelText(
                  'Information', 14.0, Colors.black, FontWeight.normal),
              content: buildLabelText(
                  'The errand is either finished or has been cancelled.',
                  14.0,
                  Colors.grey,
                  FontWeight.normal),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: buildLabelText(
                        'Confirm', 14.0, Colors.black, FontWeight.normal)),
              ],
            ));
  }

  _showConfirmFinishDialog(BuildContext context, Post _post) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: buildLabelText(
                'Confirm action', 12.0, primaryColor, FontWeight.normal),
            content: buildLabelText("Make sure you have received the payment",
                12.0, Colors.grey, FontWeight.normal),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: buildLabelText(
                      'Cancel', 14.0, Colors.black, FontWeight.normal)),
              FlatButton(
                  // ignore: missing_return
                  onPressed: () async {
                    fb_auth.User user = await _auth.getCurrentUser();
                    await ServicesDatabase(postid: _post.postID)
                        .updatePostedErrandStatus(status: 'finished');
                    await DatabaseService().addCommissions(
                        postid: _post.postID,
                        commissionsfee: double.parse(_post.fee));
                    List<DocumentSnapshot> tokens =
                        await ProfileDatabase(uid: _post.userid)
                            .getProfileToken();
                    String freelancerName =
                        await ProfileDatabase(uid: user.uid).getProfileName();
                    print('token: ${tokens.length}');
                    await PushNotifications().sendPushMessageErrandFinished(
                        receiverToken: tokens[0].id.toString(),
                        errand: _post.tags,
                        name: freelancerName,
                        postid: _post.postID,
                        freelancerUID: user.uid);
                    await ProfileDatabase(uid: user.uid)
                        .addToMyfinishedErrands(postid: _post.postID);

                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: buildLabelText(
                      'Confirm', 14.0, primaryColor, FontWeight.normal)),
            ],
          );
        });
  }

  void showREPORTDIALOG(Post _post) async {
    //detect if ang ireport is client or freelancer
    fb_auth.User user = await _auth.getCurrentUser();
    String freelancerID = await ServicesDatabase(postid: widget.postID)
        .getFreelancerUIDfromRequests();
    String reportedUID = '';
    if (_post.userid == user.uid) {
      //client ko
      reportedUID = freelancerID;
    } else {
      //freelancer ko
      reportedUID = _post.userid;
    }

    showMaterialModalBottomSheet(
        context: context,
        builder: (context, scrollcontroller) => ReportModal(
              userID: reportedUID,
              postID: widget.postID,
            ));
  }

  //if FREELANCER mag cancel
  _showConfirmCancelDialog(Post _post) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: buildLabelText(
                'Confirm action', 12.0, primaryColor, FontWeight.normal),
            content: buildLabelText("Are you sure you want to cancel errand?",
                12.0, Colors.grey, FontWeight.normal),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: buildLabelText(
                      'Cancel', 14.0, Colors.black, FontWeight.normal)),
              FlatButton(
                  // ignore: missing_return
                  onPressed: () async {
                    await ServicesDatabase(postid: _post.postID)
                        .updatePostedErrandStatus(status: 'cancelled');
                    await DatabaseService().addCommissions(
                        postid: _post.postID,
                        commissionsfee: double.parse(_post.fee));
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: buildLabelText(
                      'Confirm', 14.0, primaryColor, FontWeight.normal)),
            ],
          );
        });
  }

  //if CLIENT mag cancel
  void showCancelDialog() async {
    var poststatus =
        await ServicesDatabase(postid: widget.postID).getPostStatus();
    if (poststatus == 'on going') {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: buildLabelText('Send cancellation request', 14.0,
                  Colors.black, FontWeight.normal),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: buildLabelText(
                        'Cancel', 14.0, Colors.grey, FontWeight.normal)),
                FlatButton(
                    onPressed: () async {
                      fb_auth.User user = await _auth.getCurrentUser();

                      await ChatDatabase(errandID: widget.postID).sendMessage(
                        createdAt: dateTime(),
                        from: user.uid,
                        msg: 'REQUEST CANCEL ERRAND',
                      );
                      Navigator.pop(context);
                    },
                    child: buildLabelText(
                        'Confirm', 14.0, Colors.black, FontWeight.normal)),
              ],
            );
          });
    } else {
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  Future<void> _showChoiceDialog(Post post) {
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
                      _openGallery(post);
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
                      _openCamera(post);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  _openCamera(Post post) async {
    //async kay dugay mgpili og picture takes time to process kng unsa mapili
    var picture = await _picker.getImage(source: ImageSource.camera);
    this.setState(() {
      if (picture != null) {
        imageFile = picture;
        imagePath = imageFile.path;
        uploadImage(imagePath, post);
      }
    });
    Navigator.of(context).pop();
  }

  _openGallery(Post post) async {
    //async kay dugay mgpili og picture takes time to process kng unsa mapili
    var picture = await _picker.getImage(source: ImageSource.gallery);

    this.setState(() {
      if (picture != null) {
        imageFile = picture;
        imagePath = imageFile.path;
        uploadImage(imagePath, post);
      }
    });

    Navigator.of(context).pop();
  }

  Future uploadImage(String _imagePath, Post post) async {
    fb_auth.User user = await _auth.getCurrentUser();

    String uid = user.uid;
    Random random = new Random();
    String randomRef =
        '${DateTime.now().toIso8601String()}_${random.nextInt(10)}_${random.nextInt(100)}';
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child('chats')
        .child(post.postID)
        .child('$randomRef.jpg');
    StorageUploadTask uploadTask = ref.putFile(File(_imagePath));

    String url = await (await uploadTask.onComplete).ref.getDownloadURL();
    print(url);
    await ChatDatabase(errandID: widget.postID).sendMessage(
        createdAt: dateTime(), from: user.uid, msg: 'Sent a photo', url: url);
    // await ProfileDatabase(uid: user.uid)
    //     .updateUserData(field: 'imgpath', data: url);
  }
}
