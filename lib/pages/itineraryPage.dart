
import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore_platform_interface/src/geo_point.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:gab/pages/principal2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

import '../widgets/widgets.dart';

const String google_api_key = "USE YOUR API KEY HERE";


class DirectionsRepository {
  static const _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';
  final _httpClient = http.Client();

  // Future<Directions?> getDirections(LatLng origin, LatLng destination) async {
  //   final Uri url = Uri.parse(_baseUrl +
  //       'origin=${origin.latitude},${origin.longitude}&' +
  //       'destination=${destination.latitude},${destination.longitude}&' +
  //       'AIzaSyA2Skn4Y8r7R3Yi7rpvJNarP-FnnX8CrAg');
  //
  //   try {
  //     final response = await _httpClient.get(url);
  //
  //     if (response.statusCode == 200) {
  //       final directions = Directions.fromMap(jsonDecode(response.body));
  //       return directions;
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     return null;
  //   }
  // }
}

// class Directions {
//   final bool isOkay;
//   final List<DirectionsStep> steps;
//
//   Directions(this.isOkay, this.steps);
//
//   factory Directions.fromMap(Map<String, dynamic> map) {
//     if (map['status'] != 'OK') {
//       return Directions(false, []);
//     }
//
//     final List<DirectionsStep> steps = [];
//     final List<dynamic> legs = map['routes'][0]['legs'];
//
//     legs.forEach((leg) {
//       final List<dynamic> legSteps = leg['steps'];
//       legSteps.forEach((legStep) {
//         steps.add(DirectionsStep.fromMap(legStep));
//       });
//     });
//
//     return Directions(true, steps);
//   }
// }

// class DirectionsStep {
//   final List<LatLng> points;
//
//   DirectionsStep(this.points);
//
//   factory DirectionsStep.fromMap(Map<String, dynamic> map) {
//     final List<LatLng> points = decodePolyline(map['polyline']['points']);
//     return DirectionsStep(points);
//   }
// }

// List<LatLng> decodePolyline(String encoded) {
//   List<LatLng> points = [];
//   int index = 0, len = encoded.length;
//   int lat = 0, lng = 0;
//
//   while (index < len) {
//     int b, shift = 0, result = 0;
//
//     do {
//       b = encoded.codeUnitAt(index++) - 63;
//       result |= (b & 0x1f) << shift;
//       shift += 5;
//     } while (b >= 0x20);
//
//     int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
//     lat += dlat;
//
//     shift = 0;
//     result = 0;
//
//     do {
//       b = encoded.codeUnitAt(index++) - 63;
//       result |= (b & 0x1f) << shift;
//       shift += 5;
//     } while (b >= 0x20);
//
//     int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
//     lng += dlng;
//
//     points.add(LatLng((lat / 1E5), (lng / 1E5)));
//   }
//
//   return points;
// }


class ItineraryPage extends StatefulWidget {
  final GeoPoint atm;
  final Position position;
  final String name;

  const ItineraryPage({Key? key, required this.name, required this.atm , required this.position}) : super(key: key);

  @override
  State<ItineraryPage> createState() => _ItineraryPageState();
}


class _ItineraryPageState extends State<ItineraryPage> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  // final Set<Polyline> _polylines = {};
  final Completer<GoogleMapController> _controller = Completer();

  LatLng get userLocation => LatLng(widget.position.latitude, widget.position.longitude);
  LatLng get atmLocation => LatLng(widget.atm.latitude, widget.atm.longitude);

  List<LatLng> polylineCoordinates = [];
  // LocationData? currentLocation;
  //
  // Future<void> getCurrentLocation1() async {
  //   Location location = Location();
  //   final permissionStatus = await ph.Permission.location.request();
  //   if (permissionStatus == ph.PermissionStatus.granted) {
  //     final locationData = await Location().getLocation();
  //     setState(() {
  //       currentLocation = locationData;
  //     });
  //   } else {
  //     throw Exception('Location permission denied');
  //   }
  //   // location.getLocation().then((location) {
  //   //   currentLocation = location;
  //   // },);
  // }



  // void _onMapCreated(GoogleMapController controller) {
  //   mapController = controller;
  //   // LatLng userLocation = LatLng(widget.position.latitude, widget.position.longitude);
  //   // LatLng atmLocation = LatLng(widget.atm.latitude, widget.atm.longitude);
  //
  //   _markers.add(
  //     Marker(
  //       markerId: MarkerId("User Location"),
  //       position: userLocation,
  //       icon: BitmapDescriptor.defaultMarker,
  //       infoWindow: InfoWindow(title: "User location"),
  //     ),
  //   );
  //
  //   _markers.add(
  //     Marker(
  //       markerId: MarkerId("ATM Location"),
  //       position: atmLocation,
  //       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
  //       infoWindow: InfoWindow(title: "Nearest ATM"),
  //     ),
  //   );
  //
  //   _addPolylines();
  // }
  //
  // void _addPolylines() async {
  //   // LatLng userLocation = LatLng(widget.position.latitude, widget.position.longitude);
  //   // LatLng atmLocation = LatLng(widget.atm.latitude, widget.atm.longitude);
  //   final directions =
  //   await DirectionsRepository().getDirections(userLocation, atmLocation);
  //
  //   if (directions != null && directions.isOkay) {
  //     setState(() {
  //       final List<LatLng> points = [];
  //       directions.steps.forEach((step) => points.addAll(step.points));
  //       final polyline = Polyline(
  //         polylineId: PolylineId("route"),
  //         color: Colors.blue,
  //         width: 3,
  //         points: points,
  //       );
  //       _polylines.add(polyline);
  //     });
  //   }
  // }


  void getPolypoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        google_api_key,
        PointLatLng(widget.position.latitude, widget.position.longitude),
        PointLatLng(widget.atm.latitude, widget.atm.longitude),
    );
    if (result.points.isNotEmpty){
      result.points.forEach((PointLatLng point) => polylineCoordinates.add(LatLng(point.latitude, point.longitude)),
      );
      setState(() {});
    }
  }

  @override
  void initState(){
    //getCurrentLocation1();
    getPolypoints();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xFFee7b64),
        actions: [
          IconButton(
              onPressed: (){},
              icon:const Icon(Icons.refresh_rounded)),
        ],
        title: Text(widget.name, style: const TextStyle(color: Colors.white,
            fontSize: 27, fontWeight: FontWeight.bold),),


      ),
      body: GoogleMap(
        // onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: userLocation,
          zoom: 15.5,
        ),
        polylines: {
          Polyline(
            polylineId: const PolylineId("route"),
            points: polylineCoordinates,
            color: Colors.blue,
            width: 6,
          ),

        },//markers: _markers,
        markers: {
          // Marker(
          //   markerId: MarkerId("currentLocation"),
          //   position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          // ),
          Marker(
            markerId: const MarkerId("source"),
            position: userLocation,
            icon: BitmapDescriptor.defaultMarker,
          ),
          Marker(
            markerId: const MarkerId("destination"),
            position: atmLocation,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          ),

        },
      ),
    );
  }
}
