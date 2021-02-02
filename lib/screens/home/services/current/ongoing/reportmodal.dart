import 'package:flutter/material.dart';
import 'package:sugoapp/services/profiledatabase.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';

class ReportModal extends StatefulWidget {
  final String postID;
  final String userID; //ang ireport na user ID
  ReportModal({this.postID, this.userID});
  @override
  _ReportModalState createState() => _ReportModalState();
}

class _ReportModalState extends State<ReportModal> {
  TextEditingController textController = new TextEditingController();
  int _index = 0;
  String subject = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getMediaQueryHeightViaDivision(context, 1.3),
      child: Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildLabelText(
                  'Report', 16.0, Colors.red[900], FontWeight.bold),
            ),
          ),
          Divider(
            thickness: 0.5,
            color: Colors.black,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: buildLabelText('Please select a problem below', 14.0,
                    Colors.black, FontWeight.normal),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: buildLabelText(
                    'You can report the person after selecting\na problem.',
                    12.0,
                    Colors.grey,
                    FontWeight.normal),
              ),
            ],
          ),
          separator(5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              reportSubjectsButton(
                  subject: 'Violence',
                  index: 1,
                  callback: () {
                    setState(() {
                      this._index = 1;
                      this.subject = 'Violence';
                    });
                  }),
              reportSubjectsButton(
                  subject: 'Harrassment',
                  index: 2,
                  callback: () {
                    setState(() {
                      this._index = 2;
                      this.subject = 'Harrassment';
                    });
                  }),
              reportSubjectsButton(
                  subject: 'Scam/ Bogus',
                  index: 3,
                  callback: () {
                    setState(() {
                      this._index = 3;
                      this.subject = 'Scam/ Bogus';
                    });
                  })
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: buildLabelText(
                    'Additional options', 12.0, Colors.grey, FontWeight.normal),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: this.textController,
              decoration:
                  textInputDecoration.copyWith(hintText: 'Leave a message'),
            ),
          ),
          Expanded(child: SizedBox()),
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: reportButton(),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget reportSubjectsButton(
      {String subject, VoidCallback callback, int index}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: callback,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.red[_index == index ? 900 : 200]),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child:
                buildLabelText(subject, 14.0, Colors.white, FontWeight.normal),
          ),
        ),
      ),
    );
  }

  Widget reportButton() {
    return ButtonTheme(
      child: RaisedButton(
          onPressed: _index == 0
              ? null
              : () async {
                  // ignore: unnecessary_statements
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: buildLabelText('Confirm action', 14.0,
                                Colors.black, FontWeight.normal),
                            actions: [
                              FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: buildLabelText('Cancel', 14.0,
                                      Colors.grey, FontWeight.normal)),
                              FlatButton(
                                  onPressed: () async {
                                    await ProfileDatabase().reportUser(
                                        userID: widget.userID,
                                        msg: this.textController.text,
                                        postID: widget.postID,
                                        subject: this.subject);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: buildLabelText('Confirm', 14.0,
                                      Colors.black, FontWeight.normal)),
                            ],
                          ));
                },
          color: Colors.red[900],
          splashColor: Colors.red,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child:
              buildLabelText('Submit', 14.0, Colors.white, FontWeight.normal)),
    );
  }
}
