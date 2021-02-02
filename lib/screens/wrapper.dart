import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugoapp/models/user.dart';
import 'package:sugoapp/models/userprofile.dart';
import 'package:sugoapp/screens/authenticate/authenticate.dart';
import 'package:sugoapp/screens/authenticate/register/getstarted.dart';
import 'package:sugoapp/screens/authenticate/register/register.dart';
import 'package:sugoapp/screens/home/home.dart';
import 'package:sugoapp/screens/home/homewrapper.dart';
import 'package:sugoapp/services/auth.dart';
import 'package:sugoapp/services/database.dart';
import 'package:sugoapp/services/profiledatabase.dart';
import 'package:sugoapp/shared/widgets.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  AuthService _auth = new AuthService();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null) {
      print('User -> null');
      return Authenticate();
    } else {
      print('User: -> ${user.uid}');
      return FutureBuilder(
          future: getsData(user),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              // _auth.signOut();
              return loadingWidget();
            }
            String data = snapshot.data;
            return data == 'yes'
                ? Register(GettingStarted())
                : StreamProvider<UserProfile>.value(
                    value: ProfileDatabase(uid: user.uid).profile,
                    child: HomeWrapper(
                      uid: user.uid,
                    ),
                  );
          });
    }
  }

  Future getsData(User user) async {
    String data;

    await DatabaseService(uid: user.uid).validatesNewUser().then((value) {
      data = value.toString();
    }).whenComplete(() async {
      // kng mahuman na ang process mao ni buhaton...
      print('data value: $data');
      if (data != null) {
        await ProfileDatabase(uid: user.uid).setUserDeviceToken();
      }

      return data;
    });
    return data;
  }
}
