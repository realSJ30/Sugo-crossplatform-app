import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:sugoapp/services/profiledatabase.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';

class FreelancerRating extends StatefulWidget {
  final String uid;
  final String postid;
  FreelancerRating({this.uid, this.postid});

  @override
  _FreelancerRatingState createState() => _FreelancerRatingState();
}

class _FreelancerRatingState extends State<FreelancerRating> {
  var rating = 0.0;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: buildLabelText(
          'Rate Freelancer', 14.0, Colors.blue, FontWeight.normal),
      content: Container(
        height: getMediaQueryHeightViaDivision(context, 6),
        child: Align(
          alignment: Alignment.center,
          child: SmoothStarRating(
            allowHalfRating: true,
            onRated: (v) {
              this.setState(() {
                this.rating = v;
              });
              print('rating value:$v');
            },
            color: this.rating < 2 ? Colors.red : Colors.blue,
            borderColor: this.rating < 2 ? Colors.red : Colors.blue,
            size: 35.0,
            starCount: 5,
            rating: rating,
            filledIconData: Icons.star,
            halfFilledIconData: Icons.star_half,
            defaultIconData: Icons.star_border,
            spacing: 1.5,
          ),
        ),
      ),
      actions: [
        FlatButton(
            onPressed: this.rating > 0
                ? () async {
                    print('rating:> ${this.rating}');
                    print('uid:> ${widget.uid}');
                    print('postid:> ${widget.postid}');
                    await ProfileDatabase(uid: widget.uid)
                        .setRating(postid: widget.postid, rating: this.rating);
                    Navigator.pop(context);
                  }
                : null,
            child: buildLabelText('Rate', 14.0, Colors.blue, FontWeight.bold))
      ],
    );
  }
}
