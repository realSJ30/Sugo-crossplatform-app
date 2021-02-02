import 'dart:convert';
import 'package:http/http.dart' as http;

class PushNotifications {
  final String serverToken =
      'AAAAq-Ntppc:APA91bF3kGrIAcVRVoELQ3qZiy7GwVU2VffiiFgdCUd5yoDG4G8l2Xlgx_cqJW4Wh97VV8wcU7PsZVsP43BsDJEUGxWVtC6ph7ffCnhFdCe278JJcNNWGtGXjJA4a2ZW8xHqW1IkCmYv';
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  //sneds push message sa freelancer nga giaccept na sila sa client as freelancer.
  Future<Map<String, dynamic>> sendPushMessageToFreelancer(
      {dynamic receiverToken,
      String errand,
      String name,
      String postid}) async {
    print(receiverToken);
    await http.post('https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key = $serverToken',
        },
        body: jsonEncode(<String, dynamic>{
          'notification': <String, dynamic>{
            'title': 'Request Approved',
            'body': '$name has approved your request on $errand!',
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            'postid': postid
          },
          'to': receiverToken,
        }));
    return null;
  }

  //if nahuman na sa freelancer pra naay dialog box na pag iclick rate now kay mugawas rating dialog
  Future<Map<String, dynamic>> sendPushMessageErrandFinished({
    dynamic receiverToken,
    String errand,
    String name,
    String postid,
    String freelancerUID,
  }) async {
    print(receiverToken);
    await http.post('https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key = $serverToken',
        },
        body: jsonEncode(<String, dynamic>{
          'notification': <String, dynamic>{
            'title': 'Errand Finished',
            'body': '$name has finished your Errand!\nRate his/her work?',
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            'postid': postid,
            'freelancerUID': freelancerUID
          },
          'to': receiverToken,
        }));
    return null;
  }

  Future<Map<String, dynamic>> sendPushMessageChatMessage({
    dynamic receiverToken,
    String from,
    String msg,
  }) async {
    print(receiverToken);
    await http.post('https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key = $serverToken',
        },
        body: jsonEncode(<String, dynamic>{
          'notification': <String, dynamic>{
            'title': '$from',
            'body': '$msg',
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
          },
          'to': receiverToken,
        }));
    return null;
  }
}
