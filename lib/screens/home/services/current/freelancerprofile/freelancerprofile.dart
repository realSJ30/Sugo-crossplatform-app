import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugoapp/models/freelancer.dart';
import 'package:sugoapp/models/photos.dart';
import 'package:sugoapp/models/posts.dart';
import 'package:sugoapp/models/userprofile.dart';
import 'package:sugoapp/screens/home/services/current/freelancerprofile/fphotosList.dart';
import 'package:sugoapp/services/profiledatabase.dart';
import 'package:sugoapp/services/pushnotifications.dart';
import 'package:sugoapp/services/servicesdatabase.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';

class FreelancerProfile extends StatefulWidget {
  final Freelancer freelancer;
  final Post post;
  final double totalRating;
  final int totalTask;

  FreelancerProfile(
      {this.freelancer, this.post, this.totalRating, this.totalTask});
  @override
  _FreelancerProfileState createState() => _FreelancerProfileState();
}

class _FreelancerProfileState extends State<FreelancerProfile> {
  @override
  Widget build(BuildContext context) {
    UserProfile _freelancer = Provider.of<UserProfile>(context);
    if (_freelancer == null) {
      return loadingWidget();
    }
    print('skills: ${_freelancer.skills}');
    return SafeArea(
      child: Scaffold(
        appBar: appBar('View Profile'),
        body: Column(
          children: <Widget>[
            profileContainer(_freelancer),
            skills(skills: _freelancer.skills),
            Expanded(child: worksContainer())
          ],
        ),
      ),
    );
  }

  Widget skills({List<dynamic> skills}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSubLabelText('Skills', 11.0, Colors.grey, FontWeight.normal),
          Container(
            height: getMediaQueryHeightViaDivision(context, 21),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue[400],
                        borderRadius: BorderRadius.circular(6)),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: buildLabelText(
                          skills[index], 14, Colors.white, FontWeight.normal),
                    ),
                  ),
                );
              },
              itemCount: skills.length,
            ),
          )
        ],
      ),
    );
  }

  Widget profileContainer(UserProfile _freelancer) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FutureBuilder(
                        future: ProfileDatabase(uid: widget.freelancer.uid)
                            .getUserFields(field: 'imgpath'),
                        builder: (context, snap) {
                          if (!snap.hasData) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  shape: BoxShape.circle),
                              width: 80,
                              height:
                                  80, //getMediaQueryHeightViaDivision(context, 5)
                              child: Center(
                                  child: Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.grey,
                              )),
                            );
                          }
                          return snap.data.toString().isNotEmpty
                              ? InkWell(
                                  onTap: () {
                                    viewProfilePic(snap.data);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(snap.data),
                                        )),
                                    width: 80,
                                    height:
                                        80, //getMediaQueryHeightViaDivision(context, 5)
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      shape: BoxShape.circle),
                                  width: 80,
                                  height:
                                      80, //getMediaQueryHeightViaDivision(context, 5)
                                  child: Center(
                                      child: Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.grey,
                                  )),
                                );
                        })),
                SizedBox(
                  width: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    buildLabelText(
                        '${_freelancer.firstname} ${_freelancer.middlename[0]} ${_freelancer.lastname}',
                        16.0,
                        Colors.black87,
                        FontWeight.bold),
                    separator(5.0),
                    buildLabelText('${_freelancer.contact}', 12.0, Colors.grey,
                        FontWeight.normal),
                    separator(8.0),
                    Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            buildSubLabelText('Completed task', 12.0,
                                Colors.grey, FontWeight.normal),
                            buildLabelText('${widget.totalTask}', 14.0,
                                Colors.black, FontWeight.normal),
                          ],
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Column(
                          children: <Widget>[
                            buildSubLabelText(
                                'Rating', 12.0, Colors.grey, FontWeight.normal),
                            buildLabelText(
                                '${widget.totalRating.toStringAsFixed(2)}',
                                14.0,
                                Colors.black,
                                FontWeight.normal),
                          ],
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget worksContainer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildSubLabelText('Photos', 18.0, Colors.grey, FontWeight.bold),
            ],
          ),
          separator(10),
          Expanded(
              child: StreamProvider<List<Photos>>.value(
            value: ProfileDatabase(uid: widget.freelancer.uid).photos,
            child: FPhotosList(
              uid: widget.freelancer.uid,
            ),
          ))
        ],
      ),
    );
  }

  void viewProfilePic(String url) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              child: SizedBox(
                height: getMediaQueryHeightViaDivision(context, 2),
                width: getMediaQueryHeightViaDivision(context, 1),
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (context, exception, stacktrace) {
                    return Icon(
                      Icons.image_not_supported,
                      size: 35,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            ),
          );
        });
  }
}
