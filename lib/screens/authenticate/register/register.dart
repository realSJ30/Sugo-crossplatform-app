import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  Widget child;

  Register(this.child);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //navigates through the registration process step by step...

    //CONDITIONAL PART
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: widget.child,
      ),
    );
  }
}
