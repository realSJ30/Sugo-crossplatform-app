import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:sugoapp/models/posts.dart';
import 'package:sugoapp/models/userprofile.dart';
import 'package:sugoapp/screens/home/communication/inbox.dart';
import 'package:sugoapp/screens/home/errands/errandpages/errands.dart';
import 'package:sugoapp/screens/home/errands/errandwrapper.dart';
import 'package:sugoapp/screens/home/logs/activitylog.dart';
import 'package:sugoapp/screens/home/profile/profile.dart';
import 'package:sugoapp/screens/home/rating/freelancerrating.dart';
import 'package:sugoapp/screens/home/services/basicmenu/servicemenu.dart';
import 'package:sugoapp/screens/home/services/past/past.dart';
import 'package:sugoapp/screens/home/services/services.dart';
import 'package:sugoapp/services/auth.dart';
import 'package:sugoapp/services/profiledatabase.dart';
import 'package:sugoapp/services/pushnotifications.dart';
import 'package:sugoapp/services/servicesdatabase.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/drawerheader.dart';
import 'package:sugoapp/shared/widgets.dart';
import 'package:sugoapp/shared/string_extension.dart';
import 'package:tuxin_tutorial_overlay/TutorialOverlayUtil.dart';
import 'package:tuxin_tutorial_overlay/WidgetData.dart';

class Home extends StatefulWidget {
  final String uid;
  Home({this.uid});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthService _auth = new AuthService();
  final GlobalKey helpButtonKey = GlobalKey();
  final GlobalKey requestButtonKey = GlobalKey();
  final GlobalKey listKey = GlobalKey();
  final GlobalKey freelancerRequestKey = GlobalKey();

  //FIREBASE CLOUD MESSAGING (PUSH NOTIFICATIONS)
  final FirebaseMessaging _fcm = new FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    //onMessage - application is open
    //onResume - application is running on background
    //onLaunch - application is closed
    showOverlay();
    // if (Platform.isAndroid) {

