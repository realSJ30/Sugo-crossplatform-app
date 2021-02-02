import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugoapp/models/userprofile.dart';
import 'package:sugoapp/screens/home/home.dart';
import 'package:sugoapp/services/auth.dart';
import 'package:sugoapp/services/profiledatabase.dart';
import 'package:sugoapp/shared/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class HomeWrapper extends StatefulWidget {
  final String uid;
  HomeWrapper({this.uid});
  @override
  _HomeWrapperState createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  AuthService _auth = new AuthService();
  @override
  Widget build(BuildContext context) {
    final _userprofile = Provider.of<UserProfile>(context);
    return FutureBuilder(
      future: ProfileDatabase(uid: widget.uid).getUserFields(field: 'status'),
      builder: (context, snap) {
        if (!snap.hasData) {
          return loadingWidget();
        }
        if (snap.data == 'enabled') {
          return Home(
            uid: widget.uid,
          );
        }
        if (_userprofile == null) {
          return loadingWidget();
        } else {
          if (_userprofile.status == 'disabled') {
            _auth.signOut();
          }
        }
        return Home(
          uid: widget.uid,
        );
      },
    );
  }
}
