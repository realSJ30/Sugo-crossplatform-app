import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugoapp/models/posts.dart';
import 'package:sugoapp/screens/home/services/current/ongoing/ongoingtile.dart';

class OnGoingList extends StatefulWidget {
  final String uid;
  OnGoingList({this.uid});

  @override
  _OnGoingListState createState() => _OnGoingListState();
}

class _OnGoingListState extends State<OnGoingList> {
  var posts;

  @override
  Widget build(BuildContext context) {
    posts = Provider.of<List<Post>>(context) ?? [];
    print('length ongoing: ${posts.length}');
    return RefreshIndicator(
      onRefresh: refreshList,
      child: ListView.builder(
        itemCount: posts.length,
        // ignore: missing_return
        itemBuilder: (context, index) {
          return OnGoingTile(
            post: posts[index],
            uid: widget.uid,
          );
        },
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
