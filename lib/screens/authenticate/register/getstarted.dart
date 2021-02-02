import 'package:flutter/material.dart';
import 'package:sugoapp/screens/authenticate/register/register.dart';
import 'package:sugoapp/screens/authenticate/register/tellusyourname.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';

class GettingStarted extends StatefulWidget {
  @override
  _GettingStartedState createState() => _GettingStartedState();
}

class _GettingStartedState extends State<GettingStarted> {
  int _currentPage = 0;
  final slideList = [
    Slide(
        imageUrl: 'images/icons/Request a service.png',
        title: 'Request Service',
        description: 'Let others help you finish your errands.'),
    Slide(
        imageUrl: 'images/icons/Current Services A.png',
        title: 'Earn money',
        description:
            'Earn money by doing different errands. Shop, \nRepair, Clean and many more errands\nyou can take.'),
    Slide(
        imageUrl: 'images/icons/Past Services A.png',
        title: 'Keep in record',
        description: 'Keep track of your errands and services.'),
  ];

  final PageController _pageController = PageController(initialPage: 0);

  _onPageChange(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void goToNextPage() {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (context) => Register(
              TellusYourName(),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getMediaQueryHeightViaDivision(context, 1.08),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChange,
                scrollDirection: Axis.horizontal,
                itemCount: slideList.length,
                itemBuilder: (ctx, i) => itemContainer(context, i),
              ),
              Stack(
                alignment: AlignmentDirectional.topStart,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 35),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        for (int i = 0; i < slideList.length; i++)
                          if (i == _currentPage)
                            slideDots(true)
                          else
                            slideDots(false)
                      ],
                    ),
                  )
                ],
              )
            ],
          )),
          getStartedButton(context),
          cancelButton(context)
        ],
      ),
    );
  }

  Widget getStartedButton(BuildContext context) {
    return ButtonTheme(
      minWidth: getMediaQueryWidthViaMinus(context, 50),
      height: 50.0,
      child: RaisedButton(
          onPressed: () {
            print('getting started was pressed!');
            goToNextPage();
          },
          color: primaryColor,
          splashColor: secondaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: buildLabelText(
              'Getting Started', 14.0, Colors.white, FontWeight.normal)),
    );
  }

  Widget itemContainer(BuildContext context, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: getMediaQueryWidthViaDivision(context, 1),
          height: getMediaQueryHeightViaDivision(context, 2.5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: AssetImage(slideList[index].imageUrl),
                fit: BoxFit.cover),
          ),
        ),
        separator(8.0),
        buildSubLabelText(
            slideList[index].title, 22.0, primaryColor, FontWeight.normal),
        buildLabelText(slideList[index].description, 14.0, Colors.blueGrey,
            FontWeight.normal)
      ],
    );
  }

  Widget slideDots(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: isActive ? 14 : 8,
      width: isActive ? 14 : 8,
      decoration: BoxDecoration(
          color: isActive ? primaryColor : Colors.blueGrey,
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }
}

class Slide {
  final String imageUrl;
  final String title;
  final String description;

  Slide(
      {@required this.imageUrl,
      @required this.title,
      @required this.description});
}
