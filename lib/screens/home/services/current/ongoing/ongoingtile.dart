import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sugoapp/models/posts.dart';
import 'package:sugoapp/screens/home/communication/convo.dart';
import 'package:sugoapp/screens/home/errand%20details.dart/details.dart';
import 'package:sugoapp/screens/home/services/current/ongoing/reportmodal.dart';
import 'package:sugoapp/services/auth.dart';
import 'package:sugoapp/services/chatdatabase.dart';
import 'package:sugoapp/services/profiledatabase.dart';
import 'package:sugoapp/services/servicesdatabase.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class OnGoingTile extends StatefulWidget {
  final Post post;
  final String uid;

  OnGoingTile({this.post, this.uid});

  @override
  _OnGoingTileState createState() => _OnGoingTileState();
}

class _OnGoingTileState extends State<OnGoingTile> {
  final AuthService _auth = new AuthService();

  @override
  Widget build(BuildContext context) {
    return widget.post.userid == widget.uid && widget.post.status == 'on going'
        ? InkWell(
            onTap: () async {
              fb_auth.User user = await _auth.getCurrentUser();
              String displayname =
                  await ServicesDatabase(postid: widget.post.postID)
                      .getAcceptedFreelancerProfile();
              String contact =
                  await ServicesDatabase(postid: widget.post.postID)
                      .getAcceptedFreelancerContact();
              String toUID = await ServicesDatabase(postid: widget.post.postID)
                  .getFreelancerUIDfromRequests();
              await ChatDatabase(errandID: widget.post.postID)
                  .createChatRoom(
                    clientUID: user.uid,
                    freelancerUID:
                        await ServicesDatabase(postid: widget.post.postID)
                            .getFreelancerUIDfromRequests(),
                    createdAt: dateTime(),
                  )
                  .whenComplete(() => Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => Convo(
                                toUID: toUID,
                                contact: contact,
                                post: widget.post,
                                myUID: user.uid,
                                postID: widget.post.postID,
                                displayname: displayname,
                                usertype: 'Freelancer',
                                status: widget.post.status,
                              ))));
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: primaryColor, width: 0.4))),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.work,
                            color: primaryColor,
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    buildLabelText(widget.post.tags, 18.0,
                                        Colors.black, FontWeight.normal),
                                    buildLabelText(widget.post.postedDate, 12.0,
                                        Colors.grey, FontWeight.normal),
                                  ],
                                ),
                              ),
                              // moreOptions()
                            ],
                          ),
                          // subtitle: bottombar(),
                        ),
                      ],
                    )),
              ),
            ),
          )
        : Container();
  }

  Widget modalOptionsButtons(
      {String title, IconData icon, VoidCallback callback}) {
    return InkWell(
      onTap: callback,
      child: ListTile(
        title: Row(
          children: [
            Icon(
              icon,
              size: 20.0,
              color: Colors.grey,
            ),
            SizedBox(
              width: 15.0,
            ),
            buildLabelText(title, 14.0, Colors.grey, FontWeight.normal)
          ],
        ),
      ),
    );
  }

  Widget moreOptions() {
    return ButtonTheme(
      height: 30,
      child: RaisedButton(
          elevation: 0,
          onPressed: () async {
            // ignore: unnecessary_statements
            print('view');

            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => Details(
                          post: widget.post,
                        )));
          },
          color: Colors.blue,
          splashColor: secondaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          child: buildSubLabelText(
              'Details', 14.0, Colors.white, FontWeight.normal)),
    );
  }

  Widget freelancerName() {
    try {
      return FutureBuilder(
        builder: (context, snap) {
          if (!snap.hasData) {
            return buildLabelText(
                '     ', 12, Colors.black87, FontWeight.normal);
          }
          print(snap.data);
          return buildLabelText(
              snap.data, 12, Colors.black87, FontWeight.normal);
        },
        future: ServicesDatabase(postid: widget.post.postID)
            .getAcceptedFreelancerProfile(),
      );
    } catch (e) {
      return Text('error');
    }
  }
}
