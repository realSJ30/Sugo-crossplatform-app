import 'package:flutter/material.dart';
import 'package:sugoapp/config/config.dart';

import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';

class UserType extends StatefulWidget {
  @override
  _UserTypeState createState() => _UserTypeState();
}

class _UserTypeState extends State<UserType> {
  String _usertype = '';
  List<String> list = ['NOVICE', 'ADVANCE'];
  int selectedIndex = 0;

  Widget bottom() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buttonPop(context, 50,
                buildLabelText('BACK', 12.0, primaryColor, FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: buttonNext(
                  context,
                  140,
                  buildLabelText(
                      'NEXT STEP', 14, Colors.white, FontWeight.normal),
                  setValue),
            ),
          ],
        ),
        cancelButton(context)
      ],
    );
  }

  //sets the value of the userprofile json file...
  void setValue() async {
    // updateUserConfig('usertype', this._usertype);
    // Navigator.of(context)
    //     .push(new MaterialPageRoute(builder: (context) => Register(Step1())));
  }

  @override
  void initState() {
    //conditions the displayed value according to the json file para pag mag navigate
    //pabalik og padulong dli magrefresh ang padulong, instead mstore tng prev na giinput.
    if (getUserConfig('usertype').isEmpty) {
      _usertype = list[selectedIndex];
    } else {
      _usertype = getUserConfig('usertype');
    }

    super.initState();
  }

  void changeIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
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
              child: buildSubLabelText('What type of user \nare you?', 28.0,
                  primaryColor, FontWeight.normal),
            ),
          ),
          _buildToggleButton(list[0], 0),
          _buildToggleButton(list[1], 1),
          // separator(getMediaQueryHeightViaDivision(context, 26)),
          Padding(
            padding: EdgeInsets.only(
                top: getMediaQueryHeightViaDivision(context, 25.0), bottom: 20),
            child: bottom(),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String labelText, int index) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ButtonTheme(
        minWidth: MediaQuery.of(context).size.width - 30,
        height: MediaQuery.of(context).size.height / 4,
        child: OutlineButton(
          color: Colors.blue,
          onPressed: () {
            labelText == list[0]
                ? _usertype = list[0] //NOVICE
                : _usertype = list[1]; //ADVANCE
            changeIndex(index);
          },
          splashColor: secondaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          borderSide: BorderSide(
              width: selectedIndex == index ? 3.0 : 1.0,
              color: selectedIndex == index ? primaryColor : Colors.grey),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: labelText == list[0]
                      ? Image.asset(
                          'images/icons/novice.png',
                          width: 80.0,
                        )
                      : Image.asset(
                          'images/icons/multitasker.png',
                          width: 80.0,
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: buildSubLabelText(
                      labelText,
                      28,
                      selectedIndex == index ? primaryColor : Colors.grey,
                      FontWeight.normal),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 120.0, top: 40.0),
                child: labelText == list[0]
                    ? buildLabelText(
                        'Recommended for\nelderlies. Post errands',
                        12.0,
                        selectedIndex == index ? primaryColor : Colors.grey,
                        FontWeight.normal)
                    : buildLabelText(
                        'Recommended for\nmost users. Do errands and\npost errands.',
                        12.0,
                        selectedIndex == index ? primaryColor : Colors.grey,
                        FontWeight.normal),
              )
            ],
          ),
        ),
      ),
    );
  }
}
