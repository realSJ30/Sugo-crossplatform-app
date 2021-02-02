import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugoapp/models/posts.dart';
import 'package:sugoapp/screens/home/services/basicmenu/currenttile.dart';
import 'package:sugoapp/shared/widgets.dart';

class CurrentList extends StatefulWidget {
  final String uid;
  CurrentList({this.uid});
  @override
  _CurrentListState createState() => _CurrentListState();
}

class _CurrentListState extends State<CurrentList> {
  var post;

  @override
  Widget build(BuildContext context) {
    post = Provider.of<List<Post>>(context) ?? [];

    bool postedExist() {
      for (int i = 0; i < post.length; i++) {
        if (post[i].status == 'posted') {
          return true;
        }
      }
      return false;
    }

    bool mypost() {
      for (int i = 0; i < post.length; i++) {
        if (post[i].userid == widget.uid) {
          return true;
        }
      }
      return false;
    }

    print('post count: ${post.length}');
    return post.length > 0 && postedExist() && mypost()
        ? RefreshIndicator(
            onRefresh: refreshList,
            child: ListView.builder(
              itemCount: post.length,
              // ignore: missing_return
              itemBuilder: (context, index) {
                return CurrentTile(
                  post: post[index],
                  uid: widget.uid,
                );
              },
            ),
          )
        : Container(
            child: Center(
              child: buildLabelText(
                  'No Errands yet.', 14.0, Colors.grey, FontWeight.normal),
            ),
          );
  }

  Future refreshList() async {
    await Future.delayed(Duration(seconds: 1));
    this.setState(() {
      post = Provider.of<List<Post>>(context) ?? [];
    });
    return null;
  }
}
