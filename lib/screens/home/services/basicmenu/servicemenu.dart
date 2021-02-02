import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugoapp/models/posts.dart';
import 'package:sugoapp/screens/home/services/basicmenu/currentlist.dart';
import 'package:sugoapp/screens/home/services/basicmenu/requesttile.dart';
import 'package:sugoapp/screens/home/services/current/currentservice.dart';

import 'package:sugoapp/services/servicesdatabase.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';

class ServiceMenu extends StatefulWidget {
  final String uid;
  ServiceMenu({this.uid});
  @override
  _ServiceMenuState createState() => _ServiceMenuState();
}

class _ServiceMenuState extends State<ServiceMenu> {
  @override
  Widget build(BuildContext context) {
    var post = Provider.of<List<Post>>(context) ?? [];

    int ongoingCount() {
      int temp = 0;
      for (int i = 0; i < post.length; i++) {
        if (post[i].status == 'on going' && post[i].userid == widget.uid) {
          temp++;
        }
      }
      return temp;
    }

    return SafeArea(
        child: Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ongoingCount() > 0
          ? InkWell(
              onTap: () {
                print('show on going');
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => CurrentService(
                              status: 'on going',
                            )));
              },
              child: onGoingTile(count: '${ongoingCount()}'))
          : null,
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: RequestButtonTile(),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: listheader(),
          ),
          Expanded(
              child: StreamProvider<List<Post>>.value(
                  value: ServicesDatabase(uid: widget.uid).posts,
                  child: CurrentList(
                    uid: widget.uid,
                  )))
        ],
      ),
    ));
  }

  Widget onGoingTile({String count}) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Row(
          children: [
            buildLabelText(count, 22.0, Colors.black87, FontWeight.bold),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: buildLabelText(
                  'On going errands', 16.0, Colors.black87, FontWeight.normal),
            ),
            Icon(
              Icons.keyboard_arrow_up,
              color: Colors.black87,
              size: 30,
            )
          ],
        ),
      ),
      height: getMediaQueryHeightViaDivision(context, 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black, blurRadius: 1.5, spreadRadius: 0.0)
        ],
        color: Colors.white,
      ),
    );
  }

  Widget listheader() {
    return Row(
      children: [
        Expanded(
          child: buildLabelText(
              'Current errands', 18.0, Colors.black, FontWeight.bold),
        ),
        InkWell(
          onTap: () {
            print('view all');
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => CurrentService(
                          status: 'posted',
                        )));
          },
          child: buildSubLabelText(
              'view all', 12.0, Colors.grey, FontWeight.normal),
        )
      ],
    );
  }
}
