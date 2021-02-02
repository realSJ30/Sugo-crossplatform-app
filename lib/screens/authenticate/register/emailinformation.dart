import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:sugoapp/config/config.dart';
import 'package:sugoapp/screens/wrapper.dart';
import 'package:sugoapp/services/auth.dart';
import 'package:sugoapp/services/database.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';

class EmailInformation extends StatefulWidget {
  @override
  _EmailInformationState createState() => _EmailInformationState();
}

class _EmailInformationState extends State<EmailInformation> {
  AuthService _authService = AuthService();

  bool isChecked = false;

  void finishUp() async {
    if (isChecked) {
      print('success');
      fb_auth.User user;
      await _authService.getCurrentUser().then((value) => user = value);
      DatabaseService(uid: user.uid).updateUserData(
        account: getUserConfig('usertype'),
        bday: getUserConfig('birthday'),
        contact: getUserConfig('contact'),
        email: getUserConfig('email'),
        fname: getUserConfig('firstname'),
        lname: getUserConfig('lastname'),
        mname: getUserConfig('middlename'),
        gender: getUserConfig('gender'),
        idtype: getUserConfig('idtype'),
        imgpath: getUserConfig('imagepath'),
      );
      await DatabaseService(uid: user.uid).oldUser();

      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => Wrapper()), (route) => false);
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: buildLabelText(
                  'You must agree with the terms & condition before you proceed!',
                  16.0,
                  Colors.black,
                  FontWeight.bold),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: buildLabelText(
                        'Okay', 16.0, Colors.grey, FontWeight.normal))
              ],
            );
          });
    }
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
                  'Terms & Condition', 28.0, primaryColor, FontWeight.normal),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding:
                  EdgeInsets.only(left: MediaQuery.of(context).size.width / 12),
              child: buildLabelText(
                  'We make a guidelines that you\nmust agree in order to use\nour mobile app.',
                  12.0,
                  Colors.grey,
                  FontWeight.normal),
            ),
          ),
          separator(8.0),
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 12),
                child: buttonTerms(buildLabelText(
                    'Learn more!', 12.0, Colors.white, FontWeight.normal)),
              )),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding:
                  EdgeInsets.only(left: MediaQuery.of(context).size.width / 12),
              child: Container(
                child: Row(
                  children: <Widget>[
                    Checkbox(
                        value: isChecked,
                        onChanged: (bool value) {
                          setState(() {
                            isChecked = value;
                            print('Checked!');
                          });
                        }),
                    buildLabelText('I Agree with the terms & condition', 14.0,
                        Colors.grey, FontWeight.normal)
                  ],
                ),
              ),
            ),
          ),
          Expanded(child: Container()),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
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
                            'FINISH', 14.0, Colors.white, FontWeight.normal),
                        finishUp),
                  ],
                ),
                cancelButton(context)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonTerms(Text text) {
    return ButtonTheme(
      minWidth: MediaQuery.of(context).size.width / 3,
      height: 35.0,
      child: RaisedButton(
          onPressed: () {
            // ignore: unnecessary_statements
            print('Learn more!');
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: buildSubLabelText('Terms & Condition', 18.0,
                        Colors.black87, FontWeight.normal),
                    content: SingleChildScrollView(
                      child: buildLabelText(
                          'As a condition of use, you promise not to use the Services for any purpose that is unlawful'
                          'or prohibited by these Terms, or any other purpose that is unlawful or prohibited by these '
                          'Terms, or any other purpose not reasonably intended by Sugo App. By way of example, and not '
                          'as a limitation, you agree not to use the Services:\n\n'
                          '1. To abuse, harass, threaten, impersonate or intimidate any person.\n'
                          '2. To post or transmit, or cause to be posted or transmitted, any Content that is libelouse'
                          'defamatory, obscene, pornographic, abusive, offensive, profane, or that infringes any copyright'
                          'or other right of any person\n'
                          '3. To create multiple accounts for the purpose of fraudelent activities.'
                          '4. By using the SUGO service you are entitled to set your service fee not less than the minimum'
                          'fee which is 100 Php.'
                          'Failure to comply with these terms mentioned will result to removal of account.',
                          14.0,
                          Colors.black,
                          FontWeight.normal),
                    ),
                    actions: <Widget>[
                      ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width - 50,
                        height: 35.0,
                        child: RaisedButton(
                            onPressed: () async {
                              // ignore: unnecessary_statements
                              setState(() {
                                isChecked = true;
                                Navigator.pop(context);
                              });
                            },
                            color: primaryColor,
                            splashColor: secondaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            child: buildLabelText('Agree', 14.0, Colors.white,
                                FontWeight.normal)),
                      )
                    ],
                  );
                });
          },
          color: primaryColor,
          splashColor: secondaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: text),
    );
  }
}
