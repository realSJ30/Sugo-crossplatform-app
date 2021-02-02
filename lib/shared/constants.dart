import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:math' as Math;

//border//
const textInputDecoration = InputDecoration(  
    fillColor: Colors.white,
    filled: true,    
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(30.0))),
    focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(30.0))),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(30.0))),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(30.0))));

double getMediaQueryWidthViaMinus(BuildContext context, double number) {
  return MediaQuery.of(context).size.width - number;
}
double getMediaQueryWidthViaDivision(BuildContext context, double number) {
  return MediaQuery.of(context).size.width / number;
}
double getMediaQueryHeightViaMinus(BuildContext context, double number) {
  return MediaQuery.of(context).size.height - number;
}
double getMediaQueryHeightViaDivision(BuildContext context, double number) {
  return MediaQuery.of(context).size.height / number;
}


//HAVERSINE FORMULA SHEET KAHAWOD JD NKO
double haversineFormula(LatLng coord1, LatLng coord2){

    //distance between lats and longs
    double dLat = (coord2.latitude - coord1.latitude) * Math.pi / 180;
    double dLon =  (coord2.longitude - coord1.longitude) * Math.pi / 180;

    //convert to radians coord1 lat and coord 2 lat
    double lat1 = (coord1.latitude) * Math.pi / 180;
    double lat2 = (coord2.latitude) * Math.pi / 180;

    //aplying the formula
    double a = Math.pow(Math.sin(dLat / 2), 2) + Math.pow(Math.sin(dLon / 2), 2) * Math.cos(lat1) * Math.cos(lat2);

    double radius = 6371; //radius of the earth
    double c = 2 * Math.asin(Math.sqrt(a));
    double result = radius * c;    
    return double.parse(result.toStringAsFixed(2));
  }

// COLORS
const primaryColor = Color(0xFF3773E1);
const secondaryColor = Color(0xFF2DBDDB);

//FONT FAMILY
const primaryFont = 'Century Gothic';
const secondaryFont = 'BebasNeue Regular';

//date time now
String dateTime(){
  DateTime now = DateTime.now();
  String formattedDate = DateFormat.yMMMEd('en_US').format(now);
  String formattedTime = DateFormat.jm().format(now);
  return '$formattedDate | $formattedTime';
}

// pagination list
List<String> requestServicePages = ['Choose errand','Errand information', 'Location', 'Final Step'];




//GEOLOCATION API KEY
String apiKey = "AIzaSyBS1xfAPNYILLuR5MoYiDZhGMAMEU1ESsQ";


