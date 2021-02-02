import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sugoapp/services/auth.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';

class ForgotPassword extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaff;
  ForgotPassword({this.scaff});
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  AuthService _auth = new AuthService();
  final formkey = GlobalKey<FormState>();

  TextEditingController emailcontroller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: buildLabelText(
                  'Enter your email', 18.0, Colors.black, FontWeight.normal),
            ),
            separator(10),
            Form(
                key: formkey,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailcontroller,
                  validator: (val) {
                    if (val.isEmpty) {
                      return "Enter valid email!";
                    } else if (!val.contains('@')) {
                      return "Enter valid email!";
                    } else {
                      return null;
                    }
                  },
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Enter email',
                      prefixIcon: Icon(Icons.alternate_email)),
                )),
            Expanded(child: Container()),
            Row(
              children: [
                Expanded(child: passResetButton()),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget passResetButton() {
    return Builder(
      builder: (contxt) {
        return ButtonTheme(
          height: getMediaQueryHeightViaDivision(context, 15),
          child: RaisedButton(
            onPressed: () {
              if (formkey.currentState.validate()) {
                print('send');
                _auth
                    .resetPassword(
                        email: emailcontroller.text, scaff: widget.scaff)
                    .whenComplete(() => Navigator.pop(context));
              }
            },
            color: primaryColor,
            splashColor: secondaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            child: buildLabelText(
                'Send Password Reset', 14.0, Colors.white, FontWeight.bold),
          ),
        );
      },
    );
  }
}
