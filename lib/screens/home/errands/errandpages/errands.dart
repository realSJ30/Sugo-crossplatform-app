import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugoapp/models/posts.dart';
import 'package:sugoapp/screens/home/errands/errandpages/all/allList.dart';
import 'package:sugoapp/screens/home/errands/errandpages/categories.dart';
import 'package:sugoapp/screens/home/errands/errandpages/freelancerhome/freelancehome.dart';
import 'package:sugoapp/screens/home/errands/errandpages/freelancerhome/history/history.dart';
import 'package:sugoapp/screens/home/errands/errandpages/nearby/nearbylist.dart';
import 'package:sugoapp/screens/home/errands/errandpages/works/worklist.dart';
import 'package:sugoapp/services/auth.dart';
import 'package:sugoapp/services/servicesdatabase.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';

class Errands extends StatefulWidget {
  @override
  _ErrandsState createState() => _ErrandsState();
}

class _ErrandsState extends State<Errands> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserID(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Padding(
            padding: EdgeInsets.only(
                top: getMediaQueryHeightViaDivision(context, 3)),
            child: loadingWidget(),
          );
        }
        return StreamProvider<List<Post>>.value(
          value: ServicesDatabase(uid: snapshot.data).posts,
          child: SafeArea(
            child: DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  title: buildLabelText(
                      _currentIndex == 0
                          ? 'Home'
                          : _currentIndex == 1
                              ? 'Available Errands'
                              : 'My Works',
                      18.0,
                      Colors.white,
                      FontWeight.bold),
                  backgroundColor: primaryColor,
                  centerTitle: true,
                  elevation: 0.1,
                  bottom: _currentIndex == 1 ? errandTabs() : null,
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          print('History');
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => History(
                                        uid: snapshot.data,
                                      )));
                        },
                        child: Container(
                          child: Icon(
                            Icons.history,
                            size: 30.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                body: _currentIndex == 0
                    ? FreelanceHome(
                        uid: snapshot.data,
                      )
                    : _currentIndex == 1
                        ? TabBarView(children: <Widget>[
                            NearbyList(
                              uid: snapshot.data,
                            ),
                            AllList(
                              uid: snapshot.data,
                            )
                          ])
                        : WorkList(
                            uid: snapshot.data,
                          ),
                bottomNavigationBar: bottomAppBar2(),
              ),
            ),
          ),
        );
      },
    );
  }

  Future getUserID() async {
    AuthService _auth = new AuthService();
    fb_auth.User user = await _auth.getCurrentUser();
    return user.uid;
  }

  Widget bottomAppBar2() {
    return Row(
      children: <Widget>[
        navBarItem(
          Icons.home,
          'Home',
          0,
        ),
        navBarItem(
          Icons.location_searching,
          'Find',
          1,
        ),
        navBarItem(
          Icons.work,
          'Works',
          2,
        ),
      ],
    );
  }

  void changePage(int index) {
    setState(() {
      this._currentIndex = index;
    });
  }

  Widget navBarItem(IconData icon, String label, int index) {
    return InkWell(
      onTap: () {
        changePage(index);
      },
      child: Container(
        height: 60,
        width: getMediaQueryWidthViaDivision(
            context, 3), //kng pila ka item mao pd idivide
        decoration: _currentIndex == index
            ? BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 2.0, color: primaryColor),
                    top: BorderSide(color: Colors.grey, width: 0.2)),
              )
            : BoxDecoration(
                color: Colors.white,
                border:
                    Border(top: BorderSide(color: Colors.grey, width: 0.2))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 25.0,
              color: _currentIndex == index ? primaryColor : Colors.grey[400],
            ),
            buildSubLabelText(
                label,
                12.0,
                _currentIndex == index ? primaryColor : Colors.grey[400],
                FontWeight.normal)
          ],
        ),
      ),
    );
  }
}
