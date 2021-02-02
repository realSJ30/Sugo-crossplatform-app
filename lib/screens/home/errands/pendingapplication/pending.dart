import 'package:flutter/material.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';

class Pending extends StatefulWidget {
  @override
  _PendingState createState() => _PendingState();
}

class _PendingState extends State<Pending> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar('Freelancer'),
        body: Container(
          color: primaryColor,
          child: Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                separator(20.0),
                                buildLabelText('Pending application', 30.0,
                                    primaryColor, FontWeight.bold),
                                buildLabelText(
                                    'You have already submitted your requirements and our team is already reviewing it, please be patient for our response. Thank you!',
                                    14.0,
                                    Colors.grey,
                                    FontWeight.normal,
                                    align: TextAlign.justify),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
