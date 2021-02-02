// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:sugoapp/screens/home/services/current/payment/paymentconfig.dart';
// import 'package:sugoapp/shared/widgets.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:http/http.dart' as http;

// class Payment extends StatefulWidget {
//   @override
//   _PaymentState createState() => _PaymentState();
// }

// class _PaymentState extends State<Payment> {
//   final Completer<WebViewController> _controller =
//       Completer<WebViewController>();

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: appBar('Payment'),
//         body: FutureBuilder(
//           future: payments(),
//           builder: (context, snap) {
//             if (!snap.hasData) {
//               return loadingWidget();
//             }
//             http.Response response = snap.data;
//             log(response.body);
//             Map<dynamic, dynamic> paymentJSON = jsonDecode(response.body);

//             http.Response request = await http.get(paymentJSON['redirect']['url'].toString());

//             return WebView(
//               initialUrl: paymentJSON['redirect']['url'],
//               onWebViewCreated: (WebViewController webviewController) {
//                 _controller.complete(webviewController);
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Future payments() async {
//     http.Response payments =
//         await http.post('https://checkout-test.adyen.com/v64/payments',
//             headers: apiContent,
//             body: jsonEncode({
//               'amount': {'currency': 'PHP', 'value': '25000'},
//               'reference': 'order1012',
//               'paymentMethod': {'type': 'gcash'},
//               'returnUrl': 'adyencheckout://com.example.sugo_app',
//               'merchantAccount': 'SugoAccountECOM',
//             }));
//     return payments;
//   }
// }