    // }
    _fcm.configure(onMessage: (message) async {
      String ref = message['notification']['title'].toString();
      if (ref == 'Errand Finished') {
        print('notif datas: $message');
        print('notif datas: ${message['data']['postid']}');
        print('notif datas: ${message['data']['freelancerUID']}');
        showFreelancerFinishDialog(
          msg: message['notification']['body'],
          postid: message['data']['postid'],
          freelanceruid: message['data']['freelancerUID'],
        );
      } else if (ref == 'Request Approved') {
        print('notif datas: $message');
        print('notif datas: ${message['data']['sample']}');
        showClientAcceptDialog(
            msg: message['notification']['body'],
            postid: message['data']['postid']);
      }
    }, onResume: (message) async {
      String ref = message['notification']['title'].toString();
      if (ref == 'Errand Finished') {
        showFreelancerFinishDialog(
          msg: message['notification']['body'],
          postid: message['data']['postid'],
          freelanceruid: message['data']['freelancerUID'],
        );
      } else if (ref == 'Request Approved') {
        print('notif datas: $message');
        print('notif datas: ${message['data']['sample']}');
        showClientAcceptDialog(
            msg: message['notification']['body'],
            postid: message['data']['postid']);
      } else {
        print('hello chat');
      }
    }, onLaunch: (message) async {
      String ref = message['notification']['title'].toString();
      if (ref == 'Errand Finished') {
        showFreelancerFinishDialog(
          msg: message['notification']['body'],
          postid: message['data']['postid'],
          freelanceruid: message['data']['freelancerUID'],
        );
      } else if (ref == 'Request Approved') {
        print('notif datas: $message');
        print('notif datas: ${message['data']['sample']}');
        showClientAcceptDialog(
            msg: message['notification']['body'],
            postid: message['data']['postid']);
      } else {
        print('hello chat');
      }
    });
    _fcm.requestNotificationPermissions(const IosNotificationSettings(
        sound: true, badge: true, alert: true, provisional: false));
  }

  void showOverlay() {
    // setTutorialShowOverlayHook((String tagName) => print('showing'));
    createTutorialOverlay(
        tagName: 'request',
        context: context,
        bgColor: Colors.black.withOpacity(0.8),
        onTap: () {
          print('tap');
          hideOverlayEntryIfExists();
          showOverlayEntry(tagName: 'list');
        },
        widgetsData: <WidgetData>[
          WidgetData(
              key: requestButtonKey,
              isEnabled: false,
              padding: 4,
              shape: WidgetShape.Rect),
        ],
        description: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Material(
              type: MaterialType.transparency,
              child: buildLabelText('This is where you request an errand.',
                  18.0, Colors.white, FontWeight.normal),
            ),
          ),
        ));
    createTutorialOverlay(
        tagName: 'list',
        context: context,
        bgColor: Colors.black.withOpacity(0.8),
        onTap: () {
          print('tap');
          hideOverlayEntryIfExists();
        },
        widgetsData: <WidgetData>[
          WidgetData(
              key: listKey,
              isEnabled: false,
              padding: 4,
              shape: WidgetShape.Rect),
        ],
        description: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Material(
              type: MaterialType.transparency,
              child: buildLabelText(
                  'This is the list of your posted errands\ntogether with the number of\nfreelancersthat are interested.',
                  18.0,
                  Colors.white,
                  FontWeight.normal),
            ),
          ),
        ));
    // SchedulerBinding.instance.addPostFrameCallback((_) {

    // });
  }

  void showFreelancerFinishDialog(
      {String msg, String postid, String freelanceruid}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: ListTile(
                title: buildLabelText(
                    'Hey', 14.0, Colors.black, FontWeight.normal),
                subtitle:
                    buildLabelText(msg, 12.0, Colors.grey, FontWeight.normal),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: buildLabelText(
                      'Later', 14.0, Colors.grey, FontWeight.normal),
                ),
                FlatButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => FreelancerRating(
                              postid: postid,
                              uid: freelanceruid,
                            ));
                  },
                  child: buildLabelText(
                      'Rate Now', 14.0, Colors.black, FontWeight.normal),
                )
              ],
            ));
  }

  void showClientAcceptDialog({String msg, String postid}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: ListTile(
                title: buildLabelText(
                    'Hey', 14.0, Colors.black, FontWeight.normal),
                subtitle:
                    buildLabelText(msg, 12.0, Colors.grey, FontWeight.normal),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: buildLabelText(
                      'Close', 14.0, Colors.grey, FontWeight.normal),
                ),
                FlatButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    fb_auth.User user = await _auth.getCurrentUser();
                    // print('postid: ${message['notification']['title']}');
                    await ServicesDatabase(postid: postid)
                        .verifyAndWorkErrandRequest(user.uid);
                  },
                  child: buildLabelText(
                      'Accept Now', 14.0, Colors.black, FontWeight.normal),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: appBar(
            'Services',
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: InkWell(
                  key: this.helpButtonKey,
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    showOverlayEntry(tagName: 'request');
                  },
                  child: Container(
                      child: Row(
                    children: <Widget>[
                      buildLabelText(
                          'Help', 12.0, Colors.white, FontWeight.normal),
                      Icon(
                        Icons.help_outline,
                        size: 20.0,
                        color: Colors.white,
                      ),
                    ],
                  )),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          body: StreamProvider<List<Post>>.value(
            value: ServicesDatabase(uid: widget.uid).posts,
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      key: requestButtonKey,
                      height: getMediaQueryHeightViaDivision(context, 2.6),
                    ),
                    Expanded(
                      child: Container(
                        key: listKey,
                        height: getMediaQueryHeightViaDivision(context, 2.6),
                      ),
                    ),
                  ],
                ),
                Container(
                  child: ServiceMenu(
                    uid: widget.uid,
                  ),
                ),
              ],
            ),
          ),
          drawer: menuDrawer(),
        ),
      ),
    );
  }

  Widget menuDrawer() {
    return Drawer(
        child: Column(
      children: <Widget>[
        menuDrawerHeader(),
        menuDrawerBody(),
      ],
    ));
  }

  Widget menuDrawerHeader() {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return DrawerHeader(
              child: UserAccountsDrawerHeader(
            accountName:
                buildLabelText('-', 12.0, Colors.black, FontWeight.normal),
            accountEmail:
                buildLabelText('-', 12.0, Colors.black, FontWeight.normal),
          ));
        }
        return StreamProvider<UserProfile>.value(
          value: ProfileDatabase(uid: snapshot.data).profile,
          child: HomeDrawerHeader(),
        );
      },
      future: getUserId(),
    );
  }

  Widget menuDrawerBody() {
    return Container(
      child: Column(
        children: <Widget>[
          separator(20),
          InkWell(
            onTap: () {
              // changePage(Inbox(), 'Messages', 2);
              Navigator.pop(context);
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => Inbox(
                            uid: widget.uid,
                          )));
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.chat_bubble,
                      color: Colors.blue,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: buildLabelText(
                          'Messages', 14.0, Colors.black, FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // if (Platform.isAndroid)
          InkWell(
            onTap: () {
              // changePage(ErrandWrapper(), 'Freelancer', 3);
              Navigator.pop(context);
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => ErrandWrapper()));
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.work,
                      color: Colors.blue,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: buildLabelText(
                          'Freelancer', 14.0, Colors.black, FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              // changePage(Profile(), 'Profile', 1);
              Navigator.pop(context);
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => Profile()));
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.person,
                      color: Colors.blue,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: buildLabelText(
                          'Profile', 14.0, Colors.black, FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Past()));
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.history,
                      color: Colors.blue,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: buildLabelText(
                          'History', 14.0, Colors.black, FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ),
          ),
          separator(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Divider(),
          ),
          separator(20),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ActivityLogs(
                        uid: widget.uid,
                      )));
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.note,
                      color: Colors.blue,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: buildLabelText(
                          'Logs', 14.0, Colors.black, FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              showDialog(context: context, child: accountSettings());
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.red[900],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: buildLabelText(
                          'Logout', 14.0, Colors.red[900], FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future getUserId() async {
    final fb_auth.User user = await _auth.getCurrentUser();
    return user.uid;
  }

  //converts data to displayable data e.g names,birthdays
  String fullName(String first, String mid, String last) {
    print('okayss: $first');
    return "${first.capitalize()} ${mid[0].capitalize()}. ${last.capitalize()}";
  }

  Widget accountSettings() {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: buildLabelText(
          'Confirm log out?', 18.0, primaryColor, FontWeight.normal),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
              print('cancel');
            },
            child: buildLabelText(
                'Cancel', 14.0, Colors.black, FontWeight.normal)),
        FlatButton(
            // ignore: missing_return
            onPressed: () async {
              Navigator.pop(context);
              _auth.signOut();
            },
            child: buildLabelText(
                'Log out', 14.0, Colors.red[600], FontWeight.normal)),
      ],
    );
  }
}
