import 'package:flutter/material.dart';
import 'package:sugoapp/models/posts.dart';

class ErrandIcon extends StatelessWidget {
  final Post post;
  ErrandIcon({this.post});

  final List<String> iconPath = [
    'images/icons/cleaning.png',
    'images/icons/prescription.png',
    'images/icons/repair.png',
    'images/icons/grocery.png',
    'images/icons/food.png',
    'images/icons/others.png',
  ];

  String getIconPath() {
    String errand = post.tags;
    switch (errand) {
      case 'Cleaning':
        return iconPath[0];
        break;
      case 'Medicine':
        return iconPath[1];
        break;
      case 'Repair':
        return iconPath[2];
        break;
      case 'Grocery':
        return iconPath[3];
        break;
      case 'Food':
        return iconPath[4];
        break;
      case 'Others':
        return iconPath[5];
        break;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(
        getIconPath(),
        width: 80,
      ),
    );
  }
}
