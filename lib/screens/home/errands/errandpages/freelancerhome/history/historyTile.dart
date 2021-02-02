import 'package:flutter/material.dart';
import 'package:sugoapp/models/posts.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';

class HistoryTile extends StatefulWidget {
  final Post post;
  HistoryTile({this.post});
  @override
  _HistoryTileState createState() => _HistoryTileState();
}

class _HistoryTileState extends State<HistoryTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Container(
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: primaryColor, width: 0.4))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Icon(
              Icons.work,
              color: Colors.grey,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildLabelText(
                    widget.post.tags, 18.0, Colors.black, FontWeight.normal),
                buildLabelText(widget.post.postedDate, 12.0, Colors.grey,
                    FontWeight.normal),
              ],
            ),
            trailing: Container(
              child: buildSubLabelText('${widget.post.fee} PHP', 20.0,
                  Colors.grey, FontWeight.normal),
            ),
          ),
        ),
      ),
    );
  }
}
