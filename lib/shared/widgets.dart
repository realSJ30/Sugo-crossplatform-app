import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sugoapp/config/config.dart';
import 'package:sugoapp/services/auth.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/services/database.dart';

Widget separator(double x) {
  return SizedBox(
    height: x,
  );
}

Widget buildLabelText(String text, double size, Color color, FontWeight font,
    {TextAlign align}) {
  return Text(
    '$text',
    style: TextStyle(
      fontFamily: 'Century Gothic',
      fontSize: size + 3.0,
      color: color,
      fontWeight: font,
    ),
    textAlign: align,
  );
}

Widget buildLabelTextRegular(String text, double size, Color color) {
  return Text(
    '$text',
    style: TextStyle(
        fontFamily: 'Roboto Regular', fontSize: size + 3.0, color: color),
  );
}

Widget buildSubLabelText(
    String text, double size, Color color, FontWeight font) {
  return Text(
    '$text',
    style: TextStyle(
        fontFamily: 'BebasNeue Regular',
        fontSize: size + 3.0,
        color: color,
        fontWeight: font),
  );
}

Widget minilogo(BuildContext context) {
  return Stack(
    children: <Widget>[
      ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.0),
        ),
        child: Container(
          height: 200.0,
          decoration: BoxDecoration(
            color: Color(0xFF2DBDDB),
          ),
        ),
      ),
      ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40.0),
        ),
        child: Container(
          height: 180.0,
          decoration: BoxDecoration(
            color: Color(0xFF306EFF),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'images/logo/logo.png',
                  fit: BoxFit.fill,
                  width: getMediaQueryWidthViaDivision(context, 2.5),
                ),
                // buildSubLabelText('SUGO', 40.0, Colors.white, FontWeight.bold),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

Widget biglogo() {
  return Stack(
    children: <Widget>[
      ClipRRect(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(160.0),
            bottomRight: Radius.circular(160.0)),
        child: Container(
          height: 500.0,
          decoration: BoxDecoration(
            color: Color(0xFF2DBDDB),
          ),
        ),
      ),
      ClipRRect(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(180.0),
            bottomRight: Radius.circular(180.0)),
        child: Container(
          height: 480.0,
          decoration: BoxDecoration(
            color: Color(0xFF306EFF),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildSubLabelText('SUGO', 80.0, Colors.white, FontWeight.bold),
                buildLabelText('Running errands for you.', 12.0, Colors.white,
                    FontWeight.normal)
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

Widget buttonPop(BuildContext context, int dividedSize, Text text) {
  return ButtonTheme(
    height: 50.0,
    child: FlatButton(
      onPressed: () {
        Navigator.pop(context);
      },
      splashColor: secondaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      child: text,
    ),
  );
}

//dungagan pag function sa parameter for condition(validator) sa bawat pages kng puede naba munext or dli
Widget buttonNext(
    BuildContext context, double minuSize, Text text, Function goNextPage) {
  return ButtonTheme(
    minWidth: getMediaQueryWidthViaMinus(context, minuSize),
    height: 50.0,
    child: RaisedButton(
        onPressed: () async {
          // ignore: unnecessary_statements
          goNextPage();
          printUserProfile();
        },
        color: primaryColor,
        splashColor: secondaryColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: text),
  );
}

cancelButton(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: InkWell(
      child: buildLabelText('CANCEL', 13.0, Colors.grey, FontWeight.normal),
      onTap: () {
        AuthService _auth = new AuthService();
        // _auth.signOut();
        DatabaseService()
            .deleteCurrentUserTypeCollection(); //wala ka nag specify ug uid mao d madelete
        _auth.deleteUserFromCancel().then((value) => print(value.toString()));

        print('cancel');
        // Navigator.popUntil(context, (route) => route.isFirst);
      },
    ),
  );
}

Widget appBar(String title, {TabBar tabBar, List<Widget> actions}) {
  return AppBar(
      backgroundColor: primaryColor,
      title: buildLabelText(title, 18.0, Colors.white, FontWeight.bold),
      centerTitle: true,
      elevation: 0.1,
      bottom: tabBar,
      actions: actions);
}

Widget loadingWidget() {
  return Container(
    color: Colors.white,
    child: Center(
      child: SpinKitFadingCircle(
        color: primaryColor,
        size: 50.0,
      ),
    ),
  );
}

void showSnack(
  BuildContext context,
  String msg,
) {
  final scaffold = Scaffold.of(context);
  scaffold.showSnackBar(SnackBar(
    duration: Duration(milliseconds: 800),
    content: buildLabelText(msg, 12.0, Colors.white, FontWeight.normal),
    backgroundColor: Colors.green[300],
  ));
}

void showPutaSnack(
  GlobalKey<ScaffoldState> scaff,
  String msg,
) {
  scaff.currentState.showSnackBar(SnackBar(
    duration: Duration(milliseconds: 800),
    content: buildLabelText(msg, 12.0, Colors.white, FontWeight.normal),
    backgroundColor: Colors.red[400],
  ));
}

void showOkaySnack(
  GlobalKey<ScaffoldState> scaff,
  String msg,
) {
  scaff.currentState.showSnackBar(SnackBar(
    duration: Duration(milliseconds: 800),
    content: buildLabelText(msg, 12.0, Colors.white, FontWeight.normal),
    backgroundColor: Colors.green[300],
  ));
}

void showWarningSnack(
  BuildContext context,
  String msg,
) {
  final scaffold = Scaffold.of(context);
  scaffold.showSnackBar(SnackBar(
    duration: Duration(milliseconds: 800),
    content: buildLabelText(msg, 12.0, Colors.white, FontWeight.normal),
    backgroundColor: Colors.red[400],
  ));
}
