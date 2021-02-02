import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:provider/provider.dart';
import 'package:sugoapp/config/user.dart';
import 'package:sugoapp/models/user.dart' as usermodel;
import 'package:sugoapp/screens/wrapper.dart';
import 'package:sugoapp/services/auth.dart';

void main() async {
  GlobalConfiguration().loadFromMap(userProfile);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<usermodel.User>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
      ),
    );
  }
}
