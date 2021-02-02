import 'package:flutter/material.dart';
import 'package:sugoapp/screens/authenticate/help/contactus.dart';
import 'package:sugoapp/screens/authenticate/help/forgotpassword.dart';
import 'package:sugoapp/shared/widgets.dart';

class Help extends StatefulWidget {
  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  final scaff = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaff,
        appBar: appBar('Sign in Help'),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  print('forgot pass');
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return ForgotPassword(
                          scaff: this.scaff,
                        );
                      });
                },
                child: ListTile(
                  tileColor: Colors.blue[100],
                  title: buildLabelText(
                      'Forgot Password', 14.0, Colors.black, FontWeight.normal),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  print('others');

                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return ContactUs();
                      });
                },
                child: ListTile(
                  tileColor: Colors.blue[100],
                  title: buildLabelText(
                      'Contact Us', 14.0, Colors.black, FontWeight.normal),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
