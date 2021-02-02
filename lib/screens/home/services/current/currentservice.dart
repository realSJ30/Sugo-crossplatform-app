import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:sugoapp/screens/home/services/current/ongoing/ongoinglist.dart';
import 'package:sugoapp/screens/home/services/current/posted/postedlist.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugoapp/models/posts.dart';
import 'package:sugoapp/services/auth.dart';
import 'package:sugoapp/services/servicesdatabase.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';

class CurrentService extends StatefulWidget {
  final String status;
  CurrentService({this.status});
  @override
  _CurrentServiceState createState() => _CurrentServiceState();
}

class _CurrentServiceState extends State<CurrentService> {
  AuthService _auth = new AuthService();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getsUserId(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Padding(
            padding: EdgeInsets.only(
                top: getMediaQueryHeightViaDivision(context, 3)),
            child: loadingWidget(),
          );
        }
        return StreamProvider<List<Post>>.value(
          value: ServicesDatabase(uid: snapshot.data).posts,
          child: SafeArea(
            child: LoadingOverlay(
              isLoading: _isLoading,
              child: Scaffold(
                appBar:
                    appBar(widget.status == 'on going' ? 'On going' : 'Posted'),
                body: widget.status == 'on going'
                    ? OnGoingList(
                        uid: snapshot.data,
                      )
                    : widget.status == 'posted'
                        ? PostedList(status: 'posted', uid: snapshot.data)
                        : Container(),
              ),
            ),
          ),
        );
      },
    );
  }

  Future getsUserId() async {
    final fb_auth.User user = await _auth.getCurrentUser();
    return user.uid;
  }

  void setLoading(bool load) {
    setState(() {
      this._isLoading = load;
    });
  }
}
