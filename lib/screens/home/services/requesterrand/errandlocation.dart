import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart' as place;
import 'package:location/location.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:sugoapp/screens/home/services/requesterrand/submitrequestErrand.dart';
import 'package:sugoapp/shared/constants.dart';
import 'package:sugoapp/shared/widgets.dart';
import 'package:tuxin_tutorial_overlay/TutorialOverlayUtil.dart';
import 'package:tuxin_tutorial_overlay/WidgetData.dart';

class ErrandLocation extends StatefulWidget {
  final String tags;
  final String notes;
  final String fee;
  final String paymenttype;
  final List<File> imgPath;
  final List<Asset> imgAsset;
  ErrandLocation(
      {this.tags,
      this.notes,
      this.fee,
      this.paymenttype,
      this.imgPath,
      this.imgAsset});
  @override
  _ErrandLocationState createState() => _ErrandLocationState();
}

class _ErrandLocationState extends State<ErrandLocation> {
  GoogleMapController mapController; // control to go to particular loc.
  Location _locationTracker = Location();

  Set<Marker> _marker = HashSet<Marker>();
  Set<Circle> _circles = HashSet<Circle>();
  LatLng initlatlng;
  place.GoogleMapsPlaces _places = place.GoogleMapsPlaces(apiKey: apiKey);
  var address1;
  var searchedAddress;
  final GlobalKey searchKey = GlobalKey();
  final GlobalKey locKey = GlobalKey();

