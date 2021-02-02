//request , current , past

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sugoapp/models/finisherrands.dart';
import 'package:sugoapp/models/freelancer.dart';
import 'package:sugoapp/models/posts.dart';
import 'package:sugoapp/models/userprofile.dart';
import 'package:sugoapp/services/profiledatabase.dart';

class ServicesDatabase {
  final String uid;
  final String postid;
  ServicesDatabase({this.uid, this.postid});

  final CollectionReference _postCollection =
      FirebaseFirestore.instance.collection('posts');

  //post request to firebase
  Future postRequest(
      {String userid,
      String tags,
      String notes,
      String fee,
      String paymentType,
      String address1,
      String address2,
      String latlng,
      String date,
      String status,
      List<String> urls}) async {
    return await _postCollection.doc().set({
      'user id': userid,
      'tags': tags,
      'notes': notes,
      'fee': fee,
      'payment type': paymentType,
      'address 1': address1,
      'address 2': address2,
      'position': latlng,
      'posted date': date,
      'status': status,
      'photos': urls,
      'timestamp': FieldValue.serverTimestamp()
    });
  }

  //get posts as your posted services
  Stream<List<Post>> get posts {
    return _postCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(_postListFromSnapshot);
  }

  //pag query kay details sa data(document) ang document kay id sa isa ka data
  List<Post> _postListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Post(
          postID: doc.id,
          userid: doc.data()['user id'] ?? '',
          address1: doc.data()['address 1'] ?? '',
          address2: doc.data()['address 2'] ?? '',
          tags: doc.data()['tags'] ?? '',
          fee: doc.data()['fee'] ?? '',
          notes: doc.data()['notes'] ?? '',
          paymentType: doc.data()['payment type'] ?? '',
          position: doc.data()['position'] ?? '',
          postedDate: doc.data()['posted date'] ?? '',
          status: doc.data()['status'],
          photos: List.from(doc.data()['photos']) ??
              []); //pasabot anang question mark is kng wla nag exist ireturn niya kay empty string or kng integer man 0
    }).toList();
  }

  Future<List<Post>> postListFromFinishedErrands(
      List<FinishedErrands> finished) async {
    List<Post> post = [];

    try {
      for (int i = 0; i < finished.length; i++) {
        await _postCollection.doc(finished[i].errandid).get().then((doc) {
          post.add(Post(
              postID: doc.id,
              userid: doc.data()['user id'] ?? '',
              address1: doc.data()['address 1'] ?? '',
              address2: doc.data()['address 2'] ?? '',
              tags: doc.data()['tags'] ?? '',
              fee: doc.data()['fee'] ?? '',
              notes: doc.data()['notes'] ?? '',
              paymentType: doc.data()['payment type'] ?? '',
              position: doc.data()['position'] ?? '',
              postedDate: doc.data()['posted date'] ?? '',
              status: doc.data()['status'],
              time: doc.data()['timestamp'] ?? FieldValue.serverTimestamp(),
              photos: List.from(doc.data()['photos']) ?? []));
        });
      }
      //sort the date
      post.sort((a, b) {
        return b.time.compareTo(a.time);
      });

      return post;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //gets single post
  Stream<Post> get posted {
    return _postCollection.doc(postid).snapshots().map((doc) {
      return Post(
          postID: doc.id,
          userid: doc.data()['user id'] ?? '',
          address1: doc.data()['address 1'] ?? '',
          address2: doc.data()['address 2'] ?? '',
          tags: doc.data()['tags'] ?? '',
          fee: doc.data()['fee'] ?? '',
          notes: doc.data()['notes'] ?? '',
          paymentType: doc.data()['payment type'] ?? '',
          position: doc.data()['position'] ?? '',
          postedDate: doc.data()['posted date'] ?? '',
          status: doc.data()['status'],
          photos: List.from(doc.data()['photos']) ??
              []); //pasabot anang question mark is kng wla nag exist ireturn niya kay empty string or kng integer man 0
    });
  }

  Future deletePost() async {
    return await _postCollection.doc(postid).delete();
  }

  //SEND REQUEST TO CLIENTS POST FUNCTIONS
  Future sendRequest(String freelancerUID) async {
    return await _postCollection
        .doc(postid)
        .collection('requests')
        .doc(freelancerUID)
        .set({'chosen': false});
  }

  //read request button if already requested returns true if nakarequest false if wla pa
  Future ifAlreadyRequested(String freelancerUID) async {
    return await _postCollection
        .doc(postid)
        .collection('requests')
        .doc(freelancerUID)
        .get();
  }

  //get total Request from a certain Post
  Future totalRequests() async {
    var postQuery = _postCollection.doc(postid).collection('requests');
    var docSnapshot = await postQuery.get();
    var total = docSnapshot.docs.length;
    return total;
  }

  //get the specific freelancer who got accepted to do the errand
  Future getAcceptedFreelancerProfile() async {
    try {
      var postQuery = _postCollection.doc(postid).collection('requests');
      var docSnapshot = await postQuery.get();
      // print(docSnapshot.docs[0].data());
      for (var doc in docSnapshot.docs) {
        if (doc.data()['chosen']) {
          return await ProfileDatabase(uid: doc.id).getProfileName();
        }
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
    return null;
  }

  Future getAcceptedFreelancerContact() async {
    try {
      var postQuery = _postCollection.doc(postid).collection('requests');
      var docSnapshot = await postQuery.get();
      // print(docSnapshot.docs[0].data());
      for (var doc in docSnapshot.docs) {
        if (doc.data()['chosen']) {
          return await ProfileDatabase(uid: doc.id).getProfileContact();
        }
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
    return null;
  }

  //get the specific freelancer who got accepted to do the errand
  Future getAcceptedFreelancerUID() async {
    try {
      var postQuery = _postCollection.doc(postid).collection('requests');
      var docSnapshot = await postQuery.get();
      // print(docSnapshot.docs[0].data());
      for (var doc in docSnapshot.docs) {
        if (doc.data()['chosen']) {
          return doc.id;
        }
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
    return null;
  }

  //get Errand Name/ Type
  Future getErrandType() async {
    var postQuery = _postCollection.doc(postid);
    var docSnapshot = await postQuery.get();
    return docSnapshot.data()['tags'];
  }

  //get userid of POST
  Future getUserIDofPost() async {
    var postQuery = _postCollection.doc(postid);
    var docSnapshot = await postQuery.get();
    return docSnapshot.data()['user id'];
  }

  //get POST status
  Future getPostStatus() async {
    var postQuery = _postCollection.doc(postid);
    var docSnapshot = await postQuery.get();
    return docSnapshot.data()['status'];
  }

  //get the freelancer UID
  Future getFreelancerUIDfromRequests() async {
    var postQuery = _postCollection.doc(postid).collection('requests');
    var docSnapshot = await postQuery.get();
    for (var doc in docSnapshot.docs) {
      if (doc.data()['chosen']) {
        return doc.id.toString();
      }
    }
    return null;
  }

  //for viewing profiles nga nag request saimong post as a list
  Stream<List<Freelancer>> get freelancers {
    return _postCollection
        .doc(postid)
        .collection('requests')
        .snapshots()
        .map(_freelancerRequestFromSnapshot);
  }

  List<Freelancer> _freelancerRequestFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Freelancer(chosen: doc.data()['chosen'] ?? false, uid: doc.id);
    }).toList();
  }

  Future verifyAndWorkErrandRequest(String freelanceruid) async {
    return await _postCollection
        .doc(postid)
        .collection('requests')
        .doc(freelanceruid)
        .update({'chosen': true}).then((val) async {
      return await _updatePostedErrandtoOngoing();
    });
  }

  Future _updatePostedErrandtoOngoing() async {
    return await _postCollection.doc(postid).update({'status': 'on going'});
  }

  Future updatePostedErrandStatus({String status}) async {
    return await _postCollection.doc(postid).update({'status': status});
  }

  //get the specific freelancer who got accepted to do the errand
  Future getTotalEarningsofToday({List<FinishedErrands> finished}) async {
    try {
      double totalAmount = 0;
      for (int i = 0; i < finished.length; i++) {
        var postQuery = _postCollection.doc(finished[i].errandid).get();
        var docSnapshot = await postQuery;
        totalAmount += double.parse(docSnapshot.data()['fee'].toString());
      }
      return totalAmount;
    } catch (e) {
      print(e.toString());
      return 0.0;
    }
  }
}
