import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugoapp/models/finisherrands.dart';
import 'package:sugoapp/screens/home/errands/errandpages/freelancerhome/history/historyList.dart';
import 'package:sugoapp/services/profiledatabase.dart';
import 'package:sugoapp/shared/widgets.dart';

class History extends StatefulWidget {
  final String uid;
  History({this.uid});
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: appBar('History'),
      body: StreamProvider<List<FinishedErrands>>.value(
        value: ProfileDatabase(uid: widget.uid).totalErrands,
        child: HistoryList(
          uid: widget.uid,
        ),
      ),
    ));
  }
}
