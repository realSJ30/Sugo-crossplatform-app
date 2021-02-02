import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sugoapp/models/posts.dart';
import 'package:sugoapp/screens/home/errand%20details.dart/detailsbutton.dart';
import 'package:sugoapp/screens/home/errand%20details.dart/errandicon.dart';
import 'package:sugoapp/screens/home/errand%20details.dart/notes.dart';
import 'package:sugoapp/services/auth.dart';
import 'package:sugoapp/services/profiledatabase.dart';
import 'package:sugoapp/services/servicesdatabase.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class Details extends StatefulWidget {
  final Post post;

  Details({this.post});
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  var freelancerName;
  AuthService _auth = new AuthService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Row(
        children: [
          Expanded(
            child: DetailsButton(
              callback: () {
                showBarModalBottomSheet(
                    context: context,
                    builder: (context, scroll) {
                      return ErrandNotes(
                        post: widget.post,
                      );
                    });
              },
            ),
          ),
        ],
      ),
      appBar: appBar('Errand', actions: [
        if (widget.post.status != 'posted')
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: dotbuttons(),
          )
      ]),
      body: ListView(
        children: [
          widget.post.photos.length > 0
              ? Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 1.5,
                          spreadRadius: 0.0)
                    ],
                  ),
                  height: getMediaQueryHeightViaDivision(context, 2),
                  child: Carousel(
                    boxFit: BoxFit.cover,
                    images: List.generate(widget.post.photos.length, (index) {
                      return InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Container(
                                    child: Image.network(
                                      widget.post.photos[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              });
                        },
                        child: Image.network(
                          widget.post.photos[index],
                          fit: BoxFit.cover,
                        ),
                      );
                    }),
                    autoplay: false,
                    dotSize: 4.0,
                    indicatorBgPadding: 4.0,
                    dotBgColor: Colors.transparent,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Icon(
                            Icons.work,
                            color: Colors.grey[300],
                            size: 50,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildLabelText(
                widget.post.tags, 20, Colors.black, FontWeight.bold),
          ),
          date(),
          separator(10.0),
          fees(),
          separator(10),
          address(),
          separator(10),
          SizedBox(
            height: getMediaQueryHeightViaDivision(context, 12),
          )
        ],
      ),
    ));
  }

  Widget date() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: buildSubLabelText(
                'Posted', 14.0, Colors.grey, FontWeight.normal),
          ),
          buildLabelText(
              widget.post.postedDate, 16.0, Colors.black, FontWeight.normal)
        ],
      ),
    );
  }

  Widget fees() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: buildSubLabelText(
                    'Service Fee', 14.0, Colors.grey, FontWeight.normal),
              ),
              buildLabelText('${widget.post.fee} PHP', 16.0, Colors.black,
                  FontWeight.normal)
            ],
          ),
          separator(18),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: buildSubLabelText(
                    'Payment Type', 14.0, Colors.grey, FontWeight.normal),
              ),
              buildLabelText(widget.post.paymentType, 16.0, Colors.black,
                  FontWeight.normal)
            ],
          ),
        ],
      ),
    );
  }

  Widget address() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSubLabelText('Address', 14.0, Colors.grey, FontWeight.normal),
          TextFormField(
            decoration: InputDecoration(
                focusedBorder: InputBorder.none, border: InputBorder.none),
            initialValue: widget.post.address1,
            maxLines: 2,
            readOnly: true,
          ),
          // buildLabelText(
          //     widget.post.address1, 14.0, Colors.black, FontWeight.normal),
          separator(10),
          buildSubLabelText(
              'Specific Address', 14.0, Colors.grey, FontWeight.normal),
          TextFormField(
            decoration: InputDecoration(
                focusedBorder: InputBorder.none, border: InputBorder.none),
            initialValue:
                widget.post.address2.isEmpty ? 'N/A' : widget.post.address2,
            maxLines: 2,
            readOnly: true,
          ),
        ],
      ),
    );
  }

  Widget dotbuttons() {
    return InkWell(
      onTap: () async {
        print('show more');
        if (freelancerName != null) {
          fb_auth.User user = await _auth.getCurrentUser();
          var freelancerUID = await ServicesDatabase(postid: widget.post.postID)
              .getAcceptedFreelancerUID();

          if (freelancerUID == user.uid) {
            String clientName =
                await ProfileDatabase(uid: widget.post.userid).getProfileName();
            var contact = await ProfileDatabase(uid: user.uid)
                .getUserFields(field: 'contact');
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: buildSubLabelText(
                          'Client', 14.0, Colors.grey, FontWeight.normal),
                      content: Container(
                        height: getMediaQueryHeightViaDivision(context, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildLabelText(clientName, 14.0, Colors.black,
                                FontWeight.normal),
                            buildLabelText(
                                contact, 14.0, Colors.black, FontWeight.normal),
                            separator(10),
                            Row(
                              children: [
                                Expanded(
                                  child: buildLabelText('Status', 14.0,
                                      Colors.grey, FontWeight.normal),
                                ),
                                buildSubLabelText(widget.post.status, 14.0,
                                    Colors.black, FontWeight.normal),
                              ],
                            )
                          ],
                        ),
                      ),
                      actions: [
                        FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: buildLabelText('Confirm', 14.0, Colors.black,
                                FontWeight.normal))
                      ],
                    ));
          } else {
            var contact = await ProfileDatabase(uid: freelancerUID)
                .getUserFields(field: 'contact');
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: buildSubLabelText(
                          'Freelancer', 14.0, Colors.grey, FontWeight.normal),
                      content: Container(
                        height: getMediaQueryHeightViaDivision(context, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildLabelText(freelancerName, 14.0, Colors.black,
                                FontWeight.normal),
                            buildLabelText(
                                contact, 14.0, Colors.black, FontWeight.normal),
                            separator(10),
                            Row(
                              children: [
                                Expanded(
                                  child: buildLabelText('Status', 14.0,
                                      Colors.grey, FontWeight.normal),
                                ),
                                buildSubLabelText(widget.post.status, 14.0,
                                    Colors.black, FontWeight.normal),
                              ],
                            )
                          ],
                        ),
                      ),
                      actions: [
                        FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: buildLabelText('Confirm', 14.0, Colors.black,
                                FontWeight.normal))
                      ],
                    ));
          }
        }
      },
      child: Icon(Icons.more_vert),
    );
  }

  void loadData() async {
    freelancerName = await ServicesDatabase(postid: widget.post.postID)
        .getAcceptedFreelancerProfile();
  }

  Future loadContact() async {
    var freelancerUID = await ServicesDatabase(postid: widget.post.postID)
        .getAcceptedFreelancerUID();
    var contact = await ProfileDatabase(uid: freelancerUID)
        .getUserFields(field: 'contact');
    return contact;
  }
}
