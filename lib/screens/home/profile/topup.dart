import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:sugoapp/screens/home/services/current/payment/paymentconfig.dart';
import 'package:sugoapp/services/auth.dart';
import 'package:sugoapp/services/paymentdatabase.dart';
import 'package:sugoapp/services/profiledatabase.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:url_launcher/url_launcher.dart';

class TopUp extends StatefulWidget {
  final double oldvalue;

  TopUp({this.oldvalue});

  @override
  _TopUpState createState() => _TopUpState();
}

class _TopUpState extends State<TopUp> {
  //default kay textfield na amount pasabot ktng textfield ang gipili dli tng mga button toggles
  int amountIndex = 7;
  String finalAmount = '';
  final _formKey = GlobalKey<FormState>();
  TextEditingController _amountController = new TextEditingController();
  AuthService _auth = new AuthService();
  bool loading = false;
  void setIndex(String amount, int index) {
    this.setState(() {
      amountIndex = index;
      finalAmount = amount;
      _formKey.currentState.reset();
    });
  }

  void setLoading(bool load) {
    this.setState(() {
      loading = load;
    });
  }

  void verifyAmount() {
    if (this.amountIndex == 7) {
      this.setState(() {
        this.finalAmount = _amountController.text;
      });
      if (_formKey.currentState.validate()) {
        print('show payment window $finalAmount');
        setLoading(true);
        pay();
      }
    } else {
      print('show payment window $finalAmount');
      setLoading(true);
      pay();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getMediaQueryHeightViaDivision(context, 1.3),
      child: LoadingOverlay(
        isLoading: loading,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildSubLabelText(
                  'Top up', 18.0, Colors.black, FontWeight.normal),
              Row(
                children: [
                  buildSubLabelText(
                      'Choose amount:', 14.0, Colors.grey, FontWeight.normal),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  amountsButton(
                      amount: '100.00',
                      callback: () {
                        this.setIndex('100.00', 1);
                      },
                      index: 1),
                  amountsButton(
                      amount: '200.00',
                      callback: () {
                        this.setIndex('200.00', 2);
                      },
                      index: 2),
                  amountsButton(
                      amount: '500.00',
                      callback: () {
                        this.setIndex('500.00', 3);
                      },
                      index: 3)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  amountsButton(
                      amount: '750.00',
                      callback: () {
                        this.setIndex('750.00', 4);
                      },
                      index: 4),
                  amountsButton(
                      amount: '1000.00',
                      callback: () {
                        this.setIndex('1000.00', 5);
                      },
                      index: 5),
                  amountsButton(
                      amount: '1500.00',
                      callback: () {
                        this.setIndex('1500.00', 6);
                      },
                      index: 6)
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    textAlign: TextAlign.end,
                    controller: this._amountController,
                    validator: (val) {
                      if (val.isEmpty) {
                        return "Enter amount!";
                      } else if (double.parse(val) < 1) {
                        return "Invalid amount!";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.number,
                    onTap: () {
                      setIndex('0', 7);
                    },
                    decoration: textInputDecoration.copyWith(hintText: '0.00'),
                  ),
                ),
              ),
              Expanded(child: Container()),
              Row(
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
                              'Top up', 16.0, Colors.black, FontWeight.normal)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget amountsButton({String amount, VoidCallback callback, int index}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: callback,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.blue[amountIndex == index ? 900 : 200]),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child:
                buildLabelText(amount, 14.0, Colors.white, FontWeight.normal),
          ),
        ),
      ),
    );
  }

  void pay() async {
    fb_auth.User user = await _auth.getCurrentUser();
    String reference = user.uid;
    double value = double.parse(this.finalAmount) * 100;
    http.Response payments =
        await http.post('https://checkout-test.adyen.com/v65/payments',
            headers: apiContent,
            body: jsonEncode({
              'merchantAccount': 'SugoAccountECOM',
              'amount': {'currency': 'PHP', 'value': value},
              'reference': reference,
              'paymentMethod': {'type': 'gcash'},
              'returnUrl': 'adyencheckout://com.capstone.sugoapp?',
              'shopperInteraction': 'Ecommerce',
              'channel': 'Android',
              'countryCode': 'PH',
            }));

    Map<dynamic, dynamic> paymentJSON = jsonDecode(payments.body);
    print(payments.statusCode);
    log(payments.body);
    launchUrl(paymentJSON['action']['url'].toString(),
        paymentJSON['paymentData'], reference);
    log('URI -> ${Uri.parse(paymentJSON['action']['url'].toString())}');
  }

  void launchUrl(String url, String paymentData, String uid) async {
    print('LAUNCHING PAYMENT URL');
    // await launch(url, forceWebView: false); //way labot ni
    try {
      final result = await FlutterWebAuth.authenticate(
        url: url,
        callbackUrlScheme: 'adyencheckout',
      );

      final redirectResult =
          Uri.parse(result).queryParameters['redirectResult'];
      print('PAYLOAD = $redirectResult');
      log('uri = ${Uri.parse(result)}');

      showPaymentTransactionDialog(
          redirectResult: redirectResult, paymentData: paymentData, uid: uid);
    } catch (e) {
      setLoading(false);
      print(e);
    }
    // if (Platform.isAndroid) {

    // }
  }

  void showPaymentTransactionDialog(
      {String paymentData, String redirectResult, String uid}) async {
    try {
      var paymentDetails = await http
          .post(
        'https://checkout-test.adyen.com/v65/payments/details/',
        headers: apiContent,
        body: jsonEncode({
          'paymentData': paymentData,
          'details': {
            'redirectResult': redirectResult,
          }
        }),
      )
          .whenComplete(() async {
        setLoading(false);
        Navigator.pop(context);
      });
      print(paymentDetails.statusCode);
      Map<dynamic, dynamic> detailsJSON = jsonDecode(paymentDetails.body);
      print('RESULT CODE:${detailsJSON['resultCode']}');
      print('Reference:${detailsJSON['pspReference']}');
      if (detailsJSON['resultCode'] == 'Authorised') {
        //top up credits..
        ProfileDatabase(uid: uid).topUpCredits(
            addedvalue: double.parse(this.finalAmount),
            oldvalue: widget.oldvalue);
        PaymentDatabase(uid: uid).postPayments(
            amount: double.parse(this.finalAmount),
            pspreference: detailsJSON['pspReference'],
            transaction: 'Top up',
            uid: uid);
        //save payment details for ref.
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
                    buildLabelText('Payment Success', 16.0, primaryColor,
                        FontWeight.normal),
                    buildLabelText('Payment Details', 12.0, Colors.grey,
                        FontWeight.normal),
                    separator(10),
                    Row(
                      children: [
                        Expanded(
                          child: buildSubLabelText('Reference:', 12.0,
                              Colors.black, FontWeight.normal),
                        ),
                        buildLabelText(detailsJSON['pspReference'], 14.0,
                            Colors.grey, FontWeight.normal),
                      ],
                    ),
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
      }
    } catch (e) {
      print('error : ${e.toString()}');
    }
  }
}
