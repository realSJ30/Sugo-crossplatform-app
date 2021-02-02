import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sugoapp/models/posts.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:sugoapp/services/auth.dart';
import 'package:sugoapp/services/profiledatabase.dart';
import 'package:sugoapp/services/servicesdatabase.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';

class FRequestTile extends StatefulWidget {
  final Post post;
  final String uid;
  FRequestTile({this.post, this.uid});

  @override
  _FRequestTileState createState() => _FRequestTileState();
}

class _FRequestTileState extends State<FRequestTile> {
  final AuthService _auth = new AuthService();
  bool isAccepted = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfAcceptedOrNot();
  }

  @override
  Widget build(BuildContext context) {
    return widget.post.userid != widget.uid &&
            widget.post.status == 'posted' &&
            isAccepted
        ? InkWell(
            onTap: () {
              showWorkDialog();
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.work,
                      color: primaryColor,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        buildLabelText(widget.post.tags, 18.0, Colors.black,
                            FontWeight.normal),
                        buildLabelText(widget.post.postedDate, 12.0,
                            Colors.grey, FontWeight.normal),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : Container();
  }

  checkIfAcceptedOrNot() async {
    try {
      fb_auth.User user = await _auth.getCurrentUser();

      await ProfileDatabase(uid: user.uid)
          .checkIfAlreadyAccepted(widget.post.postID)
          .then((value) => this.setState(() {
                isAccepted = value;
              }));
    } catch (e) {
      print(e.toString());
      this.setState(() {
        isAccepted = false;
      });
    }
  }

  void showWorkDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: buildLabelText(
                'Confirm action', 12.0, primaryColor, FontWeight.normal),
            content: buildLabelText(
                "Accept the job?", 12.0, Colors.grey, FontWeight.normal),
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
                    print('working the errand');
                    await ServicesDatabase(postid: widget.post.postID)
                        .verifyAndWorkErrandRequest(widget.uid);
                    Navigator.pop(context);
                  },
                  child: buildLabelText(
                      'Confirm', 14.0, primaryColor, FontWeight.normal)),
            ],
          );
        });
  }
}
