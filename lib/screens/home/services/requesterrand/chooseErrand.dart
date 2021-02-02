import 'package:flutter/material.dart';
import 'package:sugoapp/screens/home/services/requesterrand/requestInformation.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';
import 'package:tuxin_tutorial_overlay/TutorialOverlayUtil.dart';
import 'package:tuxin_tutorial_overlay/WidgetData.dart';

class ChooseRequestErrand extends StatefulWidget {
  @override
  _ChooseRequestErrandState createState() => _ChooseRequestErrandState();
}

class _ChooseRequestErrandState extends State<ChooseRequestErrand> {
  final GlobalKey helpButtonKey = GlobalKey();
  final GlobalKey errandone = GlobalKey();
  final GlobalKey errandtwo = GlobalKey();
  String tags = '';
  int tagCount = 0;
  Map<String, bool> tagvalues = {
    'Cleaning': false,
    'Medicine': false,
    'Repair': false,
    'Grocery': false,
    'Food': false,
    'Others': false,
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                showOverlayEntry(tagName: 'errand');
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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  buildSubLabelText(
                      'Errand Tags', 16.0, Colors.grey, FontWeight.normal)
                ],
              ),
            ),
            errandContainer(
                'images/icons/cleaning.png', 'Cleaning', tagvalues['Cleaning'],
                ontap: () {
              this.setState(() {
                tagvalues['Cleaning'] = !tagvalues['Cleaning'];
              });
              setTagActive(tagvalues['Cleaning']);
            }, key: errandone),
            errandContainer('images/icons/prescription.png', 'Medicine',
                tagvalues['Medicine'], ontap: () {
              this.setState(() {
                tagvalues['Medicine'] = !tagvalues['Medicine'];
              });
              setTagActive(tagvalues['Medicine']);
            }, key: errandtwo),
            errandContainer(
                'images/icons/repair.png', 'Repair', tagvalues['Repair'],
                ontap: () {
              this.setState(() {
                tagvalues['Repair'] = !tagvalues['Repair'];
              });
              setTagActive(tagvalues['Repair']);
            }),
            errandContainer(
                'images/icons/grocery.png', 'Grocery', tagvalues['Grocery'],
                ontap: () {
              this.setState(() {
                tagvalues['Grocery'] = !tagvalues['Grocery'];
              });
              setTagActive(tagvalues['Grocery']);
            }),
            errandContainer('images/icons/food.png', 'Food', tagvalues['Food'],
                ontap: () {
              this.setState(() {
                tagvalues['Food'] = !tagvalues['Food'];
              });
              setTagActive(tagvalues['Food']);
            }),
            errandContainer(
                'images/icons/others.png', 'Others', tagvalues['Others'],
                ontap: () {
              this.setState(() {
                tagvalues['Others'] = !tagvalues['Others'];
              });
              setTagActive(tagvalues['Others']);
            }),
          ],
        ),
        floatingActionButton: nextButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  void setTagActive(bool value) {
    this.setState(() {
      if (value) {
        this.tagCount++;
      } else {
        if (tagCount > 0) {
          this.tagCount--;
        }
      }
    });
  }

  Widget nextButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          Expanded(
            child: Builder(
              builder: (context) => ButtonTheme(
                height: 50.0,
                child: RaisedButton(
                    onPressed: () async {
                      if (tagCount > 0) {
                        this.setState(() {
                          this.tags = '';
                        });
                        for (var tag in tagvalues.keys) {
                          if (tagvalues[tag]) {
                            this.setState(() {
                              this.tags += '$tag, ';
                            });
                          }
                        }
                        this.setState(() {
                          this.tags =
                              this.tags.substring(0, this.tags.length - 2);
                        });

                        print(tags);
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) => RequestInformation(
                                tags: this.tags,
                              ),
                            ));
                      } else {
                        showWarningSnack(
                            context, 'Choose atleast one errand tag.');
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

  Widget errandContainer(String icon, String label, bool tagvalue,
      {VoidCallback ontap, GlobalKey key}) {
    return Padding(
      key: key,
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.white,
        child: InkWell(
          child: ListTile(
            leading: Image.asset(
              icon,
              width: 35.0,
            ),
            title: buildLabelText(label, 14.0, Colors.black, FontWeight.bold),
            trailing: Icon(
              Icons.check,
              color: tagvalue ? Colors.blue : Colors.white,
              size: 35,
            ),
          ),
          onTap: ontap,
        ),
      ),
    );
  }

  void showOverlay() {
    // setTutorialShowOverlayHook((String tagName) => print('showing'));
    createTutorialOverlay(
        tagName: 'errand',
        context: context,
        bgColor: Colors.black.withOpacity(0.8),
        onTap: () {
          print('tap');
          hideOverlayEntryIfExists();
          showOverlayEntry(tagName: 'nextone');
        },
        widgetsData: <WidgetData>[
          WidgetData(
              key: errandone,
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
                  'Choose a tag for which type your errand belongs.',
                  18.0,
                  Colors.white,
                  FontWeight.normal),
            ),
          ),
        ));
    createTutorialOverlay(
        tagName: 'nextone',
        context: context,
        bgColor: Colors.black.withOpacity(0.8),
        onTap: () {
          print('tap');
          hideOverlayEntryIfExists();
          // showOverlayEntry(tagName: 'next one');
        },
        widgetsData: <WidgetData>[
          WidgetData(
              key: errandtwo,
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
              child: buildLabelText('You can choose more than one tag.', 18.0,
                  Colors.white, FontWeight.normal),
            ),
          ),
        ));
  }
}
