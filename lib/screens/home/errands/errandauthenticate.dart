import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugoapp/models/userprofile.dart';
import 'package:sugoapp/screens/home/errands/errandcard/errandcard.dart';
import 'package:sugoapp/screens/home/errands/errandpages/errands.dart';
import 'package:sugoapp/screens/home/errands/pendingapplication/pending.dart';
import 'package:sugoapp/screens/home/errands/renewal/renewal.dart';
import 'package:sugoapp/shared/widgets.dart';

class ErrandAuthenticate extends StatefulWidget {
  @override
  _ErrandAuthenticateState createState() => _ErrandAuthenticateState();
}

class _ErrandAuthenticateState extends State<ErrandAuthenticate> {
  @override
  Widget build(BuildContext context) {
    final _userprofile = Provider.of<UserProfile>(context);
    // print('account: ${_userprofile.data['account']}');
    if (_userprofile == null) {
      return loadingWidget();
    } else {
      if (_userprofile.account == 'BASIC') {
        return ErrandCard();
      } else if (_userprofile.account == 'PENDING') {
        return Pending();
      } else if (_userprofile.account == 'HOLD') {
        return RenewalPage();
      } else {
        return Errands();
      }
    }
  }
}
