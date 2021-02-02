// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:sugoapp/screens/home/services/current/currentservice.dart';
// import 'package:sugoapp/screens/home/services/past/past.dart';
// import 'package:sugoapp/screens/home/services/request/chooserequest.dart';
// import 'package:sugoapp/screens/home/services/request/requestservice.dart';

// import 'package:sugoapp/shared/constants.dart';
// import 'package:sugoapp/shared/widgets.dart';

// class CarouselChoice extends StatefulWidget {
//   @override
//   _CarouselChoiceState createState() => _CarouselChoiceState();
// }

// class _CarouselChoiceState extends State<CarouselChoice> {
//   int _currentIndex = 0;
//   @override
//   Widget build(BuildContext context) {
//     //LIST OF WIDGET CHOICE
//     List<Widget> _choice = [
//       carouselContainer(
//         'REQUEST ERRAND',
//         'Post your errand and ask others for help.',
//         'images/icons/Request a service.png',
//       ),
//       carouselContainer(
//         'CURRENT ERRANDS',
//         'Your ongoing, unfinished errands.',
//         'images/icons/Current Services A.png',
//       ),
//       carouselContainer(
//         'PAST ERRANDS',
//         'Your past services, finished errands.',
//         'images/icons/Past Services A.png',
//       ),
//     ];

//     //MAIN OUTPUT WIDGET
//     return Expanded(
//       child: Container(
//         color: Colors.white,
//         // height: getMediaQueryHeightViaMinus(context, 179),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: CarouselSlider(
//             items: _choice.map((e) {
//               return Builder(builder: (BuildContext context) {
//                 return e;
//               });
//             }).toList(),
//             options: CarouselOptions(
//               initialPage: _currentIndex,
//               onPageChanged: (index, reason) {
//                 setState(() {
//                   _currentIndex = index;
//                 });
//               },
//               height: 400.0,
//               enlargeCenterPage: true,
//               viewportFraction: 0.8,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // CAROUSEL CONTAINER
//   Widget carouselContainer(String label, String text, String img) {
//     return Stack(
//       children: <Widget>[
//         Container(
//           width: getMediaQueryWidthViaMinus(context, 50),
//           height: getMediaQueryHeightViaMinus(context, 50),
//           margin: EdgeInsets.symmetric(horizontal: 5.0),
//           decoration: BoxDecoration(
//               color: Colors.blue[20],
//               borderRadius: BorderRadius.circular(25),
//               image: DecorationImage(
//                   image: ExactAssetImage(img), fit: BoxFit.fill)),
//         ),
//         Container(
//           width: getMediaQueryWidthViaMinus(context, 50),
//           height: getMediaQueryHeightViaMinus(context, 50),
//           margin: EdgeInsets.symmetric(horizontal: 5.0),
//           decoration: BoxDecoration(
//             color: Colors.blue.withOpacity(0.2),
//             borderRadius: BorderRadius.circular(25),
//           ),
//         ),
//         Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: <Widget>[
//             Container(
//               width: getMediaQueryWidthViaMinus(context, 50),
//               margin: EdgeInsets.symmetric(horizontal: 5.0),
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.7),
//                 borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(25),
//                     bottomRight: Radius.circular(25)),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     separator(6.0),
//                     buttonService(label),
//                     separator(10.0),
//                     buildLabelText(text, 12.0, Colors.white, FontWeight.normal),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   // BUTTON SERVICE (e.g. request, current, past)
//   Widget buttonService(String label) {
//     return ButtonTheme(
//       height: getMediaQueryHeightViaDivision(context, 14),
//       minWidth: 200.0,
//       child: RaisedButton(
//         onPressed: () async {
//           if (label == 'REQUEST ERRAND') {
//             Navigator.of(context).push(MaterialPageRoute(
//                 builder: (context) => RequestService(
//                       child: ChooseRequest(),
//                     )));
//             print('REQUEST is Pressed!');
//           } else if (label == 'CURRENT ERRANDS') {
//             Navigator.of(context).push(
//                 MaterialPageRoute(builder: (context) => CurrentService()));
//             print('CURRENT is Pressed!');
//           } else {
//             Navigator.of(context)
//                 .push(MaterialPageRoute(builder: (context) => Past()));
//             print('PAST is Pressed!');
//           }
//         },
//         color: primaryColor,
//         splashColor: secondaryColor,
//         shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
//         child: buildSubLabelText(label, 22.0, Colors.white, FontWeight.normal),
//       ),
//     );
//   }
// }
