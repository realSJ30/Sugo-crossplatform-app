import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugoapp/models/logs.dart';
import 'package:sugoapp/screens/home/logs/logslist.dart';
import 'package:sugoapp/services/profiledatabase.dart';
import 'package:sugoapp/shared/widgets.dart';

class ActivityLogs extends StatefulWidget {
  final String uid;
  ActivityLogs({this.uid});

  @override
  _LogsState createState() => _LogsState();
}

class _LogsState extends State<ActivityLogs> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar('Logs'),
        body: StreamProvider<List<Logs>>.value(
            value: ProfileDatabase(uid: widget.uid).logs,
            child: LogsList(
              uid: widget.uid,
            )),
      ),
    );
  }
}
