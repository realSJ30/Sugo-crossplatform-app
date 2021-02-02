import 'package:flutter/material.dart';
import 'package:sugoapp/shared/widgets.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: buildLabelText(
                'You can try to reach us through the following:',
                18.0,
                Colors.black,
                FontWeight.normal),
          ),
          separator(5),
          ListTile(
            leading: Icon(Icons.email),
            title: buildLabelText('sugoapp.errands@gmail.com', 14.0,
                Colors.black, FontWeight.normal),
          ),
          separator(10),
          ListTile(
            leading: Icon(Icons.phone),
            title: buildLabelText(
                '282-2262', 14.0, Colors.black, FontWeight.normal),
          )
        ],
      ),
    ));
  }
}