  void showOverlay() {
    // setTutorialShowOverlayHook((String tagName) => print('showing'));
    createTutorialOverlay(
        tagName: 'search',
        context: context,
        bgColor: Colors.black.withOpacity(0.8),
        onTap: () {
          print('tap');
          hideOverlayEntryIfExists();
          showOverlayEntry(tagName: 'loc');
        },
        widgetsData: <WidgetData>[
          WidgetData(
              key: searchKey,
              isEnabled: false,
              padding: 4,
              shape: WidgetShape.Rect),
        ],
        description: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: Material(
              type: MaterialType.transparency,
              child: buildLabelText('You can search specific place here.', 18.0,
                  Colors.white, FontWeight.normal),
            ),
          ),
        ));
    createTutorialOverlay(
        tagName: 'loc',
        context: context,
        bgColor: Colors.black.withOpacity(0.8),
        onTap: () {
          print('tap');
          hideOverlayEntryIfExists();
        },
        widgetsData: <WidgetData>[
          WidgetData(
              key: locKey,
              isEnabled: false,
              padding: 4,
              shape: WidgetShape.Rect),
        ],
        description: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Material(
              type: MaterialType.transparency,
              child: buildLabelText(
                  'This is where you set the location by tapping.',
                  18.0,
                  Colors.white,
                  FontWeight.normal),
            ),
          ),
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        'Request Errand',
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                showOverlayEntry(tagName: 'search');
              },
              child: Container(
                  child: Row(
                children: <Widget>[
                  buildLabelText('Help', 12.0, Colors.white, FontWeight.normal),
                  Icon(
                    Icons.help_outline,
                    size: 20.0,
                    color: Colors.white,
                  ),
                ],
              )),
            ),
          ),
        ],
      ),
      body: Container(
        color: primaryColor,
        child: Center(
          child: Column(
            children: <Widget>[Expanded(child: mainContainer())],
          ),
        ),
      ),
    );
  }

  Widget mainContainer() {
    return Container(
      color: Colors.white,
      width: getMediaQueryWidthViaMinus(context, 0),
      child: locationContainer(),
    );
  }

  Widget locationContainer() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        child: Container(
            child: Stack(
          children: <Widget>[
            googleMap(_handleTap),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Align(
                      alignment: Alignment.bottomCenter, child: setLocation())),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: searchPlaceTextField(),
            )
          ],
        )),
      ),
    );
  }

  Widget googleMap(event) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return loadingWidget();
        }

        return GoogleMap(
          key: locKey,
          initialCameraPosition:
              CameraPosition(target: snapshot.data, zoom: 18),
          onMapCreated: onMapCreated,
          markers: _marker,
          circles: _circles,
          mapType: MapType.normal,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          onTap: event,
          // myLocationEnabled: true,
        );
      },
      future: getInitCameraPos(),
    );
  }

  _handleTap(LatLng tappedPoint) {
    try {
      if (this.mounted) {
        setState(() {
          _marker.clear();
          _marker.add(Marker(
              markerId: MarkerId(tappedPoint.toString()),
              position: tappedPoint,
              infoWindow: InfoWindow(title: 'You are here'),
              draggable: false));
          mapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: _marker.first.position, zoom: 18)));
          _circles.clear();
          _circles.add(Circle(
            circleId: CircleId(tappedPoint.toString()),
            center: LatLng(tappedPoint.latitude, tappedPoint.longitude),
            radius: 5,
            strokeWidth: 1,
            strokeColor: Colors.redAccent,
            fillColor: Colors.red[100],
          ));
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<LatLng> getInitCameraPos() async {
    try {
      var location = await _locationTracker.getLocation();

      if (this.mounted) {
        setState(() {
          initlatlng = LatLng(location.latitude, location.longitude);
        });
      }

      return LatLng(location.latitude, location.longitude);
    } catch (e) {
      print(e.toString());
      showWarningSnack(context, 'Error Connection: Check Internet!');
      return null;
    }
  }

  void onMapCreated(controller) {
    mapController = controller;

    try {
      if (this.mounted) {
        setState(() {
          // getCurrentLocation();
          _marker.add(Marker(
              markerId: MarkerId('You'),
              position: LatLng(initlatlng.latitude, initlatlng.longitude),
              draggable: false,
              infoWindow: InfoWindow(title: 'You are here')));
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
    } catch (e) {
      print(e.toString());
    }
  }

  Widget searchPlaceTextField() {
    return Container(
      key: searchKey,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        boxShadow: [
          BoxShadow(color: Colors.blueGrey, spreadRadius: 1.0, blurRadius: 5)
        ],
      ),
      child: TextFormField(
        onTap: () async {
          try {
            place.Prediction p = await PlacesAutocomplete.show(
              context: context,
              apiKey: apiKey,
              radius: 100000,
              location:
                  place.Location(initlatlng.latitude, initlatlng.longitude),
              components: [place.Component(place.Component.country, 'ph')],
              language: 'en',
            );

            if (p != null) {
              place.PlacesDetailsResponse detail =
                  await _places.getDetailsByPlaceId(p.placeId);
              final lat = detail.result.geometry.location.lat;
              final long = detail.result.geometry.location.lng;
              setState(() {
                _marker.clear();
                _marker.add(Marker(
                    markerId: MarkerId(detail.toString()),
                    position: LatLng(lat, long),
                    infoWindow: InfoWindow(title: 'You are here'),
                    draggable: false));
                mapController.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(target: _marker.first.position, zoom: 18)));
                _circles.clear();
                _circles.add(Circle(
                  circleId: CircleId(detail.toString()),
                  center: LatLng(lat, long),
                  radius: 5,
                  strokeWidth: 1,
                  strokeColor: Colors.redAccent,
                  fillColor: Colors.red[100],
                ));
                searchedAddress = p.description;
              });
            }
          } catch (e) {
            print(e.toString());
          }
        },
        decoration: textInputDecoration.copyWith(
            hintText: 'Search',
            prefixIcon: Icon(
              Icons.location_on,
              size: 25,
            )),
      ),
    );
  }

  Widget setLocation() {
    return ButtonTheme(
      height: 50.0,
      child: RaisedButton(
          onPressed: () async {
            print('asset -> ${widget.imgAsset.length}');
            try {
              final coordinates = new Coordinates(
                  _marker.first.position.latitude,
                  _marker.first.position.longitude);
              // ignore: unnecessary_statements
              var tempaddress = await Geocoder.local
                  .findAddressesFromCoordinates(coordinates);
              var first = tempaddress.first;
              if (searchedAddress == null) {
                address1 = '${first.addressLine}';
                if (address1.toString().contains('Unnamed Road')) {
                  address1 = '${first.addressLine.substring(14)}';
                }
              } else {
                address1 = searchedAddress;
              }

              print(address1);
              // print(address1);

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SubmitReqErrand(
                        tags: widget.tags,
                        fee: widget.fee,
                        notes: widget.notes,
                        paymenttype: widget.paymenttype,
                        address1: address1.toString(),
                        latlng: _marker.first.position.toString(),
                        imgPath: widget.imgPath,
                        imgAsset: widget.imgAsset,
                      )));
            } catch (e) {
              print(e.toString());
            }
          },
          color: primaryColor,
          splashColor: secondaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: buildLabelText(
              'Set Location', 16.0, Colors.white, FontWeight.normal)),
    );
  }
}
