import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sugoapp/models/msg.dart';

class ChatDatabase {
  final String
      errandID; //chatroom id is mag base sa errand ID bwat transaction kay naay sriling chatroom
  ChatDatabase({this.errandID});

  final CollectionReference _chatCollection =
      FirebaseFirestore.instance.collection('chat');

  //sets the chat room for each transaction based on errand ID ang document ID
  Future createChatRoom({
    String clientUID,
    String freelancerUID,
    String createdAt,
  }) async {
    if (!await _readIfChatRoomAlreadyExisted()) {
      return await _chatCollection.doc(errandID).set({
        'errandID': errandID,
        'freelancer': freelancerUID,
        'client': clientUID,
        'createdAt': createdAt,
        'timestamp': FieldValue.serverTimestamp()
      });
    }
    return null;
  }

  Future _readIfChatRoomAlreadyExisted() async {
    var chatQuery = await _chatCollection.doc(errandID).get();
    return chatQuery.exists;
  }

  //sets the message inside chat room
  Future sendMessage(
      {String from, String msg, String createdAt, String url}) async {
    return await _chatCollection.doc(errandID).collection('messages').add({
      'message': msg,
      'url': url,
      'from': from,
      'createdAt': createdAt,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false
    });
  }

  //stream of msgs
  Stream<List<Msg>> get msgs {
    return _chatCollection
        .doc(errandID)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(_msgListFromSnapshots);
  }

  //get the list messages
  List<Msg> _msgListFromSnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Msg(
          createdAt: doc.data()['createdAt'],
          from: doc.data()['from'],
          isRead: doc.data()['isRead'] ?? false,
          url: doc.data()['url'] ?? '',
          msg: doc.data()['message']);
    }).toList();
  }

  Stream<List<ChatInbox>> get chats {
    return _chatCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(_chatinboxListFromSnapshots);
  }

  List<ChatInbox> _chatinboxListFromSnapshots(QuerySnapshot snap) {
    return snap.docs.map((e) {
      return ChatInbox(
        clientUID: e.data()['client'],
        createdAt: e.data()['createdAt'],
        errandID: e.data()['errandID'],
        freelancerUID: e.data()['freelancer'],
      );
    }).toList();
  }

  Future updateMessageRead({String uid}) async {
    try {
      var postQuery = _chatCollection.doc(errandID).collection('messages');
      var docSnapshot = await postQuery.get();
      // print(docSnapshot.docs[0].data());
      for (var doc in docSnapshot.docs) {
        //meaning dli saimo gikan ang chat so iupdate nimo to seen
        if (doc.data()['from'] != uid) {
          await _chatCollection
              .doc(errandID)
              .collection('messages')
              .doc(doc.id)
              .update({
            'isRead': true,
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
