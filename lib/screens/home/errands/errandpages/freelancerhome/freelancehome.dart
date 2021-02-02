import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugoapp/models/finisherrands.dart';
import 'package:sugoapp/models/posts.dart';
import 'package:sugoapp/screens/home/errands/errandpages/freelancerhome/frequestedlist.dart';
import 'package:sugoapp/screens/home/errands/errandpages/freelancerhome/infoTile.dart';
import 'package:sugoapp/services/profiledatabase.dart';
import 'package:sugoapp/services/servicesdatabase.dart';
import 'package:sugoapp/shared/widgets.dart';

class FreelanceHome extends StatefulWidget {
  final String uid;
  FreelanceHome({this.uid});
  @override
  _FreelanceHomeState createState() => _FreelanceHomeState();
}

class _FreelanceHomeState extends State<FreelanceHome> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: StreamProvider<List<FinishedErrands>>.value(
                        value: ProfileDatabase(uid: widget.uid)
                            .totalErrandsAsofToday,
                        child: InfoTile(
                          uid: widget.uid,
                        )))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: listheader(),
          ),
          Expanded(
            child: StreamProvider<List<Post>>.value(
                value: ServicesDatabase(uid: widget.uid).posts,
                child: FRequestedList(
                  uid: widget.uid,
                )),
          )
        ],
      ),
    );
  }

  Widget listheader() {
    return Row(
      children: [
        Expanded(
          child: buildLabelText(
              'Waiting errands', 18.0, Colors.black, FontWeight.bold),
        ),
        InkWell(
          onTap: () {
            print('view all');
            // Navigator.push(
            //     context,
            //     new MaterialPageRoute(
            //         builder: (context) => CurrentService(
            //               status: 'posted',
            //             )));
          },
          child: buildSubLabelText(
              'view all', 12.0, Colors.grey, FontWeight.normal),
        )
      ],
    );
  }
}
