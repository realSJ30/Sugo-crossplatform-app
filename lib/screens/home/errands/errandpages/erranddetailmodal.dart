import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sugoapp/models/posts.dart';
import 'package:sugoapp/screens/home/communication/convo.dart';
import 'package:sugoapp/screens/home/services/current/ongoing/reportmodal.dart';
import 'package:sugoapp/services/database.dart';
import 'package:sugoapp/services/profiledatabase.dart';
import 'package:sugoapp/services/pushnotifications.dart';
import 'package:sugoapp/services/servicesdatabase.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:sugoapp/services/auth.dart';
import 'package:sugoapp/services/chatdatabase.dart';

class ErrandDetailModal extends StatelessWidget {
  final Post post;
  AuthService _auth = new AuthService();
  ErrandDetailModal({this.post});

  @override
  Widget build(BuildContext context) {
    return actionsPanel(context);
  }

  Widget actionsPanel(BuildContext context) {
    return Container(
        height: getMediaQueryHeightViaDivision(context, 2.8),
        child: Column(
          children: [
            modalOptionsButtons(
                icon: Icons.chat_bubble,
                title: 'Message',
                callback: () async {
                  fb_auth.User user = await _auth.getCurrentUser();
                  String displayName =
                      await ProfileDatabase(uid: post.userid).getProfileName();
                  String contact = await ProfileDatabase(uid: post.userid)
                      .getProfileContact();
                  await ChatDatabase(errandID: post.postID)
                      .createChatRoom(
                        clientUID: post.userid,
                        freelancerUID: user.uid,
                        createdAt: dateTime(),
                      )
                      .whenComplete(() => Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => Convo(
                                    toUID: post.userid,
                                    contact: contact,
                                    displayname: displayName,
                                    postID: post.postID,
                                    status: post.status,
                                    usertype: 'Client',
                                    post: post,
                                    myUID: user.uid,
                                  ))));
                }),
            modalOptionsButtons(
                icon: Icons.report,
                title: 'Report',
                callback: () {
                  print('show report');
                  showREPORTDIALOG(context);
                }),
            modalOptionsButtons(
                icon: Icons.cancel,
                title: 'Cancel',
                callback: () {
                  print('show cancel');
                  _showConfirmCancelDialog(context);
                }),
            modalOptionsButtons(
                icon: Icons.check,
                title: 'Finish',
                callback: () {
                  print('show finish');
                  _showConfirmFinishDialog(context);
                }),
          ],
        ));
  }

  void showREPORTDIALOG(BuildContext context) async {
    // String freelancerID = await ServicesDatabase(postid: post.postID)
    //     .getFreelancerUIDfromRequests();
    showMaterialModalBottomSheet(
        context: context,
        builder: (context, scrollcontroller) => ReportModal(
              userID: post.userid,
              postID: post.postID,
            ));
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
              color: title == 'Finish' ? Colors.green : Colors.grey,
            ),
            SizedBox(
              width: 15.0,
            ),
            buildLabelText(
                title,
                14.0,
                title == 'Finish' ? Colors.green : Colors.grey,
                FontWeight.normal)
          ],
        ),
      ),
    );
  }

  _showConfirmFinishDialog(BuildContext context) {
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
                    await ServicesDatabase(postid: post.postID)
                        .updatePostedErrandStatus(status: 'finished');
                    await DatabaseService(uid: user.uid).addCommissions(
                        postid: post.postID,
                        commissionsfee: double.parse(post.fee));
                    List<DocumentSnapshot> tokens =
                        await ProfileDatabase(uid: post.userid)
                            .getProfileToken();
                    String freelancerName =
                        await ProfileDatabase(uid: user.uid).getProfileName();
                    print('token: ${tokens[0].id.toString()}');
                    await PushNotifications().sendPushMessageErrandFinished(
                        receiverToken: tokens[0].id.toString(),
                        errand: post.tags,
                        name: freelancerName,
                        postid: post.postID,
                        freelancerUID: user.uid);
                    await ProfileDatabase(uid: user.uid)
                        .addToMyfinishedErrands(postid: post.postID);

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

  _showConfirmCancelDialog(BuildContext context) {
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
                    fb_auth.User user = await _auth.getCurrentUser();
                    await ServicesDatabase(postid: post.postID)
                        .updatePostedErrandStatus(status: 'cancelled');
                    await DatabaseService(uid: user.uid).addCommissions(
                        postid: post.postID,
                        commissionsfee: double.parse(post.fee));
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: buildLabelText(
                      'Confirm', 14.0, primaryColor, FontWeight.normal)),
            ],
          );
        });
  }
}
