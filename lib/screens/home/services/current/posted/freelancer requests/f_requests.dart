import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugoapp/models/freelancer.dart';
import 'package:sugoapp/models/posts.dart';
import 'package:sugoapp/screens/home/services/current/posted/freelancer%20requests/f_requestlist.dart';
import 'package:sugoapp/services/servicesdatabase.dart';
import 'package:sugoapp/shared/widgets.dart';

class FreelancerRequests extends StatefulWidget {
  final Post post;
  FreelancerRequests({this.post});
  @override
  _FreelancerRequestsState createState() => _FreelancerRequestsState();
}

class _FreelancerRequestsState extends State<FreelancerRequests> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: appBar('Requests'),
            body: StreamProvider<List<Freelancer>>.value(
                value: ServicesDatabase(postid: widget.post.postID).freelancers,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FreelancerRequestList(
                      post: widget.post,
                    ),
                  ),
                ))));
  }
}
