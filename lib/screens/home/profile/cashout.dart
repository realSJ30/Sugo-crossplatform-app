import 'package:flutter/material.dart';
import 'package:sugoapp/services/auth.dart';
import 'package:sugoapp/services/profiledatabase.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';

class CashOut extends StatefulWidget {
  final double sugoCoins;
  final String uid;
  CashOut({this.sugoCoins, this.uid});

  @override
  _CashOutState createState() => _CashOutState();
}

class _CashOutState extends State<CashOut> {
  AuthService _auth = new AuthService();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _amountController = new TextEditingController();
  double finalAmount = 0;

  void verifyAmount() async {
    if (_formKey.currentState.validate()) {
      this.setState(() {
        this.finalAmount = double.parse(_amountController.text.toString());
      });
      cashout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getMediaQueryHeightViaDivision(context, 1.3),
      child: Column(
        children: [
          buildSubLabelText('Cash out', 18.0, Colors.black, FontWeight.normal),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: buildSubLabelText(
                      'Sugo coins:', 14.0, Colors.grey, FontWeight.normal),
                ),
                buildLabelText(
                    '${widget.sugoCoins}', 18.0, Colors.black, FontWeight.bold),
              ],
            ),
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                textAlign: TextAlign.end,
                controller: this._amountController,
                validator: (val) {
                  if (val.isEmpty) {
                    return "Enter amount!";
                  } else if (double.parse(val) < 1) {
                    return "Invalid amount!";
                  } else if (double.parse(val) > widget.sugoCoins) {
                    return "Invalid amount!";
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.number,
                decoration: textInputDecoration.copyWith(hintText: '0.00'),
              ),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: ButtonTheme(
                    child: RaisedButton(
                        onPressed: () async {
                          verifyAmount();
                        },
                        color: Colors.blue,
                        splashColor: secondaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: buildSubLabelText(
                            'Cash out', 16.0, Colors.black, FontWeight.normal)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void cashout() async {
    print('cashout successfully');
    await ProfileDatabase(uid: widget.uid)
        .cashoutRequest(amount: this.finalAmount, status: 'pending')
        .whenComplete(() {
      Navigator.pop(context);
      showDialog(
          context: this.context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildLabelText('Cash out Request Sent', 16.0, primaryColor,
                      FontWeight.normal),
                  buildLabelText(
                      'Details:', 12.0, Colors.grey, FontWeight.normal),
                  separator(10),
                  Row(
                    children: [
                      Expanded(
                        child: buildSubLabelText(
                            'Amount:', 12.0, Colors.black, FontWeight.normal),
                      ),
                      buildLabelText('PHP ${this.finalAmount}', 14.0,
                          Colors.grey, FontWeight.normal),
                    ],
                  )
                ],
              ),
              actions: <Widget>[
                FlatButton(
                    // ignore: missing_return
                    onPressed: () async {
                      //remove data to cloud
                      Navigator.pop(context);
                    },
                    child: buildLabelText(
                        'Proceed', 14.0, primaryColor, FontWeight.normal)),
              ],
            );
          });
    });
    //after iminus nya sa credits...
    await ProfileDatabase(uid: widget.uid)
        .minusCredits(minusvalue: this.finalAmount, oldvalue: widget.sugoCoins);
  }
}
