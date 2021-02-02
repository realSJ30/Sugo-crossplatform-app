import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugoapp/models/logs.dart';
import 'package:sugoapp/screens/home/logs/logtile.dart';
import 'package:sugoapp/shared/widgets.dart';

class LogsList extends StatefulWidget {
  final String uid;
  LogsList({this.uid});
  @override
  _LogsListState createState() => _LogsListState();
}

class _LogsListState extends State<LogsList> {
  var logs;
  @override
  Widget build(BuildContext context) {
    logs = Provider.of<List<Logs>>(context) ?? [];

    return logs.length > 0
        ? RefreshIndicator(
            onRefresh: refreshList,
            child: ListView.builder(
              itemCount: logs.length,
              // ignore: missing_return
              itemBuilder: (context, index) {
                return LogTile(
                  logs: logs[index],
                );
              },
            ),
          )
        : Container(
            child: Center(
              child: buildLabelText(
                  'No logs yet.', 14.0, Colors.grey, FontWeight.normal),
            ),
          );
  }

  Future refreshList() async {
    await Future.delayed(Duration(seconds: 1));
    this.setState(() {
      logs = Provider.of<List<Logs>>(context) ?? [];
    });
    return null;
  }
}
