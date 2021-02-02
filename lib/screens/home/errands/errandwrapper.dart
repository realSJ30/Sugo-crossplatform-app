import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugoapp/models/userprofile.dart';

import 'package:sugoapp/screens/home/errands/errandauthenticate.dart';
import 'package:sugoapp/services/auth.dart';
import 'package:sugoapp/services/database.dart';
import 'package:sugoapp/services/profiledatabase.dart';
import 'package:sugoapp/shared/widgets.dart';

class ErrandWrapper extends StatefulWidget {
  @override
  _ErrandWrapperState createState() => _ErrandWrapperState();
}

class _ErrandWrapperState extends State<ErrandWrapper> {
  AuthService _auth = new AuthService();
  @override
  Widget build(BuildContext context) {
    // final _userprofile = Provider.of<UserProfile>(context);
    //either returns do you want to a freelancer card or the feelancers page...
    // print(_userprofile.account);
    return FutureBuilder(
      future: getsUserId(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return loadingWidget();
        }
        return StreamProvider<UserProfile>.value(
          value: ProfileDatabase(uid: snapshot.data).profile,
          child: ErrandAuthenticate(),
        );
      },
    );
  }

  Future getsUserId() async {
    final fb_auth.User user = await _auth.getCurrentUser();
    return user.uid;
  }
}
