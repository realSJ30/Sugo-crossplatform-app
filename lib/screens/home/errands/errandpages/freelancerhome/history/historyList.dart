import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugoapp/models/finisherrands.dart';
import 'package:sugoapp/models/posts.dart';
import 'package:sugoapp/screens/home/errands/errandpages/freelancerhome/history/historyTile.dart';
import 'package:sugoapp/services/servicesdatabase.dart';
import 'package:sugoapp/shared/widgets.dart';

class HistoryList extends StatefulWidget {
  final String uid;
  HistoryList({this.uid});
  @override
  _HistoryListState createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  List<FinishedErrands> finishederrands;
  @override
  Widget build(BuildContext context) {
    finishederrands = Provider.of<List<FinishedErrands>>(context) ?? [];

    return finishederrands.length > 0
        ? FutureBuilder(
            future:
                ServicesDatabase().postListFromFinishedErrands(finishederrands),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              List<Post> post = snapshot.data;
              return ListView.builder(
                  itemCount: post.length,
                  itemBuilder: (context, index) {
                    return HistoryTile(
                      post: post[index],
                    );
                  });
            })
        : Container(
            child: Center(
              child: buildLabelText(
                  'No history yet.', 14.0, Colors.grey, FontWeight.normal),
            ),
          );
  }
}
