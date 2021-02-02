import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:sugoapp/services/auth.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class EmailAuth extends StatefulWidget {
  final String oldEmail;
  final String phonenumber;
  EmailAuth({this.oldEmail, this.phonenumber});
  @override
  _EmailAuthState createState() => _EmailAuthState();
}

class _EmailAuthState extends State<EmailAuth> {
  final formKey = GlobalKey<FormState>();

  //textfields state
  String contact = "";
  String email = '';
  String password = '';
  FocusNode focusNode = new FocusNode();
  AuthService _auth = AuthService();
  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController passcontroller = new TextEditingController();
  TextEditingController confirmpasscontroller = new TextEditingController();

  bool showPassword = false;
  bool isLoading = false;
  bool showConfirmPassword = false;
  void toggleshowPass() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  void toggleshowConfirmPass() {
    setState(() {
      showConfirmPassword = !showConfirmPassword;
    });
  }

  void toggleisLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LoadingOverlay(
        isLoading: isLoading,
        child: Scaffold(
          floatingActionButton: saveButton(callback: () async {}),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          appBar: appBar(''),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 12,
                              left: MediaQuery.of(context).size.width / 12),
                          child: buildSubLabelText('Update Email', 28.0,
                              primaryColor, FontWeight.normal),
                        ),
                      ),
                      separator(10),
                      emailpasstextfield(
                          "Email", textInputDecoration, emailcontroller),
                      separator(10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width / 12),
                          child: buildLabelText(
                              widget.oldEmail.isEmpty
                                  ? 'Create password'
                                  : 'Enter password to confirm email change',
                              14.0,
                              Colors.grey,
                              FontWeight.normal),
                        ),
                      ),
                      separator(5),
                      emailpasstextfield(
                          "Password", textInputDecoration, passcontroller),
                      separator(5),
                      confirmpasstextfield("Confirm Password",
                          textInputDecoration, confirmpasscontroller),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget saveButton({VoidCallback callback}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(child: Builder(
            builder: (context) {
              return ButtonTheme(
                child: RaisedButton(
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        toggleisLoading();

                        print('save');

                        fb_auth.User user = await _auth.getCurrentUser();
                        print(user.uid);
                        await _auth
                            .updateEmail(
                                number: widget.phonenumber,
                                uid: user.uid,
                                context: context,
                                newEmail: this.emailcontroller.text,
                                oldEmail: widget.oldEmail,
                                password: this.passcontroller.text)
                            .then((value) {
                          if (value == null) {
                            toggleisLoading();
                          }
                        });
                      }
                    },
                    color: primaryColor,
                    splashColor: secondaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    child: buildLabelText(
                        'Save Email', 14.0, Colors.white, FontWeight.normal)),
              );
            },
          ))
        ],
      ),
    );
  }

  Widget emailpasstextfield(String hintText, InputDecoration textDecoration,
      TextEditingController controller) {
    return TextFormField(
        controller: controller,
        obscureText: hintText == "Password" ? !this.showPassword : false,
        keyboardType: hintText == "Email" ? TextInputType.emailAddress : null,
        decoration: textDecoration.copyWith(
          suffixIcon: hintText == "Password"
              ? InkWell(
                  onTap: () {
                    toggleshowPass();
                  },
                  child: showPassword
                      ? Icon(Icons.visibility)
                      : Icon(Icons.visibility_off),
                )
              : null,
          hintText: hintText == 'Email'
              ? widget.oldEmail.isNotEmpty
                  ? widget.oldEmail
                  : hintText
              : hintText,
          hintStyle: TextStyle(
              color: Colors.grey, fontFamily: 'Century Gothic', fontSize: 14.0),
          prefixIcon: hintText == "Email"
              ? Icon(Icons.alternate_email)
              : Icon(Icons.lock_outline),
        ),
        validator: hintText == "Email"
            ? (val) {
                if (val.isEmpty) {
                  return "Enter valid email!";
                } else if (!val.contains('@')) {
                  return "Enter valid email!";
                } else if (val == widget.oldEmail) {
                  return "You entered an old email!";
                } else {
                  return null;
                }
              }
            : (val) {
                if (val.isEmpty) {
                  return "Enter Password";
                } else if (val.length < 6) {
                  return "Password too weak!";
                } else {
                  return null;
                }
              },
        onChanged: (val) {
          setState(() {
            hintText == 'Email' ? email = val : password = val;
          });
        });
  }

  Widget confirmpasstextfield(String hintText, InputDecoration textDecoration,
      TextEditingController controller) {
    return TextFormField(
      controller: controller,
      obscureText: !this.showConfirmPassword,
      decoration: textDecoration.copyWith(
        suffixIcon: InkWell(
          onTap: () {
            toggleshowConfirmPass();
          },
          child: !this.showConfirmPassword
              ? Icon(Icons.visibility_off)
              : Icon(Icons.visibility),
        ),
        hintText: hintText,
        hintStyle: TextStyle(
            color: Colors.grey, fontFamily: 'Century Gothic', fontSize: 14.0),
        prefixIcon: Icon(Icons.lock_outline),
      ),
      validator: (val) {
        if (val != password) {
          return 'Password does not match!';
        } else if (val.isEmpty) {
          return 'Password does not match!';
        } else {
          return null;
        }
      },
    );
  }
}
