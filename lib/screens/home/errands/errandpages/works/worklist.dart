import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:sugoapp/models/posts.dart';
import 'package:sugoapp/screens/home/errands/errandpages/works/worktile.dart';
import 'package:sugoapp/shared/widgets.dart';

class WorkList extends StatefulWidget {
  final String uid;

  WorkList({this.uid});
  @override
  _WorkListState createState() => _WorkListState();
}

class _WorkListState extends State<WorkList> {
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
          print('errnd length: ${errands.length}');
          return RefreshIndicator(
            onRefresh: refreshList,
            child: ListView.builder(
              itemCount: errands.length,
              // ignore: missing_return
              itemBuilder: (context, index) {
                return WorkTile(
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
