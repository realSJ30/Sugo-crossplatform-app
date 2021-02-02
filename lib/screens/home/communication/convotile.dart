import 'package:flutter/material.dart';
import 'package:sugoapp/models/msg.dart';
import 'package:sugoapp/services/chatdatabase.dart';
import 'package:sugoapp/services/servicesdatabase.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';

class ConvoTile extends StatefulWidget {
  final Msg msg;
  final String myUID;
  final String postID;

  ConvoTile({this.msg, this.myUID, this.postID});

  @override
  _ConvoTileState createState() => _ConvoTileState();
}

class _ConvoTileState extends State<ConvoTile> {
  double bottom = 2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    seenMessage();
  }

  void seenMessage() async {
    await ChatDatabase(errandID: widget.postID)
        .updateMessageRead(uid: widget.myUID);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('show date');
        setState(() {
          if (bottom == 2) {
            bottom = 5;
          } else {
            bottom = 2;
          }
        });
      },
      child: AnimatedPadding(
        curve: Curves.easeInOut,
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.only(bottom: bottom),
        child: Container(
          child: Column(
            crossAxisAlignment:
                me() ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              widget.msg.msg == 'REQUEST CANCEL ERRAND'
                  ? Material(
                      color: Colors.red[400],
                      elevation: 2.0,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                          topLeft: Radius.circular(me() ? 25 : 5),
                          topRight: Radius.circular(me() ? 5 : 25)),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: buildLabelText(
                                  'Requested for cancellation.',
                                  14.0,
                                  me() ? Colors.white : Colors.black87,
                                  FontWeight.normal),
                            ),
                            !me()
                                ? FutureBuilder(
                                    builder: (context, snap) {
                                      if (!snap.hasData) {
                                        return Container();
                                      }
                                      return snap.data == 'cancelled'
                                          ? Container()
                                          : InkWell(
                                              onTap: () {
                                                print('CANCEL THE ERRAND');
                                                showConfirmCancelDialog();
                                              },
                                              child: buildLabelText(
                                                  'Confirm',
                                                  14.0,
                                                  Colors.black,
                                                  FontWeight.bold),
                                            );
                                    },
                                    future:
                                        ServicesDatabase(postid: widget.postID)
                                            .getPostStatus(),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    )
                  : widget.msg.url.isEmpty
                      ? Material(
                          color: me() ? Colors.blue[500] : Colors.blue[50],
                          elevation: 2.0,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                              topLeft: Radius.circular(me() ? 25 : 5),
                              topRight: Radius.circular(me() ? 5 : 25)),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: buildLabelTextRegular(
                              widget.msg.msg,
                              16.0,
                              me() ? Colors.white : Colors.black87,
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Image.network(
                                      widget.msg.url,
                                    ),
                                  );
                                });
                          },
                          child: Container(
                            width: getMediaQueryWidthViaDivision(context, 1.5),
                            height: getMediaQueryHeightViaDivision(context, 3),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    widget.msg.url,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
              separator(5),
              if (bottom == 5)
                buildSubLabelText(widget.msg.createdAt, 10, Colors.blueGrey,
                    FontWeight.normal)
            ],
          ),
        ),
      ),
    );
  }

  bool me() {
    if (widget.myUID == widget.msg.from) {
      return true;
    } else {
      return false;
    }
  }

  void showConfirmCancelDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: buildLabelText(
                  'Confirm cancel', 14.0, Colors.black, FontWeight.normal),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: buildLabelText(
                        'Cancel', 14.0, Colors.grey, FontWeight.normal)),
                FlatButton(
                    onPressed: () async {
                      await ServicesDatabase(postid: widget.postID)
                          .updatePostedErrandStatus(status: 'cancelled');
                      Navigator.pop(context);
                    },
                    child: buildLabelText(
                        'Confirm', 14.0, Colors.black, FontWeight.normal)),
              ],
            ));
  }
}
