import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugoapp/models/msg.dart';
import 'package:sugoapp/screens/home/communication/inboxlist.dart';
import 'package:sugoapp/services/chatdatabase.dart';
import 'package:sugoapp/shared/widgets.dart';

class Inbox extends StatefulWidget {
  final String uid;
  Inbox({this.uid});

  @override
  _InboxState createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar('Messages'),
        body: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Expanded(
                  child: Container(
                color: Colors.white,
                // height: getMediaQueryHeightViaMinus(context, 150.0),
                child: StreamProvider<List<ChatInbox>>.value(
                  value: ChatDatabase().chats,
                  child: InboxList(
                    uid: widget.uid,
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
