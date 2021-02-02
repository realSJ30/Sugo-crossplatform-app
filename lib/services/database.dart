import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sugoapp/shared/constants.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});
  //collection reference
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('profile');
  final CollectionReference _userTypeCollection =
      FirebaseFirestore.instance.collection('user type');
  final CollectionReference _renewalsCollection =
      FirebaseFirestore.instance.collection('renewals');

  //sets the profile data
  Future updateUserData({
    String account,
    String fname,
    String lname,
    String mname,
    String gender,
    String bday,
    String contact,
    String email,
    String idtype,
    String imgpath,
  }) async {
    return await _userCollection.doc(uid).set({
      'account': account,
      'firstname': fname,
      'lastname': lname,
      'middlename': mname,
      'gender': gender,
      'contact': contact,
      'email': email,
      'idtype': idtype,
      'imgpath': imgpath,
      'status': 'enabled',
      'credits': 0
    });
  }

  //updates specific data...
  Future updateFullName(String fname, String mname, String lname) async {
    return await _userCollection.doc(uid).update({
      'firstname': fname,
      'middlename': mname,
      'lastname': lname,
    });
  }

  //updates single data in userprofile
  Future updateUserProfileData(String key, String data) async {
    return await _userCollection.doc(uid).update({key: data});
  }

  //sets the users newuser to yes if bgong user ba sya first time logging in
  Future newUser() async {
    return await _userTypeCollection.doc(uid).set({'newuser': 'yes'});
  }

  //sets the users newuser to no kumbaga dli na sya new user old user na
  Future oldUser() async {
    return await _userTypeCollection.doc(uid).set({'newuser': 'no'});
  }

  //validates the user account if new user ba first login
  Future validatesNewUser() async {
    return await _userTypeCollection
        .doc(uid)
        .get()
        .then((DocumentSnapshot snap) => snap.data()['newuser'].toString());
  }

  Future getUserProfile() async {
    return await _userCollection
        .doc(uid)
        .get()
        .then((DocumentSnapshot snap) => snap.data);
  }

  //deletes the users current usertype ktng new user or not applicable sa cancel rani sa registration
  Future deleteCurrentUserTypeCollection() async {
    User user = FirebaseAuth.instance.currentUser;
    print('id: ${user.uid}');
    // ignore: await_only_futures
    return await _userTypeCollection.doc(await user.uid).delete();
  }

  //gets userprofile stream (firstname,gender,contact)
  Stream<DocumentSnapshot> get userprofile {
    return _userCollection.doc(uid).snapshots();
  }

  //every finished errands mg add kag commission sa renewal collections
  Future addCommissions({String postid, double commissionsfee}) async {
    return await _renewalsCollection
        .doc(uid)
        .collection('commissions')
        .doc(postid)
        .set({'date': Timestamp.now(), 'commission fee': commissionsfee});
  }

  Future getTotalCommissionFee() async {
    try {
      double totalComFee = 0;
      Timestamp renewalDateBefore = await _renewalsCollection
          .doc(uid)
          .get()
          .then((value) => value.data()['renewal date']);
      var renewalDateBeforeMircrosec = renewalDateBefore.microsecondsSinceEpoch;

      var dateofRenewal =
          DateTime.fromMicrosecondsSinceEpoch(renewalDateBeforeMircrosec);
      var thirtydaysBeforeRenewal = dateofRenewal.subtract(Duration(days: 30));

      var comQuery = _renewalsCollection.doc(uid).collection('commissions');
      var docSnapshot = await comQuery.get();
      // print(docSnapshot.docs[0].data());
      for (var doc in docSnapshot.docs) {
        Timestamp date = doc.data()['date'];
        var convertedDate =
            DateTime.fromMicrosecondsSinceEpoch(date.microsecondsSinceEpoch);
        if (convertedDate.isBefore(dateofRenewal) &&
            convertedDate.isAfter(thirtydaysBeforeRenewal)) {
          totalComFee += double.parse(doc.data()['commission fee'].toString());
        }
      }
      return totalComFee;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
