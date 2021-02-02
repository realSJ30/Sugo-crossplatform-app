import 'package:flutter/material.dart';
import 'package:sugoapp/shared/constants.dart';

Widget errandTabs() {
  return TabBar(
      labelColor: Colors.white,
      labelStyle: TextStyle(fontFamily: secondaryFont, fontSize: 16.0),
      indicatorColor: secondaryColor,
      indicatorWeight: 3,
      tabs: <Widget>[
        Tab(
          text: 'NEARBY',
        ),
        Tab(
          text: 'ALL',
        )
      ]);
}
