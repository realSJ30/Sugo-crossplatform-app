import 'package:flutter/material.dart';
import 'package:sugoapp/config/config.dart';
import 'package:sugoapp/screens/authenticate/register/register.dart';
import 'package:sugoapp/screens/authenticate/register/emailinformation.dart';

import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';

class BirthdayGender extends StatefulWidget {
  @override
  _BirthdayGenderState createState() => _BirthdayGenderState();
}

class _BirthdayGenderState extends State<BirthdayGender> {
  List<String> list = ['Male', 'Female'];
  int selectedIndex = 0;

  void changeIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void setValues() {
    updateUserConfig('gender', list[selectedIndex]);
  }

  void goNextPage() async {
    setValues();
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (context) => Register(EmailInformation())));
  }

  @override
  void initState() {
    if (getUserConfig('gender') == 'Male') {
      changeIndex(0);
    } else {
      changeIndex(1);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 12,
                  left: MediaQuery.of(context).size.width / 12),
              child: buildSubLabelText(
                  'Your Gender', 28.0, primaryColor, FontWeight.normal),
            ),
          ),
          separator(10.0),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 12,
                  left: MediaQuery.of(context).size.width / 12),
              child: buildSubLabelText(
                  'Gender', 14.0, Colors.grey, FontWeight.normal),
            ),
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                    top: 10.0, left: MediaQuery.of(context).size.width / 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    customRadio(list[0], 0),
                    customRadio(list[1], 1),
                  ],
                ),
              )),
          Expanded(child: Container()),
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buttonPop(
                      context,
                      50,
                      buildLabelText(
                          'BACK', 12.0, primaryColor, FontWeight.normal)),
                  buttonNext(
                      context,
                      140,
                      buildLabelText(
                          'NEXT STEP', 14.0, Colors.white, FontWeight.normal),
                      goNextPage),
                ],
              ),
              cancelButton(context)
            ],
          )
        ],
      ),
    );
  }

  //

  Widget customRadio(String txt, int index) {
    return OutlineButton(
        onPressed: () {
          changeIndex(index);
          setValues();
        },
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        borderSide: BorderSide(
            width: selectedIndex == index ? 2 : 1,
            color: selectedIndex == index
                ? txt == 'Male'
                    ? primaryColor
                    : Colors.pink
                : Colors.grey),
        child: buildLabelText(
            txt,
            selectedIndex == index ? 14.0 : 12.0,
            selectedIndex == index
                ? txt == 'Male'
                    ? primaryColor
                    : Colors.pink
                : Colors.grey,
            selectedIndex == index ? FontWeight.bold : FontWeight.normal));
  }
}
