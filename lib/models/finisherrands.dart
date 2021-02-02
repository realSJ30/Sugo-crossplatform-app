import 'package:cloud_firestore/cloud_firestore.dart';

class FinishedErrands {
  final String errandid;
  final double rating;
  final Timestamp time;

  FinishedErrands({this.errandid, this.rating, this.time});
}
