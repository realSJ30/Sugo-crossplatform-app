import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sugoapp/config/config.dart';
import 'package:sugoapp/screens/authenticate/register/birthdaygender.dart';
import 'package:sugoapp/screens/authenticate/register/register.dart';

import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';

class TellusYourName extends StatefulWidget {
  @override
  _TellusYourNameState createState() => _TellusYourNameState();
}

class _TellusYourNameState extends State<TellusYourName> {
  //text fields state
  TextEditingController _firstnameController = new TextEditingController();
  TextEditingController _lastnameController = new TextEditingController();
  TextEditingController _middlenameController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void setValues() {
    updateUserConfig('usertype', 'BASIC');
    updateUserConfig('firstname', _firstnameController.text.trimLeft());
    updateUserConfig('lastname', _lastnameController.text.trimLeft());
    updateUserConfig('middlename', _middlenameController.text.trimLeft());
  }

  void goNextPage() async {
    if (_formKey.currentState.validate()) {
      setValues();
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (context) => Register(
                BirthdayGender(),
              )));
    } else {
      print('Unfinished!');
    }
  }

  @override
  void initState() {
    //conditions the displayed value according to the json file para pag mag navigate
    //pabalik og padulong dli magrefresh ang padulong, instead mstore tng prev na giinput.
    if (getUserConfig('firstname').isNotEmpty) {
      this._firstnameController.text = getUserConfig('firstname');
      this._lastnameController.text = getUserConfig('lastname');
      this._middlenameController.text = getUserConfig('middlename');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 12,
                  left: MediaQuery.of(context).size.width / 12),
              child: buildSubLabelText(
                  'Tell us your name', 28.0, primaryColor, FontWeight.normal),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding:
                  EdgeInsets.only(left: MediaQuery.of(context).size.width / 12),
              child: buildLabelText('First name, Middle name, Last name', 12.0,
                  Colors.grey, FontWeight.normal),
            ),
          ),
          separator(25.0),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    child: _buildTextInput('First name', textInputDecoration,
                        _firstnameController),
                  ),
                  separator(20.0),
                  Container(
                    child: _buildTextInput('Middle name', textInputDecoration,
                        _middlenameController),
                  ),
                  separator(20.0),
                  Container(
                    child: _buildTextInput(
                        'Last name', textInputDecoration, _lastnameController),
                  )
                ],
              ),
            ),
          ),
          Expanded(child: Container()),
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buttonPop(
                      context,
                      50,
                      buildLabelText(
                          'BACK', 12.0, primaryColor, FontWeight.normal)),
                  buttonNext(
                      context,
                      140,
                      buildLabelText(
                          'NEXT STEP', 14.0, Colors.white, FontWeight.normal),
                      goNextPage),
                ],
              ),
              cancelButton(context)
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTextInput(String label, InputDecoration textinputdecoration,
      TextEditingController controller) {
    return Column(
      children: <Widget>[
        TextFormField(
          inputFormatters: [
            new FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
          ],
          textCapitalization: TextCapitalization.words,
          controller: controller,
          validator: (val) {
            //kulang pani dpat ang val is mag contain og letters lang...
            String value = val.trim();
            if (value.isEmpty) {
              return 'Field must not be empty';
            } else {
              return null;
            }
          },
          onChanged: (val) {
            setState(() {
              setValues(); //para kada type matic isave sa json pra kng mg back tas next page mastore rtng giinput nmu.
            });
          },
          decoration: textInputDecoration.copyWith(
            labelText: label,
            labelStyle: TextStyle(fontFamily: 'Century Gothic', fontSize: 16.0),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
          ),
        )
      ],
    );
  }
}
