import 'package:flutter/material.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';

class DefaultButton extends StatelessWidget {
  final VoidCallback callback;
  final String label;
  DefaultButton({this.callback, this.label});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      child: RaisedButton(
          onPressed: callback,
          color: primaryColor,
          splashColor: secondaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: buildLabelText(label, 16, Colors.white, FontWeight.bold)),
    );
  }
}
