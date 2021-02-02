import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugoapp/models/posts.dart';
import 'package:sugoapp/screens/home/services/past/pastlist.dart';
import 'package:sugoapp/services/auth.dart';
import 'package:sugoapp/services/servicesdatabase.dart';
import 'package:sugoapp/shared/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class Past extends StatefulWidget {
  @override
  _PastState createState() => _PastState();
}

class _PastState extends State<Past> {
  AuthService _auth = new AuthService();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snap) {
        if (!snap.hasData) {
          return loadingWidget();
        }
        return SafeArea(
            child: Scaffold(
          appBar: appBar('History'),
          body: StreamProvider<List<Post>>.value(
            value: ServicesDatabase(uid: snap.data).posts,
            child: PastList(
              uid: snap.data,
            ),
          ),
        ));
      },
      future: getsUserId(),
    );
  }

  Future getsUserId() async {
    final fb_auth.User user = await _auth.getCurrentUser();
    return user.uid;
  }
}
