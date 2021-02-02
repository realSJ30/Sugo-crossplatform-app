import 'package:flutter/material.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';
import 'package:sugoapp/screens/home/errands/freelanceapplication/freelancerapplication.dart';

class ErrandCard extends StatefulWidget {
  @override
  _ErrandCardState createState() => _ErrandCardState();
}

class _ErrandCardState extends State<ErrandCard> {
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
                        separator(10),
                        imageContainer(),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                buildLabelText('Be a Freelancer', 30.0,
                                    primaryColor, FontWeight.bold),
                                buildLabelText(
                                    'Welcome to your work page. Apply to us to become a freelancer wherein you can earn extra money by giving services and doing errands to other people. Work freely anytime and anywhere you want.',
                                    14.0,
                                    Colors.grey,
                                    FontWeight.normal,
                                    align: TextAlign.justify),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: letsgetStartedButton()),
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

  Widget imageContainer() {
    return Container(
      child: Image.asset(
        'images/icons/Current Services A.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget letsgetStartedButton() {
    return ButtonTheme(
      minWidth: getMediaQueryWidthViaDivision(context, 2.5),
      child: RaisedButton(
          onPressed: () async {
            // ignore: unnecessary_statements
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => FreelanceApplication()));
          },
          color: primaryColor,
          splashColor: secondaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: buildSubLabelText(
                'Apply now', 18.0, Colors.white, FontWeight.normal),
          )),
    );
  }
}
