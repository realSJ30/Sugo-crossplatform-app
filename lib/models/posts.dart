import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String postID;
  final String userid;
  final String address1;
  final String address2;
  final String tags;
  final String fee;
  final String notes;
  final String paymentType;
  final String position;
  final String postedDate;
  final String requests;
  final String status;
  final List<dynamic> photos;
  final Timestamp time;

  Post(
      {this.time,
      this.postID,
      this.userid,
      this.address1,
      this.address2,
      this.tags,
      this.fee,
      this.notes,
      this.paymentType,
      this.position,
      this.postedDate,
      this.requests,
      this.status,
      this.photos});
}
