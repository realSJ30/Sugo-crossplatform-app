import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sugoapp/config/config.dart';
import 'package:sugoapp/models/user.dart';
import 'package:sugoapp/services/database.dart';
import 'package:sugoapp/services/profiledatabase.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';

class AuthService {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  //creates user obj base sa firebaseuser
  User _userFromFirebaseUser(fb.User user) {
    return user != null ? User(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<User> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  //sign in with email & password

  //reset password
  Future resetPassword({String email, GlobalKey<ScaffoldState> scaff}) async {
    _auth
        .sendPasswordResetEmail(email: email)
        .then((value) => showOkaySnack(
            scaff, 'A password confirmation was sent to your email.'))
        .catchError((e) {
      print(e.toString());
      if (e.toString().contains('deleted')) {
        showPutaSnack(scaff, 'User does not exist!');
      } else {
        showPutaSnack(scaff, 'Error sending confirmation');
      }
    });
  }

  //register with email & password
  Future registerEmailPassword(
      String email, String password, BuildContext context) async {
    try {
      fb.UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      fb.User user = result.user;
      if (result.additionalUserInfo.isNewUser) {
        print('new user');
        DatabaseService(uid: user.uid).newUser();
      } else {
        print('not new user');
        DatabaseService(uid: user.uid).oldUser();
      }
      return _userFromFirebaseUser(user);
    } catch (e) {
      if (e.toString().contains('timeout')) {
        showWarningSnack(context, 'Error check connection or try again.');
      } else if (e.toString().contains('badly formatted')) {
        showWarningSnack(context, 'The email address is badly formatted.');
      } else {
        showWarningSnack(context, 'Email is already taken!');
      }
      print(e.toString());

      return null;
    }
  }

  //sign in with email & password
  Future signInwithEmailPassword(
      {String email, String password, BuildContext context}) async {
    try {
      fb.UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      fb.User user = result.user;
      if (result.additionalUserInfo.isNewUser) {
        print('new user');
        DatabaseService(uid: user.uid).newUser();
      } else {
        print('not new user');
        DatabaseService(uid: user.uid).oldUser();
      }
      return _userFromFirebaseUser(user);
    } catch (e) {
      if (e.toString().contains('timeout')) {
        showWarningSnack(context, 'Error check connection or try again.');
      } else {
        showWarningSnack(context, 'Email or password is incorrect!');
      }
      print(e.toString());

      return null;
    }
  }

  //register phone auth
  Future registerPhoneAuth(
      String number, BuildContext context, Function toggleLoading,
      {String errormsg}) async {
    TextEditingController _codeController = new TextEditingController();
    final _formKey = GlobalKey<FormState>();
    try {
      _auth.verifyPhoneNumber(
        phoneNumber: number,
        timeout: Duration(seconds: 60),
        verificationCompleted: (fb.AuthCredential credential) async {
          //mugana lg kng gamit tng auto code retrieval
          Navigator.popUntil(
              context,
              (route) => route
                  .isFirst); //gi pop nlg nko kay nag patong2 man ang registration...

          fb.UserCredential result =
              await _auth.signInWithCredential(credential);

          fb.User user = result.user;

          if (result.additionalUserInfo.isNewUser) {
            print('new user');
            DatabaseService(uid: user.uid).newUser();
          } else {
            print('not new user');
            DatabaseService(uid: user.uid).oldUser();
          }
          return _userFromFirebaseUser(user);
        },
        verificationFailed: (fb.FirebaseAuthException exception) {
          toggleLoading();
          print(exception.message);
          if (exception.message ==
              'We have blocked all requests from this device due to unusual activity. Try again later.') {
            showWarningSnack(context, 'Device blocked try again later');
          } else {
            print(exception.message);
            showWarningSnack(context, 'Error check connection or try again.');
          }
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          print(verificationId);
          String err = '';
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return SingleChildScrollView(
                  child: Center(
                    child: AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      title: buildLabelText('Code verification', 18.0,
                          primaryColor, FontWeight.normal),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          buildLabelText(
                              'A code was sent to your phone number.',
                              12.0,
                              Colors.grey,
                              FontWeight.normal),
                          separator(10.0),
                          Form(
                            key: _formKey,
                            child: TextFormField(
                              validator: (val) {
                                if (val.isEmpty) {
                                  return 'Please input code';
                                } else if (err.isNotEmpty) {
                                  return err;
                                } else {
                                  return null;
                                }
                              },
                              decoration: textInputDecoration.copyWith(
                                hintText: 'Enter code',
                                // hintStyle: TextStyle(fontFamily: 'Century Gothic',fontSize: 12.0,fontWeight: FontWeight.normal)
                              ),
                              controller: _codeController,
                            ),
                          )
                        ],
                      ),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                              toggleLoading();
                            },
                            child: buildLabelText('Cancel', 14.0, Colors.grey,
                                FontWeight.normal)),
                        FlatButton(
                            // ignore: missing_return
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                try {
                                  toggleLoading();

                                  final code = _codeController.text;
                                  fb.AuthCredential credential =
                                      fb.PhoneAuthProvider.credential(
                                    verificationId: verificationId,
                                    smsCode: code,
                                  );
                                  fb.UserCredential result = await _auth
                                      .signInWithCredential(credential)
                                      .catchError((onError) {
                                    print(
                                        'error login code: ${onError.toString()}');
                                    return null;
                                  });
                                  print('resultvalue: $result');

                                  if (result == null) {
                                    toggleLoading();
                                    err = 'Incorrect code!';
                                    _formKey.currentState.validate();
                                    print('null man diay');
                                    return null;
                                  } else {
                                    fb.User user = result.user;

                                    Navigator.pop(context);
                                    // DatabaseService(uid: user.uid)
                                    //     .updateUserData(account: 'basic');
                                    if (result.additionalUserInfo.isNewUser) {
                                      print('new user');
                                      DatabaseService(uid: user.uid).newUser();
                                    } else {
                                      print('not new user');

                                      DatabaseService(uid: user.uid).oldUser();
                                    }
                                  }
                                } on PlatformException catch (e) {
                                  print('sakpan');
                                  print(e.toString());
                                  print('login failed');
                                  toggleLoading();
                                  err = 'Incorrect code!';
                                  _formKey.currentState.validate();
                                }
                              }
                            },
                            child: buildLabelText('Confirm', 14.0, Colors.black,
                                FontWeight.normal)),
                      ],
                    ),
                  ),
                );
              });
        },
        codeAutoRetrievalTimeout: (String verificationID) {},
      );
    } on PlatformException catch (e) {
      print('sakpan');
      print(e.toString());
      Navigator.pop(context);
      return null;
    } catch (e) {
      print('sakpan');
      print(e.toString());
      Navigator.pop(context);
      return null;
    }
  }

  //change phone number
  Future changePhoneNumber(String number, BuildContext context) async {
    print(number);
    TextEditingController _codeController = new TextEditingController();
    final _formKey = GlobalKey<FormState>();
    try {
      _auth.verifyPhoneNumber(
          phoneNumber: number,
          timeout: Duration(seconds: 60),
          verificationCompleted: (fb.AuthCredential credential) async {
            fb.User user = _auth.currentUser;
            await DatabaseService(uid: user.uid)
                .updateUserProfileData('contact', number);
            await (fb.FirebaseAuth.instance.currentUser)
                .updatePhoneNumber(credential);
          },
          verificationFailed: (fb.FirebaseAuthException exception) {
            print(exception.message);
            showSnack(context, 'No internet connection');
          },
          codeSent: (String verificationId, [int forceResendingToken]) {
            String err = '';
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return SingleChildScrollView(
                    child: Center(
                      child: AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        title: buildLabelText('Code verification', 18.0,
                            primaryColor, FontWeight.normal),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            buildLabelText(
                                'A code was sent to your phone number.',
                                12.0,
                                Colors.grey,
                                FontWeight.normal),
                            separator(10.0),
                            Form(
                              key: _formKey,
                              child: TextFormField(
                                validator: (val) {
                                  if (val.isEmpty) {
                                    return 'Please input code';
                                  } else if (err.isNotEmpty) {
                                    return err;
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: textInputDecoration.copyWith(
                                  hintText: 'Enter code',
                                  // hintStyle: TextStyle(fontFamily: 'Century Gothic',fontSize: 12.0,fontWeight: FontWeight.normal)
                                ),
                                controller: _codeController,
                              ),
                            )
                          ],
                        ),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: buildLabelText('Cancel', 14.0, Colors.grey,
                                  FontWeight.normal)),
                          FlatButton(
                              // ignore: missing_return
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  try {
                                    final code = _codeController.text;
                                    fb.AuthCredential credential =
                                        fb.PhoneAuthProvider.credential(
                                            verificationId: verificationId,
                                            smsCode: code);
                                    await (fb.FirebaseAuth.instance.currentUser)
                                        .updatePhoneNumber(credential);

                                    fb.User user = _auth.currentUser;
                                    await DatabaseService(uid: user.uid)
                                        .updateUserProfileData(
                                            'contact', number);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  } catch (e) {
                                    print('login failed');

                                    err = 'Incorrect code!';
                                    _formKey.currentState.validate();
                                  }
                                }
                              },
                              child: buildLabelText('Confirm', 14.0,
                                  Colors.grey, FontWeight.normal)),
                        ],
                      ),
                    ),
                  );
                });
          },
          codeAutoRetrievalTimeout: (String verificationID) {});
    } catch (e) {
      print(e.toString());
    }
  }

  //update email
  Future updateEmail(
      {String uid,
      String oldEmail,
      String number,
      String password,
      String newEmail,
      BuildContext context}) async {
    try {
      if (oldEmail.isEmpty) {
        fb.AuthCredential cred = fb.EmailAuthProvider.credential(
            email: newEmail, password: password);
        _auth.currentUser.linkWithCredential(cred);
        await ProfileDatabase(uid: uid)
            .updateUserData(field: 'email', data: newEmail);
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        await _auth.signInWithEmailAndPassword(
            email: oldEmail, password: password);
        await (fb.FirebaseAuth.instance.currentUser).updateEmail(newEmail);
        await ProfileDatabase(uid: uid)
            .updateUserData(field: 'email', data: newEmail);
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } catch (e) {
      if (e.toString().contains('timeout')) {
        showWarningSnack(context, 'Error check connection or try again.');
      } else if (e.toString().contains('password is invalid')) {
        showWarningSnack(context, 'Password incorrect!');
      } else {
        showWarningSnack(context, 'Email is already taken!');
      }
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      clearGlobalConfig();
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //delete user account if first login tapos gicancel ang setup
  Future deleteUserFromCancel() async {
    try {
      clearGlobalConfig();
      fb.User user = fb.FirebaseAuth.instance.currentUser;
      return await user.delete();
    } catch (e) {
      print(e.toString());
    }
  }

  //returns the current user
  Future getCurrentUser() async {
    try {
      fb.User user = fb.FirebaseAuth.instance.currentUser;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //reauthenticate the user
  Future reauthenticateUser() async {
    try {
      fb.AuthCredential credential = fb.PhoneAuthProvider.credential(
          verificationId: getUserConfig('idToken'),
          smsCode: getUserConfig('code'));
      fb.UserCredential result = await _auth.signInWithCredential(credential);
      fb.User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
