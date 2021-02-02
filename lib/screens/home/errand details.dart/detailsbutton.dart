import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sugoapp/models/posts.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';

class DetailsButton extends StatelessWidget {
  final VoidCallback callback;
  DetailsButton({this.callback});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      splashColor: Colors.blue[100],
      child: Container(
          height: getMediaQueryHeightViaDivision(context, 12),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.black, blurRadius: 1.0, spreadRadius: 0.0)
            ],
            color: primaryColor,
          ),
          child: Center(
            child: buildLabelText(
                'View Notes', 18.0, Colors.white, FontWeight.normal),
          )),
    );
  }
}
