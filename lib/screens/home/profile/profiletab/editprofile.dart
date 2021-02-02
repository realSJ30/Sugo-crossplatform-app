import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sugoapp/screens/home/profile/profiletab/emailauth.dart';
import 'package:sugoapp/services/auth.dart';
import 'package:sugoapp/services/profiledatabase.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';

class EditProfile extends StatefulWidget {
  final AsyncSnapshot<dynamic> snapshot;
  final String uid;
  EditProfile({@required this.snapshot, @required this.uid});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _fnameController = new TextEditingController();
  TextEditingController _mnameController = new TextEditingController();
  TextEditingController _lnameController = new TextEditingController();
  // TextEditingController _emailController = new TextEditingController();
  TextEditingController _contactController = new TextEditingController();
  // TextEditingController _passwordController = new TextEditingController();
  List<String> list = ['Male', 'Female'];
  int selectedIndex = 0;
  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();
  final _passformKey = GlobalKey<FormState>();

  void changeIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void updateProfile() async {
    if (_formKey.currentState.validate()) {
      print('UPDATE NOW');
      await ProfileDatabase(uid: widget.uid)
          .updateUserData(field: 'gender', data: this.list[this.selectedIndex]);
      if (_fnameController.text.isNotEmpty) {
        await ProfileDatabase(uid: widget.uid)
            .updateUserData(field: 'firstname', data: _fnameController.text);
      }
      if (_mnameController.text.isNotEmpty) {
        await ProfileDatabase(uid: widget.uid)
            .updateUserData(field: 'middlename', data: _mnameController.text);
      }
      if (_lnameController.text.isNotEmpty) {
        await ProfileDatabase(uid: widget.uid)
            .updateUserData(field: 'lastname', data: _lnameController.text);
      }
      if (_contactController.text.isNotEmpty) {
        await _auth.changePhoneNumber(
            formatContact(_contactController.text), context);
      } else {
        Navigator.pop(context);
      }
    } else {
      print('UNABLE TO UPDATE');
    }
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      widget.snapshot.data['gender'] == 'Male'
          ? this.selectedIndex = 0
          : this.selectedIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: saveButton(callback: () {
          updateProfile();
        }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: appBar('Edit Profile'),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  nameTextFields(),
                  genderField(),
                  emailContactField(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget nameTextFields() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildLabelText('Your name', 16.0, Colors.blue, FontWeight.bold),
          separator(10),
          _buildTextInput(false, 'firstname', widget.snapshot.data['firstname'],
              textInputDecoration, _fnameController),
          separator(15.0),
          _buildTextInput(
              false,
              'middlename',
              widget.snapshot.data['middlename'],
              textInputDecoration,
              _mnameController),
          separator(15.0),
          _buildTextInput(false, 'lastname', widget.snapshot.data['lastname'],
              textInputDecoration, _lnameController),
        ],
      ),
    );
  }

  Widget genderField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildLabelText('Gender', 16.0, Colors.blue, FontWeight.bold),
          customRadio(list[0], 0),
          customRadio(list[1], 1),
        ],
      ),
    );
  }

  Widget emailContactField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildLabelText('Accounts', 16.0, Colors.blue, FontWeight.bold),
          separator(5),
          emailContainer(),
          separator(10),
          _buildTextInput(
              Platform.isAndroid ? false : true,
              'Contact',
              widget.snapshot.data['contact'],
              textInputDecoration,
              _contactController),
        ],
      ),
    );
  }

  Widget emailContainer() {
    return TextFormField(
      readOnly: true,
      textCapitalization: TextCapitalization.words,
      decoration: textInputDecoration.copyWith(
        prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
        isDense: true,
        suffixIcon: FlatButton(
          onPressed: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => EmailAuth(
                          phonenumber: widget.snapshot.data['contact'],
                          oldEmail: widget.snapshot.data['email'],
                        )));
          },
          child: Text(
            widget.snapshot.data['email'].toString().isEmpty
                ? 'Add Email'
                : 'Update Email',
            textAlign: TextAlign.right,
            style: TextStyle(
                fontFamily: secondaryFont, fontSize: 14.0, color: primaryColor),
          ),
        ),
        hintText: widget.snapshot.data['email'].toString().isEmpty
            ? 'Not set'
            : widget.snapshot.data['email'],
        hintStyle: TextStyle(fontFamily: 'Century Gothic', fontSize: 16.0),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
      ),
    );
  }

  Widget addEmailButton({VoidCallback callback}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              child: ButtonTheme(
            child: RaisedButton(
                onPressed: callback,
                color: primaryColor,
                splashColor: secondaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                child: buildLabelText(
                    'Add email', 14.0, Colors.white, FontWeight.normal)),
          ))
        ],
      ),
    );
  }

  Widget saveButton({VoidCallback callback}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              child: ButtonTheme(
            child: RaisedButton(
                onPressed: callback,
                color: primaryColor,
                splashColor: secondaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                child: buildLabelText(
                    'Save Profile', 14.0, Colors.white, FontWeight.normal)),
          ))
        ],
      ),
    );
  }

  Widget _buildTextInput(bool readOnly, String suffix, String label,
      InputDecoration textinputdecoration, TextEditingController controller) {
    return Column(
      children: <Widget>[
        TextFormField(
          readOnly: readOnly,
          textCapitalization: TextCapitalization.words,
          controller: controller,
          validator: (val) {
            //kulang pani dpat ang val is mag contain og letters lang...
            if (suffix == 'Email') {
              if (val.isEmpty) {
                return null;
              } else {
                return !val.contains('@') ? 'Invalid Email' : null;
              }
            } else if (suffix == 'Contact') {
              if (val.isEmpty) {
                return null;
              } else if (val.contains('+63') && val.length > 13) {
                return "Phone number is incorrect!";
              } else if (val.length < 11) {
                return "Phone number is incorrect!";
              } else if (val.length == 11 && val[0] + val[1] != '09') {
                return "Phone number is incorrect!";
              } else {
                return null;
              }
            } else {
              return null; //validates input if empty or not
            }
          },
          decoration: textInputDecoration.copyWith(
            prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
            isDense: true,
            suffixIcon: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                suffix,
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontFamily: secondaryFont,
                    fontSize: 12.0,
                    color: Colors.grey[400]),
              ),
            ),
            hintText: label,
            hintStyle: TextStyle(fontFamily: 'Century Gothic', fontSize: 16.0),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
          ),
        )
      ],
    );
  }

  Widget customRadio(String txt, int index) {
    return OutlineButton(
        onPressed: () {
          changeIndex(index);
        },
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        borderSide: BorderSide(
            width: selectedIndex == index ? 2 : 1,
            color: selectedIndex == index
                ? txt == 'Male'
                    ? primaryColor
                    : Colors.pink
                : Colors.grey),
        child: buildLabelText(
            txt,
            selectedIndex == index ? 14.0 : 12.0,
            selectedIndex == index
                ? txt == 'Male'
                    ? primaryColor
                    : Colors.pink
                : Colors.grey,
            selectedIndex == index ? FontWeight.bold : FontWeight.normal));
  }
}
