import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugoapp/models/posts.dart';
import 'package:sugoapp/screens/home/services/past/pasttile.dart';
import 'package:sugoapp/shared/widgets.dart';

class PastList extends StatefulWidget {
  final String uid;
  PastList({this.uid});
  @override
  _PastListState createState() => _PastListState();
}

class _PastListState extends State<PastList> {
  var post;
  @override
  Widget build(BuildContext context) {
    post = Provider.of<List<Post>>(context) ?? [];
    bool mypost() {
      for (int i = 0; i < post.length; i++) {
        if (post[i].userid == widget.uid) {
          return true;
        }
      }
      return false;
    }

    return post.length > 0 && mypost()
        ? RefreshIndicator(
            onRefresh: refreshList,
            child: ListView.builder(
              itemCount: post.length,
              // ignore: missing_return
              itemBuilder: (context, index) {
                return PastTile(
                  post: post[index],
                  uid: widget.uid,
                );
              },
            ),
          )
        : Container(
            child: Center(
              child: buildLabelText('No finished errands yet.', 14.0,
                  Colors.grey, FontWeight.normal),
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
