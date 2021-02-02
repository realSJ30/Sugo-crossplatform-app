import 'package:flutter/material.dart';
import 'package:sugoapp/services/auth.dart';
import 'package:sugoapp/services/database.dart';
import 'package:sugoapp/services/profiledatabase.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class RenewalPage extends StatefulWidget {
  @override
  _RenewalPageState createState() => _RenewalPageState();
}

class _RenewalPageState extends State<RenewalPage> {
  AuthService _auth = new AuthService();
  double renewalFee = 50.00;
  double totalFee;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: appBar('Freelancer'),
          body: FutureBuilder(
            future: getTotalCommissions(),
            builder: (cont, snapshot) {
              if (!snapshot.hasData) {
                return loadingWidget();
              }
              double comfee = double.parse(snapshot.data.toString()) * .2;
              totalFee = setTotalFee(comfee);

              return Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildSubLabelText('Account on Hold', 20.0, Colors.blue,
                          FontWeight.normal),
                      separator(10),
                      buildLabelText('Your subscription has been expired.',
                          14.0, Colors.black, FontWeight.normal),
                      Divider(),
                      buildSubLabelText(
                          'Renewal Fee', 18.0, Colors.black, FontWeight.normal),
                      renewalTileFees(
                          title: 'Overall income 5% commission',
                          subtitle: '$comfee',
                          callback: () {
                            print('show info');
                          }),
                      separator(5.0),
                      renewalTileFees(
                          title: 'Renewal fee',
                          subtitle: '$renewalFee',
                          callback: () {
                            print('show info');
                          }),
                      separator(5.0),
                      totalTileFees(title: 'Total', trailing: '$totalFee'),
                      Expanded(child: Container()),
                      Row(
                        children: [
                          Expanded(child: renewalButton(cont)),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }

  Widget renewalTileFees(
      {String title, String subtitle, VoidCallback callback}) {
    return InkWell(
      onTap: callback,
      child: Container(
        child: ListTile(
          tileColor: Colors.white60,
          title: buildLabelText(title, 12.0, Colors.grey, FontWeight.normal),
          subtitle:
              buildLabelText(subtitle, 14.0, Colors.black, FontWeight.normal),
          trailing: Icon(Icons.info_outline),
        ),
      ),
    );
  }

  Widget totalTileFees({String title, String trailing}) {
    return Container(
      child: ListTile(
        tileColor: Colors.white60,
        title: buildLabelText(title, 12.0, Colors.black, FontWeight.bold),
        trailing:
            buildLabelText(trailing, 14.0, Colors.black, FontWeight.normal),
      ),
    );
  }

  Widget renewalButton(BuildContext cont) {
    return ButtonTheme(
      child: RaisedButton(
          onPressed: () async {
            // ignore: unnecessary_statements
            print('renewed');
            fb_auth.User user = await _auth.getCurrentUser();
            double credits = await ProfileDatabase(uid: user.uid).getCredits();
            if (credits > this.totalFee) {
              //irenew na
              //minus coins
              await ProfileDatabase(uid: user.uid)
                  .minusCredits(minusvalue: this.totalFee, oldvalue: credits);
              await ProfileDatabase(uid: user.uid)
                  .updateAccount(account: 'ADVANCE');
            } else {
              showWarningSnack(cont, 'Not enough sugo coins!');
            }
          },
          color: primaryColor,
          splashColor: secondaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: buildLabelText(
              'Renew Subscription', 14.0, Colors.white, FontWeight.normal)),
    );
  }

  Future getTotalCommissions() async {
    fb_auth.User user = await _auth.getCurrentUser();
    return await DatabaseService(uid: user.uid).getTotalCommissionFee();
  }

  double setTotalFee(double fee) {
    return fee + renewalFee;
  }
}
