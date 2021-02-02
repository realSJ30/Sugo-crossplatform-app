import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugoapp/models/posts.dart';
import 'package:sugoapp/screens/home/errands/errandpages/freelancerhome/frequesttile.dart';
import 'package:sugoapp/services/auth.dart';
import 'package:sugoapp/services/profiledatabase.dart';
import 'package:sugoapp/services/servicesdatabase.dart';
import 'package:sugoapp/shared/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class FRequestedList extends StatefulWidget {
  final String uid;
  FRequestedList({this.uid});
  @override
  _FRequestedListState createState() => _FRequestedListState();
}

class _FRequestedListState extends State<FRequestedList> {
  List<Post> post;

  @override
  Widget build(BuildContext context) {
    post = Provider.of<List<Post>>(context) ?? [];

    print('post count: ${post.length}');
    return FutureBuilder(
        future: checkIfAcceptedOrNot(post),
        builder: (context, snap) {
          if (!snap.hasData) {
            return Container(
              child: Center(
                child: buildLabelText(
                    'No Errands yet.', 14.0, Colors.grey, FontWeight.normal),
              ),
            );
          }
          print('snap data : ${snap.data}');
          return snap.data
              ? post.length > 0
                  ? RefreshIndicator(
                      onRefresh: refreshList,
                      child: ListView.builder(
                        itemCount: post.length,
                        // ignore: missing_return
                        itemBuilder: (context, index) {
                          return FRequestTile(
                            post: post[index],
                            uid: widget.uid,
                          );
                        },
                      ),
                    )
                  : Container(
                      child: Center(
                        child: buildLabelText('No Errands yet.', 14.0,
                            Colors.grey, FontWeight.normal),
                      ),
                    )
              : Container(
                  child: Center(
                    child: buildLabelText('No Errands yet.', 14.0, Colors.grey,
                        FontWeight.normal),
                  ),
                );
        });
  }

  Future refreshList() async {
    await Future.delayed(Duration(seconds: 1));
    this.setState(() {
      post = Provider.of<List<Post>>(context) ?? [];
    });
    return null;
  }

  Future checkIfAcceptedOrNot(List<Post> post) async {
    try {
      for (int i = 0; i < post.length; i++) {
        if (post[i].status == 'posted') {
          bool document = await ProfileDatabase(uid: widget.uid)
              .checkIfAlreadyAccepted(post[i].postID);
          print('document $document');
          if (document == true) {
            return true;
          }
        }
      }
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
