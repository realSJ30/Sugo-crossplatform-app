import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sugoapp/models/posts.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';

class ErrandLocation extends StatefulWidget {
  final Post post;
  ErrandLocation({this.post});
  @override
  _ErrandLocationState createState() => _ErrandLocationState();
}

class _ErrandLocationState extends State<ErrandLocation> {
  GoogleMapController mapController; // control to go to particular loc.
  Set<Marker> _marker = HashSet<Marker>();
  Set<Circle> _circles = HashSet<Circle>();

  LatLng initlatlng;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List<String> latlngs = widget.post.position
        .substring(7, widget.post.position.length - 1)
        .split(',');
    initlatlng = LatLng(double.parse(latlngs[0]), double.parse(latlngs[1]));
    print('location: $initlatlng');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar('Location'),
        body: Container(
          color: primaryColor,
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)),
              child: Container(
                color: Colors.white,
                width: getMediaQueryWidthViaMinus(context, 0),
                child: locationContainer(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget locationContainer() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        child: Container(
          child: googleMap(),
        ),
      ),
    );
  }

  Widget googleMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(target: initlatlng, zoom: 18),
      onMapCreated: onMapCreated,
      markers: _marker,
      circles: _circles,
      mapType: MapType.normal,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      myLocationEnabled: true,
    );
  }

  void onMapCreated(controller) {
    mapController = controller;

    setState(() {
      //the location of the errand must be set here....
      _marker.add(Marker(
          markerId: MarkerId('Client'),
          position: LatLng(initlatlng.latitude, initlatlng.longitude),
          draggable: false,
          infoWindow: InfoWindow(title: 'Errand Location')));
      _circles.add(Circle(
        circleId: CircleId(initlatlng.toString()),
        center: LatLng(initlatlng.latitude, initlatlng.longitude),
        radius: 5,
        strokeWidth: 1,
        strokeColor: Colors.redAccent,
        fillColor: Colors.red[100],
      ));
    });
  }
}
