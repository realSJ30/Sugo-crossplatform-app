import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugoapp/screens/home/profile/photostab/photosTab.dart';
import 'package:sugoapp/screens/home/profile/profiletab/profileTab.dart';
import 'package:sugoapp/services/auth.dart';
import 'package:sugoapp/services/database.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  AuthService _auth = new AuthService();

  void showAboutUs() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildSubLabelText(
                      'About us', 16.0, Colors.black, FontWeight.normal),
                ),
                ListTile(
                  title: buildLabelText(
                      'Sugo App is an application for running errands, and providing opportunities for people who want to earn by doing errands for others.\n'
                      'Sugo App is developed by Sugo boys who are IT professionals who are inspired by the essence of a START UP.',
                      10.0,
                      Colors.black,
                      FontWeight.normal,
                      align: TextAlign.center),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: buildSubLabelText(
                      'The team', 16.0, Colors.black, FontWeight.normal),
                ),
                ListTile(
                  leading: Icon(Icons.code),
                  title: buildLabelText(
                    'Seth Joshua Moraga',
                    14.0,
                    Colors.black,
                    FontWeight.normal,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.web),
                  title: buildLabelText(
                    'Clement Narciso',
                    14.0,
                    Colors.black,
                    FontWeight.normal,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.notes),
                  title: buildLabelText(
                    'Jay Catadman',
                    14.0,
                    Colors.black,
                    FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getsUserId(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Padding(
              padding: EdgeInsets.only(
                  top: getMediaQueryHeightViaDivision(context, 3)),
              child: loadingWidget(),
            );
          }
          print(snapshot.data);
          return StreamProvider<DocumentSnapshot>.value(
            value: DatabaseService(uid: snapshot.data).userprofile,
            child: SafeArea(
              child: DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: appBar('Profile', tabBar: tabBar(), actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          this.showAboutUs();
                        },
                        child: Container(
                            child: Row(
                          children: <Widget>[
                            buildSubLabelText('About us', 12.0, Colors.white,
                                FontWeight.normal),
                            Icon(
                              Icons.info_outline,
                              size: 20.0,
                              color: Colors.white,
                            ),
                          ],
                        )),
                      ),
                    ),
                  ]),
                  body: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      ProfileTab(
                        uid: snapshot.data,
                      ),
                      PhotosTab(
                        uid: snapshot.data,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget tabBar() {
    return TabBar(
        onTap: (value) {
          print(value);
        },
        labelColor: Colors.white,
        labelStyle: TextStyle(fontFamily: secondaryFont, fontSize: 16.0),
        indicatorColor: secondaryColor,
        indicatorWeight: 3,
        tabs: <Widget>[
          Tab(
            text: 'Account',
          ),
          Tab(
            text: 'Photos',
          )
        ]);
  }

  Future getsUserId() async {
    final fb_auth.User user = await _auth.getCurrentUser();
    return user.uid;
  }
}
