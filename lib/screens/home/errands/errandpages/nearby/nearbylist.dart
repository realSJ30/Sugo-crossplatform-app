import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:sugoapp/models/posts.dart';
import 'package:sugoapp/screens/home/errands/errandpages/nearby/nearbytile.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';

class NearbyList extends StatefulWidget {
  final String uid;

  NearbyList({this.uid});
  @override
  _NearbyListState createState() => _NearbyListState();
}

class _NearbyListState extends State<NearbyList> {
  var errands;
  Location _myLocation = new Location();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    errands = Provider.of<List<Post>>(context) ?? [];
    print('length: ${errands.length}');
    return FutureBuilder(
        future: setLocation(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return loadingWidget();
          }
          print('lat: ${snap.data.latitude}');
          return RefreshIndicator(
            onRefresh: refreshList,
            child: ListView.builder(
              itemCount: errands.length,
              // ignore: missing_return
              itemBuilder: (context, index) {
                return NearbyTile(
                  post: errands[index],
                  uid: widget.uid,
                  mylocation: snap.data,
                );
              },
            ),
          );
        });
  }

  Future refreshList() async {
    await Future.delayed(Duration(seconds: 1));
    this.setState(() {
      errands = Provider.of<List<Post>>(context) ?? [];
    });
    return null;
  }

  Future setLocation() async {
    var mylocation = await _myLocation.getLocation();
    return mylocation;
  }
}
