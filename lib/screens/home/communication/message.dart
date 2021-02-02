import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugoapp/models/msg.dart';
import 'package:sugoapp/models/posts.dart';
import 'package:sugoapp/screens/home/communication/convo.dart';
import 'package:sugoapp/services/auth.dart';
import 'package:sugoapp/services/chatdatabase.dart';
import 'package:sugoapp/services/profiledatabase.dart';
import 'package:sugoapp/services/servicesdatabase.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class MessageTile extends StatefulWidget {
  final String uid;
  final ChatInbox chatInbox;

  MessageTile({this.chatInbox, this.uid});
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<MessageTile> {
  AuthService _auth = new AuthService();
  bool me = false;
  String chatFromUID;
  String chatFromDisplayName = '';
  String contact = '';
  String userType = '';
  String errand = '';
  String myID = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfChatbelongsToMe();
    getMessageFrom();
  }

  @override
  Widget build(BuildContext context) {
    List<Msg> msg = Provider.of<List<Msg>>(context) ?? [];

    int unreadMessages() {
      int count = 0;
      for (int i = 0; i < msg.length; i++) {
        if (!msg[i].isRead && msg[i].from != widget.uid) {
          count++;
        }
      }
      return count;
    }

    return me
        ? InkWell(
            onTap: () async {
              fb_auth.User user = await _auth.getCurrentUser();
              String status =
                  await ServicesDatabase(postid: widget.chatInbox.errandID)
                      .getPostStatus();
              print(widget.chatInbox.errandID);
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => StreamProvider<Post>.value(
                            value: ServicesDatabase(
                                    postid: widget.chatInbox.errandID)
                                .posted,
                            child: Convo(
                              toUID: this.chatFromUID,
                              contact: this.contact,
                              displayname: this.chatFromDisplayName,
                              usertype: this.userType,
                              myUID: user.uid,
                              postID: widget.chatInbox.errandID,
                              status: status,
                            ),
                          )));
              await ChatDatabase(errandID: widget.chatInbox.errandID)
                  .updateMessageRead(uid: widget.uid);
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: unreadMessages() > 0
                  ? Badge(
                      animationDuration: Duration(milliseconds: 100),
                      elevation: 1,
                      badgeColor: primaryColor,
                      toAnimate: true,
                      animationType: BadgeAnimationType.scale,
                      padding: const EdgeInsets.all(10),
                      shape: BadgeShape.circle,
                      badgeContent: buildLabelText('${unreadMessages()}', 15.0,
                          Colors.white, FontWeight.normal),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 0.4, color: Colors.blue[100])),
                            color: Colors.white,
                          ),
                          child: ListTile(
                            title: buildLabelText(this.chatFromDisplayName,
                                16.0, Colors.blue, FontWeight.bold),
                            subtitle: StreamProvider.value(
                              value: ChatDatabase(
                                      errandID: widget.chatInbox.errandID)
                                  .msgs,
                              child: Builder(builder: (context) {
                                var snapshot = Provider.of<List<Msg>>(context);
                                if (snapshot == null) {
                                  return LastMessage(
                                    msg: '',
                                  );
                                }
                                return LastMessage(
                                  msg: snapshot.first.from == this.myID
                                      ? 'You: ${snapshot.first.msg}'
                                      : snapshot.first.msg,
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 0.4, color: Colors.blue[100])),
                          color: Colors.white,
                        ),
                        child: ListTile(
                          title: buildLabelText(this.chatFromDisplayName, 16.0,
                              Colors.blue, FontWeight.bold),
                          subtitle: StreamProvider.value(
                            value: ChatDatabase(
                                    errandID: widget.chatInbox.errandID)
                                .msgs,
                            child: Builder(builder: (context) {
                              var snapshot = Provider.of<List<Msg>>(context);
                              if (snapshot == null) {
                                return LastMessage(
                                  msg: '',
                                );
                              }
                              return LastMessage(
                                msg: snapshot.first.from == this.myID
                                    ? 'You: ${snapshot.first.msg}'
                                    : snapshot.first.msg,
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
            ),
          )
        : Container();
  }

  void checkIfChatbelongsToMe() async {
    fb_auth.User user = await _auth.getCurrentUser();
    setState(() {
      if (user.uid == widget.chatInbox.freelancerUID ||
          user.uid == widget.chatInbox.clientUID) {
        this.me = true;
      } else {
        this.me = false;
      }
    });
  }

  void getMessageFrom() async {
    fb_auth.User user = await _auth.getCurrentUser();
    String displayName = '';
    if (user.uid == widget.chatInbox.freelancerUID) {
      setState(() {
        this.chatFromUID = widget.chatInbox.clientUID;
        this.userType = 'Client';
      });
    } else {
      setState(() {
        this.chatFromUID = widget.chatInbox.freelancerUID;
        this.userType = 'Freelancer';
      });
    }
    displayName = await ProfileDatabase(uid: this.chatFromUID).getProfileName();
    String _contact =
        await ProfileDatabase(uid: this.chatFromUID).getProfileContact();
    setState(() {
      this.chatFromDisplayName = displayName;
      this.contact = _contact;
      this.myID = user.uid;
    });
  }
}

class LastMessage extends StatelessWidget {
  final String msg;
  LastMessage({this.msg});
  @override
  Widget build(BuildContext context) {
    return buildLabelTextRegular(summarizeMessage(msg), 12, Colors.grey);
  }

  String summarizeMessage(String message) {
    if (msg.length > 30) {
      return '${msg.substring(0, 30)}...';
    }
    return msg;
  }
}
