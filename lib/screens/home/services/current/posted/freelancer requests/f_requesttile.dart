import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugoapp/models/freelancer.dart';
import 'package:sugoapp/models/posts.dart';
import 'package:sugoapp/models/userprofile.dart';
import 'package:sugoapp/screens/home/services/current/freelancerprofile/freelancerprofile.dart';
import 'package:sugoapp/services/profiledatabase.dart';
import 'package:sugoapp/services/pushnotifications.dart';
import 'package:sugoapp/services/servicesdatabase.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';

class FreelancerRequestTile extends StatefulWidget {
  final Freelancer freelancer;
  final Post post;
  FreelancerRequestTile({this.freelancer, this.post});
  @override
  _FreelancerRequestTileState createState() => _FreelancerRequestTileState();
}

class _FreelancerRequestTileState extends State<FreelancerRequestTile> {
  bool isWaiting = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfWaitingorNot();
  }

  //meaning gi accept na waiting lg for confirmation
  checkIfWaitingorNot() async {
    String status = await ProfileDatabase()
        .getWaitingJobStatus(widget.freelancer.uid, widget.post.postID);
    if (status != null) {
      this.setState(() {
        isWaiting = true;
      });
    }
  }

  void changeWaiting(bool wait) {
    this.setState(() {
      this.isWaiting = wait;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: primaryColor, width: 0.4))),
      child: FutureBuilder(
        future: ProfileDatabase(uid: widget.freelancer.uid).getProfileName(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return passiveListTile();
          }
          return activeListTile(snap.data);
        },
      ),
    );
  }

  Widget passiveListTile() {
    return ListTile(
      leading: Icon(Icons.person_outline),
      title: buildLabelText(
          'Sugo Freelancer', 16.0, Colors.grey, FontWeight.normal),
    );
  }

  Widget activeListTile(String name) {
    return InkWell(
      onTap: () async {
        double totalRating =
            await ProfileDatabase(uid: widget.freelancer.uid).getTotalRating();
        int totalTask =
            await ProfileDatabase(uid: widget.freelancer.uid).getTotalTask();
        print('total rating: $totalRating');
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => StreamProvider<UserProfile>.value(
                    value: ProfileDatabase(uid: widget.freelancer.uid).profile,
                    child: FreelancerProfile(
                      freelancer: widget.freelancer,
                      post: widget.post,
                      totalRating: totalRating,
                      totalTask: totalTask,
                    ))));
      },
      child: ListTile(
        leading: Icon(
          Icons.person,
          color: Colors.blue,
        ),
        title: buildLabelText(name, 16.0, Colors.black, FontWeight.bold),
        trailing: FutureBuilder(
          builder: (context, snap) {
            if (!snap.hasData) {
              return buildSubLabelText(
                  '', 12.0, Colors.black, FontWeight.normal);
            }
            if (snap.data != 'no status') {
              this.isWaiting = true;
            } else {
              this.isWaiting = false;
            }
            return acceptButton();
          },
          future: ProfileDatabase()
              .getWaitingJobStatus(widget.freelancer.uid, widget.post.postID),
        ),
      ),
    );
  }

  Widget acceptButton() {
    return !isWaiting
        ? FlatButton(
            onPressed: () async {
              var status = await ServicesDatabase(postid: widget.post.postID)
                  .getPostStatus();

              if (status == 'on going') {
                Navigator.pop(context);
              } else {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          title: buildLabelText('Accept freelancer request?',
                              12.0, primaryColor, FontWeight.normal),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: buildLabelText('Cancel', 14.0,
                                    Colors.black, FontWeight.normal)),
                            FlatButton(
                                // ignore: missing_return
                                onPressed: () async {
                                  await ProfileDatabase()
                                      .waitingJobsFromFreelancer(
                                          widget.freelancer.uid,
                                          widget.post.userid,
                                          widget.post.postID,
                                          'waiting');

                                  List<DocumentSnapshot> tokens =
                                      await ProfileDatabase(
                                              uid: widget.freelancer.uid)
                                          .getProfileToken();
                                  String clientName = await ProfileDatabase(
                                          uid: widget.post.userid)
                                      .getProfileName();

                                  print('token: ${tokens[0].id.toString()}');
                                  await PushNotifications()
                                      .sendPushMessageToFreelancer(
                                          receiverToken:
                                              tokens[0].id.toString(),
                                          errand: widget.post.tags,
                                          name: clientName,
                                          postid: widget.post.postID);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  changeWaiting(true);
                                },
                                child: buildLabelText('Confirm', 14.0,
                                    primaryColor, FontWeight.normal)),
                          ]);
                    });
              }
            },
            child: buildSubLabelText(
                'Accept', 14.0, Colors.blue, FontWeight.normal))
        : FlatButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    title: buildLabelText(
                        'Stop waiting?', 12.0, primaryColor, FontWeight.normal),
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
                            //insert data to cloud

                            print('stopped waiting!');
                            await ProfileDatabase().undoAcceptFreelancer(
                                widget.freelancer.uid, widget.post.postID);
                            Navigator.pop(context);
                            changeWaiting(false);
                            // Navigator.popUntil(context,
                            //     (route) => route.isFirst);
                          },
                          child: buildLabelText('Confirm', 14.0, primaryColor,
                              FontWeight.normal)),
                    ],
                  );
                },
              );
            },
            child: buildSubLabelText(
                'Cancel', 14.0, Colors.grey, FontWeight.normal));
  }
}
