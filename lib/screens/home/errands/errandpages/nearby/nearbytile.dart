import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sugoapp/models/posts.dart';
import 'package:sugoapp/screens/home/errand%20details.dart/details.dart';
import 'package:sugoapp/screens/home/errands/errandpages/errandlocation.dart';
import 'package:sugoapp/services/auth.dart';
import 'package:sugoapp/services/profiledatabase.dart';
import 'package:sugoapp/services/servicesdatabase.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class NearbyTile extends StatefulWidget {
  final Post post;
  final String uid;
  final LocationData mylocation;

  NearbyTile({this.post, this.uid, this.mylocation});
  @override
  _NearbyTileState createState() => _NearbyTileState();
}

class _NearbyTileState extends State<NearbyTile> {
  final AuthService _auth = new AuthService();
  bool isRequested = false;
  bool isNearby = false;
  bool isAccepted = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfNearbyOrNot();
    checkIfAcceptedOrNot();
    checkIfRequestedOrNot();
  }

  @override
  Widget build(BuildContext context) {
    return isNearby &&
            widget.post.status == 'posted' &&
            widget.post.userid != widget.uid
        ? tile()
        : Container();
  }

  Widget tile() {
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
              color: primaryColor,
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
            subtitle: Row(
              children: <Widget>[
                Expanded(
                    child: ButtonTheme(
                  height: 30,
                  child: RaisedButton(
                      elevation: 0,
                      onPressed: () async {
                        // ignore: unnecessary_statements
                        print('view');
                        // _showDetailsModal('posted');
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => Details(
                                      post: widget.post,
                                    )));
                      },
                      color: Colors.blue,
                      splashColor: secondaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      child: buildSubLabelText(
                          'Details', 14.0, Colors.white, FontWeight.normal)),
                )),
                !isAccepted ? requestButton() : acceptButton()
              ],
            ),
            trailing: Column(
              children: <Widget>[
                buildSubLabelText(
                    'Location', 10.0, Colors.grey, FontWeight.normal),
                separator(5),
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    if (isNearby)
                      Container(
                        height: 35,
                        width: 35,
                        child: SpinKitDoubleBounce(
                          color: Colors.blue,
                          size: 35,
                        ),
                      ),
                    ClipOval(
                      child: Material(
                        color: Colors.blue[100].withOpacity(isNearby ? 0.1 : 1),
                        child: InkWell(
                          onTap: () {
                            print('show location');
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => ErrandLocation(
                                          post: widget.post,
                                        )));
                          },
                          splashColor: Colors.blue,
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: Icon(
                              Icons.location_on,
                              color: Colors.blue[900],
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget requestButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 2.0),
      child: ButtonTheme(
        height: 30,
        child: RaisedButton(
            elevation: 0,
            onPressed: () async {
              // ignore: unnecessary_statements
              if (!isRequested) {
                fb_auth.User user = await _auth.getCurrentUser();
                await ServicesDatabase(postid: widget.post.postID).sendRequest(
                  user.uid,
                );
                setState(() {
                  isRequested = true;
                });
                showSnack(context, 'Requested Successfully');
              } else {
                showWarningSnack(context, 'You have already requested!');
              }
            },
            color: isRequested == false ? Colors.green[400] : Colors.green[200],
            splashColor: secondaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            child: buildSubLabelText(
                isRequested == false ? 'Request' : 'Requested',
                14.0,
                Colors.white,
                FontWeight.normal)),
      ),
    );
  }

  Widget acceptButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 2.0),
      child: ButtonTheme(
        height: 30,
        child: RaisedButton(
            elevation: 0,
            onPressed: () async {
              // ignore: unnecessary_statements
              fb_auth.User user = await _auth.getCurrentUser();
              print('working the errand');
              await ServicesDatabase(postid: widget.post.postID)
                  .verifyAndWorkErrandRequest(user.uid);
            },
            color: Colors.green[400],
            splashColor: secondaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            child: buildSubLabelText(
                'Work now', 14.0, Colors.white, FontWeight.normal)),
      ),
    );
  }

  //HAVERSINE
  checkIfNearbyOrNot() async {
    print('girun : ${widget.post.postID}');

    if (this.mounted) {
      try {
        List<String> latlngs = widget.post.position
            .substring(7, widget.post.position.length - 1)
            .split(',');
        LatLng errandLatlng =
            LatLng(double.parse(latlngs[0]), double.parse(latlngs[1]));
        // print('girun ${widget.post.postID} : $errandLatlng');

        LatLng myLocation =
            LatLng(widget.mylocation.latitude, widget.mylocation.longitude);
        if (haversineFormula(myLocation, errandLatlng) > 2) {
          setState(() {
            isNearby = false;
          });
        } else {
          // print('DOOL');
          setState(() {
            isNearby = true;
          });
        }
      } catch (e) {
        print('ERROR: ${e.toString()}');
      }
    }
  }

  checkIfRequestedOrNot() async {
    try {
      DocumentSnapshot document =
          await ServicesDatabase(postid: widget.post.postID)
              .ifAlreadyRequested(widget.uid);
      this.setState(() {
        isRequested = document.exists;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  checkIfAcceptedOrNot() async {
    try {
      fb_auth.User user = await _auth.getCurrentUser();

      await ProfileDatabase(uid: user.uid)
          .checkIfAlreadyAccepted(widget.post.postID)
          .then((value) => this.setState(() {
                isAccepted = value;
                print(isAccepted);
              }));
    } catch (e) {
      print(e.toString());
    }
  }
}
