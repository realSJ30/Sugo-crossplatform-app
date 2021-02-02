import 'package:cloud_firestore/cloud_firestore.dart';

class Photos {
  final String photouid;
  final String name;
  final String imgPath;
  final Timestamp timestamp;

  Photos({this.photouid, this.name, this.imgPath, this.timestamp});
}
