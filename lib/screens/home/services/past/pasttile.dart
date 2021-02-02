import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sugoapp/models/posts.dart';
import 'package:sugoapp/screens/home/errand%20details.dart/details.dart';
import 'package:sugoapp/screens/home/services/past/pastmodal.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';

class PastTile extends StatefulWidget {
  final Post post;
  final String uid;
  PastTile({this.post, this.uid});
  @override
  _PastTileState createState() => _PastTileState();
}

class _PastTileState extends State<PastTile> {
  void _showDetailsModal() {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => Details(
                  post: widget.post,
                )));
    // showBarModalBottomSheet(
    //     expand: true,
    //     context: context,
    //     duration: Duration(milliseconds: 200),
    //     builder: (context, scrollcontroller) {
    //       return PastModalDetail(
    //         post: widget.post,
    //       );
    //     });
  }

  @override
  Widget build(BuildContext context) {
    return widget.post.status == 'finished' || widget.post.status == 'cancelled'
        ? widget.post.userid == widget.uid
            ? InkWell(
                onTap: () {
                  _showDetailsModal();
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: primaryColor, width: 0.4))),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(
                                Icons.work,
                                color: Colors.grey,
                              ),
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        buildLabelText(widget.post.tags, 18.0,
                                            Colors.black, FontWeight.normal),
                                        buildLabelText(
                                            widget.post.postedDate,
                                            12.0,
                                            Colors.grey,
                                            FontWeight.normal),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Container(
                                child: buildSubLabelText(
                                    widget.post.status,
                                    12.0,
                                    widget.post.status == 'cancelled'
                                        ? Colors.grey
                                        : Colors.green,
                                    FontWeight.normal),
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
              )
            : Container()
        : Container();
  }
}
