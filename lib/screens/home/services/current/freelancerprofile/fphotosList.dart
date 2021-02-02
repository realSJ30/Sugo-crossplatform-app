import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugoapp/models/photos.dart';
import 'package:sugoapp/screens/home/services/current/freelancerprofile/fphotoTile.dart';
import 'package:sugoapp/shared/widgets.dart';

class FPhotosList extends StatefulWidget {
  final String uid;
  FPhotosList({this.uid});
  @override
  _FPhotosListState createState() => _FPhotosListState();
}

class _FPhotosListState extends State<FPhotosList> {
  var photos;
  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    photos = Provider.of<List<Photos>>(context) ?? [];
    print('photolength: ${photos.length}');
    return RefreshIndicator(
      onRefresh: refreshList,
      child: photos.length == 0
          ? emptyContainer()
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      (orientation == Orientation.portrait) ? 2 : 3),
              itemCount: photos.length,
              // ignore: missing_return
              itemBuilder: (context, index) {
                return FPhotoTile(
                  photos: photos[index],
                  uid: widget.uid,
                );
              },
            ),
    );
  }

  Future refreshList() async {
    await Future.delayed(Duration(seconds: 1));
    this.setState(() {
      photos = Provider.of<List<Photos>>(context) ?? [];
    });
    return null;
  }

  Widget emptyContainer() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image,
              color: Colors.grey,
              size: 50,
            ),
            buildLabelText(
                'No photos yet.', 14.0, Colors.grey, FontWeight.normal),
          ],
        ),
      ),
    );
  }
}
