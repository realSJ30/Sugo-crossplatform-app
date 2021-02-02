import 'package:flutter/material.dart';
import 'package:sugoapp/screens/authenticate/signin/signin.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    //must return either sign in or register
    return SignIn();
  }
}
