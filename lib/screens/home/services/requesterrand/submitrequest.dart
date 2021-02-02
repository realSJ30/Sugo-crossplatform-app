import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:sugoapp/screens/home/services/template.dart';
import 'package:sugoapp/services/auth.dart';
import 'package:sugoapp/services/profiledatabase.dart';
import 'package:sugoapp/services/servicesdatabase.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';

class SubmitRequest extends StatefulWidget {
  final String tags;
  final String notes;
  final String fee;
  final String paymenttype;
  final String address1;
  final String latlng;
  SubmitRequest(
      {this.tags,
      this.notes,
      this.fee,
      this.paymenttype,
      this.address1,
      this.latlng});

  @override
  _SubmitRequestState createState() => _SubmitRequestState();
}

class _SubmitRequestState extends State<SubmitRequest> {
  TextEditingController _notesController = new TextEditingController();
  TextEditingController _feeController = new TextEditingController();
  TextEditingController _paymentController = new TextEditingController();
  TextEditingController _address1Controller = new TextEditingController();
  TextEditingController _address2Controller = new TextEditingController();
  AuthService _auth = new AuthService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _notesController.text = widget.notes;
    _feeController.text = widget.fee;
    _paymentController.text = widget.paymenttype;
    _address1Controller.text = widget.address1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        'Request Errand',
      ),
      body: SingleChildScrollView(
        child: Container(
          color: primaryColor,
          child: Center(
            child: Column(
              children: <Widget>[mainContainer()],
            ),
          ),
        ),
      ),
    );
  }

  Widget mainContainer() {
    return Container(
      color: Colors.white,
      width: getMediaQueryWidthViaMinus(context, 0),
      // height: getMediaQueryHeightViaMinus(context, 30),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            buildLabelText(
                'Request Information', 10.0, Colors.grey, FontWeight.normal),
            separator(8.0),
            information(),
            amount(),
            paymentType(),
            address1(),
            address2(),
            postErrandButton()
          ],
        ),
      ),
    );
  }

  Widget typeofService(String errand, String icon) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildSubLabelText(
                  'Type of service', 12, Colors.grey, FontWeight.normal),
              ListTile(
                leading: Image.asset(
                  icon,
                  width: 30.0,
                ),
                title: buildLabelText(
                    errand, 14.0, primaryColor, FontWeight.normal),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget information() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildSubLabelText(
                  'Information/Notes', 12, Colors.grey, FontWeight.normal),
              separator(5.0),
              TextField(
                  enabled: false,
                  maxLines: null,
                  decoration: textInputDecoration.copyWith(
                      hintText: widget.notes,
                      hintStyle: TextStyle(color: Colors.black)))
            ],
          ),
        ),
      ),
    );
  }

  Widget amount() {
    return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildSubLabelText(
                    'Service fee', 12, Colors.grey, FontWeight.normal),
                separator(5.0),
                TextField(
                  enabled: false,
                  decoration: textInputDecoration.copyWith(
                      hintText: '${widget.fee} Php',
                      hintStyle: TextStyle(color: Colors.black)),
                )
              ],
            ),
          ),
        ));
  }

  Widget paymentType() {
    return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildSubLabelText(
                    'Payment type', 12, Colors.grey, FontWeight.normal),
                separator(5.0),
                TextField(
                  enabled: false,
                  decoration: textInputDecoration.copyWith(
                      hintText: widget.paymenttype,
                      hintStyle: TextStyle(color: Colors.black)),
                )
              ],
            ),
          ),
        ));
  }

  Widget address1() {
    return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildSubLabelText(
                    'Address 1', 12, Colors.grey, FontWeight.normal),
                separator(5.0),
                TextField(
                  enabled: false,
                  maxLines: 2,
                  decoration: textInputDecoration.copyWith(
                      hintText: widget.address1,
                      hintStyle: TextStyle(color: Colors.black)),
                )
              ],
            ),
          ),
        ));
  }

  Widget address2() {
    return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildSubLabelText(
                    'Specific Address', 12, Colors.grey, FontWeight.normal),
                separator(5.0),
                TextFormField(
                  maxLines: null,
                  controller: _address2Controller,
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Address 2',
                      hintStyle: TextStyle(color: Colors.black)),
                )
              ],
            ),
          ),
        ));
  }

  Widget postErrandButton() {
    return ButtonTheme(
      minWidth: MediaQuery.of(context).size.width - 30,
      height: 50.0,
      child: RaisedButton(
          onPressed: () async {
            fb_auth.User user = await _auth.getCurrentUser();
            // ignore: unnecessary_statements
            print('submit');
            if (_address2Controller.text.isEmpty) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      title: buildLabelText('Are you sure?', 12.0, primaryColor,
                          FontWeight.normal),
                      content: buildLabelText("You haven't fill up Address 2",
                          12.0, Colors.grey, FontWeight.normal),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: buildLabelText('Cancel', 14.0, Colors.black,
                                FontWeight.normal)),
                        FlatButton(
                            // ignore: missing_return
                            onPressed: () async {
                              if (_paymentController.text == 'SUGO Coins') {
                                double credits =
                                    await ProfileDatabase(uid: user.uid)
                                        .getCredits();
                                //minus coins
                                await ProfileDatabase(uid: user.uid)
                                    .minusCredits(
                                        minusvalue:
                                            double.parse(_feeController.text),
                                        oldvalue: credits);
                              }
                              //insert data to cloud
                              ServicesDatabase(uid: user.uid).postRequest(
                                userid: user.uid,
                                tags: widget.tags,
                                notes: _notesController.text,
                                fee: _feeController.text,
                                paymentType: _paymentController.text,
                                address1: _address1Controller.text,
                                address2: _address2Controller.text,
                                latlng: widget.latlng,
                                date: dateTime(),
                                status: 'posted',
                              );

                              Navigator.popUntil(
                                  context, (route) => route.isFirst);
                            },
                            child: buildLabelText('Confirm', 14.0, primaryColor,
                                FontWeight.normal)),
                      ],
                    );
                  });
            } else {
              //insert data to cloud
              if (_paymentController.text == 'SUGO Coins') {
                double credits =
                    await ProfileDatabase(uid: user.uid).getCredits();
                //minus coins
                await ProfileDatabase(uid: user.uid).minusCredits(
                    minusvalue: double.parse(_feeController.text),
                    oldvalue: credits);
              }
              ServicesDatabase(uid: user.uid).postRequest(
                userid: user.uid,
                tags: widget.tags,
                notes: _notesController.text,
                fee: _feeController.text,
                paymentType: _paymentController.text,
                address1: _address1Controller.text,
                address2: _address2Controller.text,
                latlng: widget.latlng,
                date: dateTime(),
                status: 'posted',
              );
              Navigator.popUntil(context, (route) => route.isFirst);
            }
          },
          color: primaryColor,
          splashColor: secondaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: buildLabelText('Post', 14.0, Colors.white, FontWeight.normal)),
    );
  }
}
