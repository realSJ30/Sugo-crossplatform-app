import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:sugoapp/config/config.dart';
import 'package:sugoapp/screens/authenticate/help/help.dart';
import 'package:sugoapp/services/auth.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';

class SignIn extends StatefulWidget {
  @override
  _SignIn createState() => _SignIn();
}

class _SignIn extends State<SignIn> {
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
  final scaff = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  bool useEmail = false;
  bool showPassword = false;
  bool showConfirmPassword = false;
  bool newUser = false;

  void toggleNewUser() {
    setState(() {
      newUser = !newUser;
    });
  }

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

  void toggleuseEmail() {
    setState(() {
      useEmail = !useEmail;
    });
  }

  void toggleisLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  void validate(BuildContext cntext) {
    if (Platform.isAndroid) {
      if (this.useEmail) {
        if (formKey.currentState.validate()) {
          toggleisLoading();
          if (this.newUser) {
            _auth
                .registerEmailPassword(
                    this.emailcontroller.text, this.passcontroller.text, cntext)
                .then((value) {
              if (value == null) {
                this.toggleisLoading();
              } else {
                updateUserConfig('email', this.emailcontroller.text);
              }
            });
          } else {
            _auth
                .signInwithEmailPassword(
                    email: this.emailcontroller.text,
                    password: this.passcontroller.text,
                    context: cntext)
                .then((value) {
              if (value == null) {
                this.toggleisLoading();
                this.passcontroller.clear();
              }
            });
          }
        }
      } else {
        if (formKey.currentState.validate()) {
          try {
            toggleisLoading();
            _auth.registerPhoneAuth(
                formatContact(formatContact(contact)), cntext, toggleisLoading,
                errormsg: 'Error check connection or try again later.');

            updateUserConfig('contact', formatContact(contact));
          } catch (e) {
            print(e.toString());
          }
        }
      }
    } else {
      if (formKey.currentState.validate()) {
        toggleisLoading();
        if (this.newUser) {
          _auth
              .registerEmailPassword(
                  this.emailcontroller.text, this.passcontroller.text, cntext)
              .then((value) {
            if (value == null) {
              this.toggleisLoading();
            } else {
              updateUserConfig('email', this.emailcontroller.text);
            }
          });
        } else {
          _auth
              .signInwithEmailPassword(
                  email: this.emailcontroller.text,
                  password: this.passcontroller.text,
                  context: cntext)
              .then((value) {
            if (value == null) {
              this.toggleisLoading();
              this.passcontroller.clear();
            }
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LoadingOverlay(
        isLoading: isLoading,
        child: Scaffold(
          key: scaff,
          appBar: AppBar(
            toolbarHeight: getMediaQueryHeightViaDivision(context, 20),
            elevation: 0,
            backgroundColor: Color(0xFF306EFF), //Colors.black,
            actions: [
              if (Platform.isAndroid)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      toggleuseEmail();
                      printUserProfile();
                    },
                    child: buildSubLabelText(
                        !this.useEmail ? 'Use email instead?' : 'Phone number?',
                        16.0,
                        Colors.white,
                        FontWeight.normal),
                  ),
                ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniCenterDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: signInButton()),
              ],
            ),
          ),
          body: Container(
            child: ListView(
              children: <Widget>[
                minilogo(context),
                separator(10),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: buildLabelText(
                            'Sign in', 24.0, Colors.blue[500], FontWeight.bold),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        print('trouble sign in');
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => Help()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: buildSubLabelText('Trouble signing in?', 14.0,
                            Colors.grey, FontWeight.normal),
                      ),
                    ),
                  ],
                ),
                Platform.isAndroid ? phoneLogin() : emailLogin(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget signInButton() {
    return Builder(
      builder: (contxt) {
        return ButtonTheme(
          height: getMediaQueryHeightViaDivision(context, 15),
          child: RaisedButton(
            onPressed: () {
              validate(contxt);
            },
            color: primaryColor,
            splashColor: secondaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            child:
                buildLabelText('Proceed', 14.0, Colors.white, FontWeight.bold),
          ),
        );
      },
    );
  }

  Widget phoneLogin() {
    return Container(
      child: Column(
        children: <Widget>[
          !useEmail
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Form(
                        key: formKey,
                        child: mobiletextField(
                            "Mobile number", textInputDecoration)),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            emailpasstextfield(
                                "Email", textInputDecoration, emailcontroller),
                            separator(5),
                            emailpasstextfield("Password", textInputDecoration,
                                passcontroller),
                            separator(5),
                            if (this.newUser)
                              confirmpasstextfield("Confirm Password",
                                  textInputDecoration, confirmpasscontroller),
                            separator(5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    toggleNewUser();
                                  },
                                  child: buildSubLabelText(
                                      !newUser ? 'New user?' : 'Sign in',
                                      18.0,
                                      Colors.blue,
                                      FontWeight.normal),
                                ),
                              ],
                            ),
                          ],
                        )),
                  ),
                ),
        ],
      ),
    );
  }

  Widget emailLogin() {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      emailpasstextfield(
                          "Email", textInputDecoration, emailcontroller),
                      separator(5),
                      emailpasstextfield(
                          "Password", textInputDecoration, passcontroller),
                      separator(5),
                      if (this.newUser)
                        confirmpasstextfield("Confirm Password",
                            textInputDecoration, confirmpasscontroller),
                      separator(5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              toggleNewUser();
                            },
                            child: buildSubLabelText(
                                !newUser ? 'New user?' : 'Sign in',
                                18.0,
                                Colors.blue,
                                FontWeight.normal),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
          ),
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
          hintText: hintText,
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
        } else {
          return null;
        }
      },
    );
  }

  Widget mobiletextField(String hintText, InputDecoration textDecoration) {
    return TextFormField(
        keyboardType: TextInputType.number,
        decoration: textDecoration.copyWith(
          hintText: 'Enter Phone Number',
          hintStyle: TextStyle(
              color: Colors.grey, fontFamily: 'Century Gothic', fontSize: 14.0),
          prefixIcon: hintText == "Mobile number"
              ? Icon(Icons.call)
              : Icon(Icons.lock_outline),
        ),
        validator: hintText == "Mobile number"
            ? (val) {
                if (val.isEmpty) {
                  return "Enter mobile number!";
                } else if (val.contains('+63') && val.length > 13) {
                  return "Phone number is incorrect!";
                } else if (!val.contains('+63') && val.length > 11) {
                  return "Phone number is incorrect!";
                } else if (val.length < 11) {
                  return "Phone number is incorrect!";
                } else if (val.length == 11 && val[0] + val[1] != '09') {
                  return "Phone number is incorrect!";
                } else {
                  return null;
                }
              }
            : (val) {
                if (val.isEmpty) {
                  return "Enter Password";
                } else {
                  return null;
                }
              },
        onChanged: (val) {
          setState(() {
            contact = val;
          });
        });
  }

  String formatContact(String contact) {
    String formattedContact = "";
    if (contact.length == 11) {
      formattedContact = '+63' + contact.substring(1);
    } else if (contact.contains('+63')) {
      formattedContact = contact;
    }
    return formattedContact;
  }
}
