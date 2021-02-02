import 'package:flutter/material.dart';
import 'package:sugoapp/models/posts.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';

class ErrandNotes extends StatelessWidget {
  final Post post;
  ErrandNotes({this.post});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: getMediaQueryHeightViaDivision(context, 1),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSubLabelText('Notes', 18.0, Colors.black, FontWeight.normal),
              buildLabelText(post.notes, 14.0, Colors.black, FontWeight.normal),
            ],
          ),
        ),
      ),
    );
  }
}
