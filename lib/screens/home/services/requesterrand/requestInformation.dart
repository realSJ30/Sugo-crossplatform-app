import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:sugoapp/screens/home/services/requesterrand/errandlocation.dart';
import 'package:sugoapp/services/auth.dart';
import 'package:sugoapp/services/profiledatabase.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:tuxin_tutorial_overlay/TutorialOverlayUtil.dart';
import 'package:tuxin_tutorial_overlay/WidgetData.dart';

class RequestInformation extends StatefulWidget {
  final String tags;
  RequestInformation({this.tags});
  @override
  _RequestInformationState createState() => _RequestInformationState();
}

class _RequestInformationState extends State<RequestInformation> {
  List<Asset> images = List<Asset>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _notesController = new TextEditingController();
  TextEditingController _feeController = new TextEditingController();

  AuthService _auth = new AuthService();
  final GlobalKey notesKey = GlobalKey();
  final GlobalKey payKey = GlobalKey();
  final GlobalKey typeKey = GlobalKey();
  final GlobalKey helpButtonKey = GlobalKey();
  final GlobalKey photoKey = GlobalKey();
  final GlobalKey tagsKey = GlobalKey();

  String _value;
  List<String> _values = [
    'SUGO Coins',
    'COH(Cash on Hand)',
  ];
  void _onChanged(String value) {
    setState(() {
      _value = value;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _value = _values[1];
    showOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar('Request Errand', actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: InkWell(
              key: this.helpButtonKey,
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                showOverlayEntry(tagName: 'photo');
              },
              child: Container(
                  child: Row(
                children: <Widget>[
                  buildLabelText('Help', 12.0, Colors.white, FontWeight.normal),
                  Icon(
                    Icons.help_outline,
                    size: 20.0,
                    color: Colors.white,
                  ),
                ],
              )),
            ),
          ),
        ]),
        body: Form(
          key: _formKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    buildSubLabelText(
                        'Information', 16.0, Colors.grey, FontWeight.normal)
                  ],
                ),
              ),
              photosContainer(),
              Padding(
                key: tagsKey,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        buildSubLabelText(
                            'Tags', 16.0, Colors.grey, FontWeight.normal)
                      ],
                    ),
                    errandTags()
                  ],
                ),
              ),
              Padding(
                key: notesKey,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        buildSubLabelText(
                            'Notes', 16.0, Colors.grey, FontWeight.normal)
                      ],
                    ),
                    errandNotes()
                  ],
                ),
              ),
              Padding(
                key: payKey,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        buildSubLabelText(
                            'Service Fee', 16.0, Colors.grey, FontWeight.normal)
                      ],
                    ),
                    errandFee()
                  ],
                ),
              ),
              Padding(
                key: typeKey,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        buildSubLabelText('Payment Type', 16.0, Colors.grey,
                            FontWeight.normal)
                      ],
                    ),
                    paymentType()
                  ],
                ),
              ),
              nextButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget paymentType() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            border: Border.all(
                color: primaryColor, style: BorderStyle.solid, width: 1.0),
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton(
                  value: _value,
                  items: _values
                      .map((e) => new DropdownMenuItem(
                          value: e,
                          child: new Row(
                            children: <Widget>[
                              buildLabelText(
                                  e, 12.0, Colors.blue, FontWeight.normal),
                            ],
                          )))
                      .toList(),
                  onChanged: (e) => _onChanged(e)),
            ),
          ),
        ),
      ],
    );
  }

  Widget errandTags() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabelText(widget.tags, 16.0, Colors.black, FontWeight.normal),
      ],
    );
  }

  Widget errandNotes() {
    return TextFormField(
        controller: _notesController,
        validator: (val) {
          return val.isEmpty
              ? 'Field must not be empty'
              : null; //validates input if empty or not
        },
        maxLines: null,
        decoration: textInputDecoration.copyWith(
            hintText: 'Add notes to your errand.'));
  }

  Widget errandFee() {
    return TextFormField(
      textAlign: TextAlign.end,
      controller: _feeController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9-.]')),
      ],
      validator: (val) {
        int dotCount = 0;
        if (val.isEmpty) {
          return 'Field must not be empty';
        }
        if (val == '0') {
          return 'Invalid amount';
        }
        if (double.parse(val) < 100) {
          return 'Amount is less than minimum fee set by SUGO';
        }
        if (val.startsWith('0') || val.startsWith('.') || val.endsWith('.')) {
          return 'Invalid amount';
        }
        if (val.contains('.')) {
          for (int i = 0; i < val.length; i++) {
            if (val[i] == '.') {
              dotCount++;
            }
          }
          if (dotCount > 1) {
            return 'Invalid amount';
          }
        } else {
          return null;
        }
      },
      decoration: textInputDecoration.copyWith(hintText: '0.00 Php'),
    );
  }

  Widget photosContainer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
          onTap: () async {
            print('show gallery');
            loadAssets();
          },
          child: Container(
            key: photoKey,
            height: getMediaQueryHeightViaDivision(context, 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey[400], width: 1),
            ),
            child: images.length > 0
                ? FutureBuilder(
                    builder: (context, snap) {
                      if (!snap.hasData) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 10),
                            buildLabelText('Add Photos', 14.0, Colors.grey,
                                FontWeight.normal)
                          ],
                        );
                      }
                      return Carousel(
                        boxFit: BoxFit.cover,
                        images: List.generate(snap.data.length, (index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.file(
                              snap.data[index],
                              fit: BoxFit.cover,
                            ),
                          );
                        }),
                        autoplay: false,
                        dotSize: 4.0,
                        indicatorBgPadding: 4.0,
                        dotBgColor: Colors.transparent,
                      );
                    },
                    future: getAbsolutePath(),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 10),
                      buildLabelText(
                          'Add Photos', 14.0, Colors.grey, FontWeight.normal)
                    ],
                  ),
          )),
    );
  }

  Future<List<File>> getAbsolutePath() async {
    List<File> files = [];
    for (int i = 0; i < images.length; i++) {
      final filePath =
          await FlutterAbsolutePath.getAbsolutePath(images[i].identifier);
      files.add(File(filePath));
    }
    return files;
  }

  Future loadAssets() async {
    List<Asset> resultList = List<Asset>();
    try {
      resultList = await MultiImagePicker.pickImages(
          maxImages: 3,
          enableCamera: true,
          selectedAssets: images,
          cupertinoOptions: CupertinoOptions(takePhotoIcon: 'chat'));
    } catch (e) {
      print(e);
    }
    if (!mounted) return;

    if (resultList.length > 0) {
      setState(() {
        images = resultList;
      });
    }

    print('image count: ${images.length}');
    // print('image asset: ${images.first.identifier}');
  }

  Widget nextButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Builder(
              builder: (context) => ButtonTheme(
                height: 50.0,
                child: RaisedButton(
                    onPressed: () async {
                      fb_auth.User user = await _auth.getCurrentUser();

                      List<File> imgPaths = await getAbsolutePath();

                      // ignore: unnecessary_statements
                      if (_formKey.currentState.validate()) {
                        if (this._value == 'SUGO Coins') {
                          double credits =
                              await ProfileDatabase(uid: user.uid).getCredits();

                          if (credits >
                              double.parse(this._feeController.text)) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ErrandLocation(
                                      tags: widget.tags,
                                      fee: _feeController.text,
                                      notes: _notesController.text,
                                      paymenttype: _value,
                                      imgPath: imgPaths,
                                      imgAsset: images,
                                    )));
                          } else {
                            showWarningSnack(context, 'Not enough sugo coins!');
                          }
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ErrandLocation(
                              tags: widget.tags,
                              fee: _feeController.text,
                              notes: _notesController.text,
                              paymenttype: _value,
                              imgPath: imgPaths,
                              imgAsset: images,
                            ),
                          ));
                        }
                      }
                    },
                    color: primaryColor,
                    splashColor: secondaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    child: buildLabelText(
                        'Next', 14.0, Colors.white, FontWeight.normal)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showOverlay() {
    // setTutorialShowOverlayHook((String tagName) => print('showing'));
    createTutorialOverlay(
        tagName: 'photo',
        context: context,
        bgColor: Colors.black.withOpacity(0.8),
        onTap: () {
          print('tap');
          hideOverlayEntryIfExists();
          showOverlayEntry(tagName: 'tags');
        },
        widgetsData: <WidgetData>[
          WidgetData(
              key: photoKey,
              isEnabled: false,
              padding: 4,
              shape: WidgetShape.Rect),
        ],
        description: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Material(
              type: MaterialType.transparency,
              child: buildLabelText(
                  'You can add a photo to help describe your errand.',
                  18.0,
                  Colors.white,
                  FontWeight.normal),
            ),
          ),
        ));
    createTutorialOverlay(
        tagName: 'tags',
        context: context,
        bgColor: Colors.black.withOpacity(0.8),
        onTap: () {
          print('tap');
          hideOverlayEntryIfExists();
          showOverlayEntry(tagName: 'notes');
        },
        widgetsData: <WidgetData>[
          WidgetData(
              key: tagsKey,
              isEnabled: false,
              padding: 4,
              shape: WidgetShape.Rect),
        ],
        description: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Material(
              type: MaterialType.transparency,
              child: buildLabelText(
                  'Your errand tags', 18.0, Colors.white, FontWeight.normal),
            ),
          ),
        ));
    createTutorialOverlay(
        tagName: 'notes',
        context: context,
        bgColor: Colors.black.withOpacity(0.8),
        onTap: () {
          print('tap');
          hideOverlayEntryIfExists();
          showOverlayEntry(tagName: 'fee');
        },
        widgetsData: <WidgetData>[
          WidgetData(
              key: notesKey,
              isEnabled: false,
              padding: 4,
              shape: WidgetShape.Rect),
        ],
        description: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Material(
              type: MaterialType.transparency,
              child: buildLabelText(
                  'Describe what would you like to do to your errand.',
                  18.0,
                  Colors.white,
                  FontWeight.normal),
            ),
          ),
        ));
    createTutorialOverlay(
        tagName: 'fee',
        context: context,
        bgColor: Colors.black.withOpacity(0.8),
        onTap: () {
          print('tap');
          hideOverlayEntryIfExists();
          showOverlayEntry(tagName: 'paymenttype');
        },
        widgetsData: <WidgetData>[
          WidgetData(
              key: payKey,
              isEnabled: false,
              padding: 4,
              shape: WidgetShape.Rect),
        ],
        description: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Material(
              type: MaterialType.transparency,
              child: buildLabelText(
                  'Set your desired service fee not less than the minimum service set by SUGO.',
                  18.0,
                  Colors.white,
                  FontWeight.normal),
            ),
          ),
        ));
    createTutorialOverlay(
        tagName: 'paymenttype',
        context: context,
        bgColor: Colors.black.withOpacity(0.8),
        onTap: () {
          print('tap');
          hideOverlayEntryIfExists();
        },
        widgetsData: <WidgetData>[
          WidgetData(
              key: typeKey,
              isEnabled: false,
              padding: 4,
              shape: WidgetShape.Rect),
        ],
        description: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Material(
              type: MaterialType.transparency,
              child: buildLabelText(
                  'Choose what type of payment would you like.',
                  18.0,
                  Colors.white,
                  FontWeight.normal),
            ),
          ),
        ));
  }
}
