import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugoapp/models/userprofile.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/string_extension.dart';
import 'package:sugoapp/shared/widgets.dart';

class HomeDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userprofile = Provider.of<UserProfile>(context);
    if (_userprofile == null) {
      return Container(
          color: primaryColor,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: ListTile(
              leading: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  color: Colors.blue,
                  size: 35,
                ),
              ),
              title: buildLabelText('-', 20.0, Colors.white, FontWeight.bold),
              subtitle: Row(
                children: <Widget>[
                  buildLabelText('-', 12.0, Colors.white, FontWeight.normal),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Icon(
                      Icons.contact_phone,
                      size: 12.0,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              trailing: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 25.0,
                ),
              ),
            ),
          ));
    }
    return Container(
        color: primaryColor,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
          child: ListTile(
            leading: _userprofile.imgpath.isEmpty
                ? Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200], shape: BoxShape.circle),
                    width: 80,
                    height: 80, //getMediaQueryHeightViaDivision(context, 5)
                    child: Center(
                        child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.grey,
                    )),
                  )
                : Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(_userprofile.imgpath),
                        )),
                    width: 80,
                    height: 80, //getMediaQueryHeightViaDivision(context, 5)
                  ),
            title: buildLabelText(
                fullName(_userprofile.firstname, _userprofile.middlename,
                    _userprofile.lastname),
                20.0,
                Colors.white,
                FontWeight.bold),
            subtitle: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Icon(
                    Icons.contact_phone,
                    size: 12.0,
                    color: Colors.white,
                  ),
                ),
                buildLabelText(
                    _userprofile.contact.isEmpty
                        ? 'Not set'
                        : _userprofile.contact,
                    12.0,
                    Colors.white,
                    FontWeight.normal),
              ],
            ),
            trailing: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 25.0,
              ),
            ),
          ),
        ));
  }

  //converts data to displayable data e.g names,birthdays
  String fullName(String first, String mid, String last) {
    print('okayss: $first');
    return "${first.capitalize()} ${mid[0].capitalize()}. ${last.capitalize()}";
  }
}
