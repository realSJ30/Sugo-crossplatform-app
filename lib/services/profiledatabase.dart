import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart' as fm;
import 'package:sugoapp/models/finisherrands.dart';
import 'package:sugoapp/models/logs.dart';
import 'package:sugoapp/models/photos.dart';
import 'package:sugoapp/models/userprofile.dart';
import 'package:sugoapp/shared/string_extension.dart';

class ProfileDatabase {
  final String uid;
  ProfileDatabase({this.uid});

  final CollectionReference _profileCollection =
      FirebaseFirestore.instance.collection('profile');

  Stream<UserProfile> get profile {
    return _profileCollection
        .doc(uid)
        .snapshots()
        .map(_userProfileFromSnapshot);
  }

  Future updateUserData({String field, dynamic data}) async {
    return await _profileCollection.doc(uid).update({field: data});
  }

  UserProfile _userProfileFromSnapshot(DocumentSnapshot snapshot) {
    print('skills: ${snapshot.data()['skills']}');
    return UserProfile(
        account: snapshot.data()['account'] ?? '',
        contact: snapshot.data()['contact'] ?? '',
        email: snapshot.data()['email'] ?? '',
        firstname: snapshot.data()['firstname'] ?? '',
        gender: snapshot.data()['gender'] ?? '',
        idtype: snapshot.data()['idtype'] ?? '',
        imgpath: snapshot.data()['imgpath'] ?? '',
        lastname: snapshot.data()['lastname'] ?? '',
        middlename: snapshot.data()['middlename'] ?? '',
        status: snapshot.data()['status'] ?? '',
        credits: double.parse(snapshot.data()['credits'].toString()) ?? 0.00,
        skills: snapshot.data()['skills'] ?? ['N/A']);
  }

  Future getProfileName() async {
    return await _profileCollection.doc(uid).get().then(
        (DocumentSnapshot snap) => _fullName(
            snap.data()['firstname'].toString(),
            snap.data()['middlename'].toString(),
            snap.data()['lastname'].toString()));
  }

  Future getProfileContact() async {
    return await _profileCollection
        .doc(uid)
        .get()
        .then((DocumentSnapshot snap) => snap.data()['contact'].toString());
  }

  Future getUserFields({String field}) async {
    return await _profileCollection.doc(uid).get().then((val) {
      print('contact: ${val.data()[field].toString()}');
      return val.data()[field].toString();
    });
  }

  Future<double> getCredits() async {
    return await _profileCollection
        .doc(uid)
        .get()
        .then((value) => double.parse(value.data()['credits'].toString()));
  }

  //gets the profile android token
  Future<List<DocumentSnapshot>> getProfileToken() async {
    var collection =
        await _profileCollection.doc(uid).collection('device token').get();
    final List<DocumentSnapshot> result = collection.docs;
    print('result: ${result.length}');
    print('result: ${result.map((e) => e.id)}');
    return result;
  }

  //reads if the doc existed in the waiting jobs
  Future<bool> checkIfAlreadyAccepted(String postID) async {
    bool exist = false;
    try {
      await _profileCollection
          .doc(uid)
          .collection('waiting jobs')
          .doc(postID)
          .get()
          .then((value) {
        value.exists ? exist = true : exist = false;
      });
      return exist;
    } catch (e) {
      return false;
    }
  }

  String _fullName(String f, String m, String l) {
    String fullname = '${f.capitalize()} ${m.capitalize()}. ${l.capitalize()}';
    return fullname;
  }

  //sets device token to profile for the device that was used to login for push notification
  Future setUserDeviceToken() async {
    final fm.FirebaseMessaging _fcm = fm.FirebaseMessaging();
    String fcmToken = await _fcm.getToken();
    try {
      await _profileCollection
          .doc(uid)
          .collection('device token')
          .get()
          .then((value) {
        for (DocumentSnapshot ds in value.docs) {
          ds.reference.delete();
        }
      });
    } catch (e) {}

    return fcmToken != null
        ? await _profileCollection
            .doc(uid)
            .collection('device token')
            .doc(fcmToken)
            .set({
            'token': fcmToken,
            'created At': FieldValue.serverTimestamp(),
            'platform': Platform.operatingSystem,
          })
        : null;
  }

  Future removeProfileRef() async {
    print('remove collection: $uid');
    return await _profileCollection
        .doc(uid)
        .delete()
        .whenComplete(() => print('success???'));
  }

  //adds waiting jobs to freelancer profile to confirm an errand that was accepted by the client
  Future waitingJobsFromFreelancer(String freelancerUID, String clientUID,
      String postID, String status) async {
    return await _profileCollection
        .doc(freelancerUID)
        .collection('waiting jobs')
        .doc(postID)
        .set({
      'client ID': clientUID,
      'status': status, //either waiting, accepted, denied
    });
  }

  //verify waiting job status if waiting or dli pra sa button sa client
  Future getWaitingJobStatus(String freelancerUID, String postID) async {
    try {
      var status =
          _profileCollection.doc(freelancerUID).collection('waiting jobs');
      var statusDocs = await status.get();
      print(statusDocs.docs.length);
      if (statusDocs.docs.length != 0) {
        return await status
            .doc(postID)
            .get()
            .then((value) => value.data()['status']);
      }
    } catch (e) {
      return 'no status';
    }
    return 'no status';
  }

  Future undoAcceptFreelancer(String freelancerUID, String postID) async {
    return await _profileCollection
        .doc(freelancerUID)
        .collection('waiting jobs')
        .doc(postID)
        .delete();
  }

