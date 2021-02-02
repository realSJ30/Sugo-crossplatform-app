import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugoapp/models/msg.dart';
import 'package:sugoapp/models/posts.dart';
import 'package:sugoapp/screens/home/communication/convotile.dart';

class ConvoList extends StatefulWidget {
  final String myUID;
  final ScrollController scrollController;
  final String postID;
  ConvoList({this.myUID, this.scrollController, this.postID});
  @override
  _ConvoListState createState() => _ConvoListState();
}

class _ConvoListState extends State<ConvoList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var msg = Provider.of<List<Msg>>(context) ?? [];

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListView.builder(
        reverse: true,
        controller: widget.scrollController,
        itemCount: msg.length,
        itemBuilder: (context, index) {
          return ConvoTile(
            msg: msg[index],
            myUID: widget.myUID,
            postID: widget.postID,
          );
        },
      ),
    );
  }
}
