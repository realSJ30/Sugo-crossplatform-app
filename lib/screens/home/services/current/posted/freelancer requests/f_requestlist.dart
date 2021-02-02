import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugoapp/models/freelancer.dart';
import 'package:sugoapp/models/posts.dart';
import 'package:sugoapp/screens/home/services/current/posted/freelancer%20requests/f_requesttile.dart';
import 'package:sugoapp/shared/widgets.dart';

class FreelancerRequestList extends StatefulWidget {
  final Post post;
  FreelancerRequestList({this.post});
  @override
  _FreelancerRequestListState createState() => _FreelancerRequestListState();
}

class _FreelancerRequestListState extends State<FreelancerRequestList> {
  var freelancers;
  @override
  Widget build(BuildContext context) {
    freelancers = Provider.of<List<Freelancer>>(context) ?? [];
    return RefreshIndicator(
      onRefresh: refresh,
      child: freelancers.length > 0
          ? ListView.builder(
              itemCount: freelancers.length,
              itemBuilder: (context, index) {
                return FreelancerRequestTile(
                  freelancer: freelancers[index],
                  post: widget.post,
                );
              },
            )
          : Container(
              child: Center(
                child: buildLabelText(
                    'No Request yet.', 14.0, Colors.grey, FontWeight.normal),
              ),
            ),
    );
  }

  Future refresh() async {
    await Future.delayed(Duration(seconds: 1));
    this.setState(() {
      freelancers = Provider.of<List<Freelancer>>(context) ?? [];
    });
    return null;
  }
}