  Future reportUser(
      {String userID, String postID, String msg, String subject}) async {
    return await _profileCollection
        .doc(userID)
        .collection('reports')
        .doc(postID)
        .set({
      'postID': postID,
      'msg': msg,
      'subject': subject,
      'time': FieldValue.serverTimestamp()
    });
  }

  //top up coins
  Future topUpCredits({double addedvalue, double oldvalue}) async {
    double value = addedvalue + oldvalue;
    return await _profileCollection.doc(uid).update({'credits': value});
  }

  //minus coins
  Future minusCredits({double minusvalue, double oldvalue}) async {
    double value = oldvalue - minusvalue;
    return await _profileCollection.doc(uid).update({'credits': value});
  }

  //update ACCOUNT TYPE
  Future updateAccount({String account}) async {
    return await _profileCollection.doc(uid).update({'account': account});
  }

  //ratings
  Future setRating({String postid, double rating}) async {
    return await _profileCollection
        .doc(uid)
        .collection('finished errands')
        .doc(postid)
        .update({
      'rating': rating,
    });
  }

  //get the average rating
  Future getTotalRating() async {
    var rateQuery = _profileCollection.doc(uid).collection('finished errands');
    var docSnapshot = await rateQuery.get();
    double total = 0.0;
    int totalCount = 0;
    for (var doc in docSnapshot.docs) {
      totalCount++;
      total += double.parse(doc.data()['rating'].toString());
    }
    double finaltotal = total / totalCount;
    print('final: $finaltotal');
    if (finaltotal.isNaN) {
      return 0.0;
    }
    print('final: $finaltotal');
    return finaltotal;
  }

  //get the total accomplished task
  Future getTotalTask() async {
    return await _profileCollection
        .doc(uid)
        .collection('finished errands')
        .get()
        .then((value) {
      print(uid);
      print(value.docs.length);
      return value.docs.length;
    });
  }

  //adds finished errands by the freelancer
  Future addToMyfinishedErrands({String postid}) async {
    return await _profileCollection
        .doc(uid)
        .collection('finished errands')
        .doc(postid)
        .set({'rating': 0, 'time': FieldValue.serverTimestamp()});
  }

  //adds photos to profile collection
  Future uploadPhoto({String name, String url}) async {
    try {
      if (url.isNotEmpty) {
        return await _profileCollection.doc(uid).collection('photos').add({
          'image name': name,
          'url': url,
          'timestamp': FieldValue.serverTimestamp()
        });
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream get accountStatus {
    return _profileCollection.doc(uid).get().then((value) {
      return value.data()['account'];
    }).asStream();
  }

  //get stream of photos
  Stream<List<Photos>> get photos {
    return _profileCollection
        .doc(uid)
        .collection('photos')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(_postListFromSnapshot);
  }

  List<Photos> _postListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Photos(
          photouid: doc.id,
          name: doc.data()['name'] ?? '',
          imgPath: doc.data()['url'] ?? '',
          timestamp: doc.data()['timestamp'] ??
              Timestamp
                  .now()); //pasabot anang question mark is kng wla nag exist ireturn niya kay empty string or kng integer man 0
    }).toList();
  }

  Stream<List<FinishedErrands>> get totalErrandsAsofToday {
    final now = DateTime.now();
    return _profileCollection
        .doc(uid)
        .collection('finished errands')
        .where('time',
            isLessThan: Timestamp.now(),
            isGreaterThan: Timestamp.fromDate(DateTime(
                now.year,
                now.month,
                now.day - 1,
                DateTime.fromMicrosecondsSinceEpoch(
                        Timestamp.now().microsecondsSinceEpoch)
                    .hour,
                DateTime.fromMicrosecondsSinceEpoch(
                        Timestamp.now().microsecondsSinceEpoch)
                    .second)))
        .snapshots()
        .map(_finishedErrandsfromSnapshot);
  }

  Stream<List<FinishedErrands>> get totalErrands {
    return _profileCollection
        .doc(uid)
        .collection('finished errands')
        .snapshots()
        .map(_finishedErrandsfromSnapshot);
  }

  List<FinishedErrands> _finishedErrandsfromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return FinishedErrands(
        time: doc.data()['time'] ?? FieldValue.serverTimestamp(),
        errandid: doc.id,
        rating: double.parse(doc.data()['rating'].toString()) ?? 0,
      );
    }).toList();
  }

  Future deletePhoto({String photouid}) async {
    return await _profileCollection
        .doc(uid)
        .collection('photos')
        .doc(photouid)
        .delete();
  }

  Future cashoutRequest({double amount, String status}) async {
    return await _profileCollection.doc(uid).collection('cashouts').add({
      'timestamp': FieldValue.serverTimestamp(),
      'amount': amount,
      'status': status
    }).then(
        (value) => _addToLogs(id: value.id, subject: 'request', value: amount));
  }

  Future _addToLogs({
    String id,
    String subject,
    double value,
  }) async {
    return await _profileCollection.doc(uid).collection('logs').doc().set({
      'reference': id,
      'subject': subject,
      'timestamp': FieldValue.serverTimestamp(),
      'amount': value,
    });
  }

  Stream<List<Logs>> get logs {
    return _profileCollection
        .doc(uid)
        .collection('logs')
        .snapshots()
        .map(_logsfromSnapshot);
  }

  List<Logs> _logsfromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Logs(
        logid: doc.id,
        reference: doc.data()['reference'],
        subject: doc.data()['subject'],
        timestamp: doc.data()['timestamp'] as Timestamp,
        amount: doc.data()['amount'] as double,
      );
    }).toList();
  }
}
