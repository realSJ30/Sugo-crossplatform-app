import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugoapp/models/msg.dart';
import 'package:sugoapp/screens/home/communication/message.dart';
import 'package:sugoapp/services/chatdatabase.dart';
import 'package:sugoapp/shared/widgets.dart';

class InboxList extends StatefulWidget {
  final String uid;
  InboxList({this.uid});
  @override
  _InboxListState createState() => _InboxListState();
}

class _InboxListState extends State<InboxList> {
  @override
  Widget build(BuildContext context) {
    List<ChatInbox> chats = Provider.of<List<ChatInbox>>(context) ?? [];

    bool myconvo() {
      for (int i = 0; i < chats.length; i++) {
        if (chats[i].clientUID == widget.uid ||
            chats[i].freelancerUID == widget.uid) {
          return true;
        }
      }
      return false;
    }

    return chats.length > 0 && myconvo()
        ? Padding(
            padding: const EdgeInsets.all(4.0),
            child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                return StreamProvider.value(
                  value: ChatDatabase(errandID: chats[index].errandID).msgs,
                  child: MessageTile(
                    uid: widget.uid,
                    chatInbox: chats[index],
                  ),
                );
              },
            ),
          )
        : Container(
            child: Center(
              child: buildLabelText(
                  'No messages yet.', 14.0, Colors.grey, FontWeight.normal),
            ),
          );
  }
}
