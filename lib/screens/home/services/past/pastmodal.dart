import 'package:flutter/material.dart';
import 'package:sugoapp/models/posts.dart';
import 'package:sugoapp/shared/widgets.dart';

class PastModalDetail extends StatelessWidget {
  final Post post;
  PastModalDetail({this.post});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: buildSubLabelText(
              'DETAILS', 18.0, Colors.black54, FontWeight.bold),
        ),
        Expanded(
          child: Container(
              child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildLabelText(
                            post.tags, 18.0, Colors.black, FontWeight.bold),
                        separator(5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            buildSubLabelText('Service Fee', 12.0, Colors.blue,
                                FontWeight.normal),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: buildLabelText(post.fee + ' PHP', 14.0,
                                  Colors.black, FontWeight.normal),
                            ),
                          ],
                        ),
                        separator(5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            buildSubLabelText('Payment method', 12.0,
                                Colors.blue, FontWeight.normal),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: buildLabelText(post.paymentType, 14.0,
                                  Colors.black, FontWeight.normal),
                            ),
                          ],
                        ),
                        separator(5),
                        Row(
                          children: [
                            buildSubLabelText('ADDRESS', 12.0, Colors.blue,
                                FontWeight.normal),
                            Icon(
                              Icons.location_on,
                              size: 20,
                              color: Colors.blue,
                            )
                          ],
                        ),
                        buildSubLabelText(
                            '1', 12.0, Colors.grey, FontWeight.normal),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: buildLabelText(post.address1, 14.0,
                              Colors.black, FontWeight.normal),
                        ),
                        buildSubLabelText(
                            '2', 12.0, Colors.grey, FontWeight.normal),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: buildLabelText(
                              post.address2.isEmpty ? '(N/A)' : post.address2,
                              14.0,
                              post.address2.isEmpty
                                  ? Colors.black54
                                  : Colors.black,
                              FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
                separator(10),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            buildSubLabelText('Information/Notes', 12.0,
                                Colors.black, FontWeight.normal),
                            Icon(
                              Icons.notes,
                              size: 20,
                              color: Colors.black,
                            ),
                            Expanded(
                                child: Divider(
                              thickness: 0.5,
                              color: Colors.grey,
                            ))
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: buildLabelText(post.notes, 14.0, Colors.black,
                              FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
        ),
      ],
    );
  }
}
