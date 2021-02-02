import 'package:cloud_firestore/cloud_firestore.dart';

class Logs {
  final String reference;
  final String logid;
  final String subject;
  final double amount;
  final Timestamp timestamp;

  Logs({this.reference, this.logid, this.subject, this.amount, this.timestamp});
}
