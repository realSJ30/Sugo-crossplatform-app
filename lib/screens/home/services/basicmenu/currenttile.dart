import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sugoapp/models/posts.dart';
import 'package:sugoapp/screens/home/errand%20details.dart/details.dart';
import 'package:sugoapp/screens/home/services/current/posted/freelancer%20requests/f_requests.dart';
import 'package:sugoapp/services/auth.dart';
import 'package:sugoapp/services/profiledatabase.dart';
import 'package:sugoapp/services/servicesdatabase.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class CurrentTile extends StatefulWidget {
  final Post post;
  final String uid;

  CurrentTile({this.post, this.uid});
  @override
  _CurrentTileState createState() => _CurrentTileState();
}

class _CurrentTileState extends State<CurrentTile> {
  final AuthService _auth = new AuthService();

  @override
  Widget build(BuildContext context) {
    return widget.post.status == 'posted' && widget.post.userid == widget.uid
        ? InkWell(
            onTap: () {
              _showbottomModal();
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.work,
                      color: primaryColor,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        buildLabelText(widget.post.tags, 18.0, Colors.black,
                            FontWeight.normal),
                        buildLabelText(widget.post.postedDate, 12.0,
                            Colors.grey, FontWeight.normal),
                      ],
                    ),
                    trailing: trailing(widget.post.status),
                  ),
                ),
              ),
            ),
          )
        : Container();
  }

  Widget trailing(String status) {
    return status == 'posted'
        ? FutureBuilder(
            builder: (context, snap) {
              if (!snap.hasData) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        buildLabelText(
                            '0', 14.0, Colors.grey, FontWeight.normal),
                        Icon(
                          Icons.person_add,
                          size: 20,
                          color: Colors.grey,
                        )
                      ],
                    ),
                  ),
                );
              }
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => FreelancerRequests(
                                post: widget.post,
                              )));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: snap.data == 0 ? Colors.grey[50] : Colors.green[50],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        buildLabelText(
                            '${snap.data}',
                            14.0,
                            snap.data == 0 ? Colors.grey : Colors.green,
                            FontWeight.normal),
                        Icon(
                          Icons.person_add,
                          size: 20,
                          color: snap.data == 0 ? Colors.grey : Colors.green,
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
            future: totalRequest(),
          )
        : null;
  }

  Future totalRequest() async {
    return await ServicesDatabase(postid: widget.post.postID).totalRequests();
  }

  void _showConfirmRemoveAlert() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: buildLabelText(
                'Confirm action', 12.0, primaryColor, FontWeight.normal),
            content: buildLabelText("Are you sure to remove errand?", 12.0,
                Colors.grey, FontWeight.normal),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: buildLabelText(
                      'Cancel', 14.0, Colors.black, FontWeight.normal)),
              FlatButton(
                  // ignore: missing_return
                  onPressed: () async {
                    //remove data to cloud
                    fb_auth.User user = await _auth.getCurrentUser();
                    ServicesDatabase(postid: widget.post.postID).deletePost();
                    Navigator.pop(context);
                  },
                  child: buildLabelText(
                      'Confirm', 14.0, primaryColor, FontWeight.normal)),
            ],
          );
        });
  }

  void _showbottomModal() {
    showMaterialModalBottomSheet(
        context: context,
        builder: (context, scroll) {
          return Container(
            height: getMediaQueryHeightViaDivision(context, 5),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => Details(
                                  post: widget.post,
                                )));
                  },
                  child: ListTile(
                    title: Row(
                      children: [
                        Icon(
                          Icons.info,
                          size: 20.0,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        buildLabelText(
                            'Details', 14.0, Colors.grey, FontWeight.normal)
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    widget.post.paymentType != 'SUGO Coins'
                        ? _showConfirmRemoveAlert()
                        : _showConfirmRemoveAlertwithRefund();
                  },
                  child: ListTile(
                    title: Row(
                      children: [
                        Icon(
                          Icons.delete_forever,
                          size: 20.0,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        buildLabelText(
                            'Remove', 14.0, Colors.grey, FontWeight.normal)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _showConfirmRemoveAlertwithRefund() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: buildLabelText(
                'Confirm action', 12.0, primaryColor, FontWeight.normal),
            content: buildLabelText(
                "Are you sure?\n[-10% deduction to your refund]",
                12.0,
                Colors.grey,
                FontWeight.normal),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: buildLabelText(
                      'Cancel', 14.0, Colors.black, FontWeight.normal)),
              FlatButton(
                  // ignore: missing_return
                  onPressed: () async {
                    //remove data to cloud
                    fb_auth.User user = await _auth.getCurrentUser();
                    ServicesDatabase(postid: widget.post.postID).deletePost();
                    double credits =
                        await ProfileDatabase(uid: user.uid).getCredits();
                    double refund = double.parse(widget.post.fee) -
                        (double.parse(widget.post.fee) * 0.10);

                    await ProfileDatabase(uid: user.uid)
                        .topUpCredits(oldvalue: credits, addedvalue: refund);
                    Navigator.pop(context);
                  },
                  child: buildLabelText(
                      'Confirm', 14.0, primaryColor, FontWeight.normal)),
            ],
          );
        });
  }
}
