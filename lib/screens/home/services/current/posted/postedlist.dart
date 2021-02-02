import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugoapp/models/posts.dart';
import 'package:sugoapp/screens/home/services/current/posted/postedtile.dart';
import 'package:sugoapp/services/servicesdatabase.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';

class PostedList extends StatefulWidget {
  final String status;
  final String uid;
  PostedList({this.status, this.uid});
  @override
  _PostedListState createState() => _PostedListState();
}

class _PostedListState extends State<PostedList> {
  var posts;

  @override
  Widget build(BuildContext context) {
    posts = Provider.of<List<Post>>(context) ?? [];
    print('length: ${posts.length}');
    bool postedExist() {
      for (int i = 0; i < posts.length; i++) {
        if (posts[i].status == 'posted') {
          return true;
        }
      }
      return false;
    }

    bool mypost() {
      for (int i = 0; i < posts.length; i++) {
        if (posts[i].userid == widget.uid) {
          return true;
        }
      }
      return false;
    }

    return RefreshIndicator(
      onRefresh: refreshList,
      child: posts.length > 0 && postedExist() && mypost()
          ? ListView.builder(
              itemCount: posts.length,
              // ignore: missing_return
              itemBuilder: (context, index) {
                return PostedTile(
                  uid: widget.uid,
                  post: posts[index],
                  status: widget.status,
                );
              },
            )
          : Container(
              child: Center(
                child: buildLabelText(
                    'No Errands yet.', 14.0, Colors.grey, FontWeight.normal),
              ),
            ),
    );
  }

  Future refreshList() async {
    await Future.delayed(Duration(seconds: 1));
    this.setState(() {
      posts = Provider.of<List<Post>>(context) ?? [];
    });
    return null;
  }
}
