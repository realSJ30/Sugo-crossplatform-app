import 'package:flutter/material.dart';
import 'package:sugoapp/models/logs.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';

class LogTile extends StatefulWidget {
  final Logs logs;
  LogTile({this.logs});
  @override
  _LogTileState createState() => _LogTileState();
}

class _LogTileState extends State<LogTile> {
  String subject = '';
  Color color;
  var date;

  void setSubject() {
    this.setState(() {
      this.date = DateTime.fromMicrosecondsSinceEpoch(
          widget.logs.timestamp.microsecondsSinceEpoch);
      if (widget.logs.subject == 'request') {
        this.subject = 'Request';
        this.color = Colors.blue;
      } else if (widget.logs.subject == 'approved') {
        this.subject = 'Approved';
        this.color = Colors.green;
      } else {
        this.subject = 'Cancelled';
        this.color = Colors.grey;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setSubject();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Container(
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: primaryColor, width: 0.4))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildLabelText(this.subject, 16.0, color, FontWeight.normal),
                buildLabelText('$date', 10.0, Colors.grey, FontWeight.normal),
              ],
            ),
            trailing: Container(
              child: buildSubLabelText('${widget.logs.amount} PHP', 20.0,
                  Colors.grey, FontWeight.normal),
            ),
          ),
        ),
      ),
    );
  }
}
