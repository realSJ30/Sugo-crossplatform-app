class Msg {
  final String msg;
  final String from;
  final String createdAt;
  final bool isRead;
  final String url;

  Msg({this.msg, this.from, this.createdAt, this.isRead, this.url});
}

class ChatInbox {
  final String clientUID;
  final String freelancerUID;
  final String createdAt;
  final String errandID;

  ChatInbox(
      {this.clientUID, this.freelancerUID, this.createdAt, this.errandID});
}
