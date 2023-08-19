import 'dart:ui';

import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' show asin, cos, pi, pow, sin, sqrt;

import '../widgets/widgets.dart';
import 'itineraryPage.dart';

class Atm {
  final String bank;
  final bool isFunctioning;
  final GeoPoint position;
  late double distance;

  Atm(this.bank, this.isFunctioning, this.position);
}
class AtmListWidget extends StatefulWidget {
  const AtmListWidget({super.key});

  @override
  _AtmListWidgetState createState() => _AtmListWidgetState();
}

class _AtmListWidgetState extends State<AtmListWidget> {
  List<Atm> _atms = [];
  Position? userLocation;

  Future<List<Atm>> getNearbyAtms() async {
    Position userLocation1 = await _getCurrentLocation();
    setState(() {
      userLocation = userLocation1;
    });
    var querySnapshot = await FirebaseFirestore.instance
        .collection('atm')
        .where('isFunctioning', isEqualTo: true)
        .get();

    List<Atm> atms = [];
    for (var doc in querySnapshot.docs) {
      var atm = Atm(
        doc['bank'],
        doc['isFunctioning'],
        doc['position']['geopoint'],
      );

      var latitude = userLocation?.latitude ?? 0.0;
      var longitude = userLocation?.longitude ?? 0.0;
      var distance = await _calculateDistance(
        latitude,
        longitude,
        atm.position.latitude,
        atm.position.longitude,
      );
      atm.distance = distance;

      atms.add(atm);
    }

    atms.sort((a, b) => a.distance.compareTo(b.distance));

    return atms;
  }

  Future<Position> _getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permissions are denied");
      }
    }
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }


  Future<double> _calculateDistance(double startLat, double startLng, double endLat, double endLng) async {
    //Google Maps API key
    String apiKey = "USE YOUR API KEY HERE";

    //Google Maps Directions API request URL
    String url = "https://maps.googleapis.com/maps/api/directions/json?origin=$startLat,$startLng&destination=$endLat,$endLng&key=$apiKey";

    //HTTP request to the Google Maps API
    final response = await http.get(Uri.parse(url));

    // Parsing the response JSON to get the route distance value
    final directionsJson = jsonDecode(response.body);
    final distance = directionsJson["routes"][0]["legs"][0]["distance"]["value"];

    // Return the distance in Km
    return distance.toDouble()/1000;
  }

  @override
  void initState() {

    super.initState();

    // Starting with an empty list of ATMs
    _fetchNearbyAtms();
  }

  void _fetchNearbyAtms() async {
    //var atms = await AtmService().getNearbyAtms();
    var atms = await getNearbyAtms();
    setState(() {
      _atms = atms;
    });
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
        title: const Text("ATMs", style: TextStyle(color: Colors.white,
            fontSize: 27, fontWeight: FontWeight.bold),),


      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: const <Widget>[

          ],
        ),
      ),
      body: DefaultTabController(
        length: 5,
        child: Column(
          children: [
            Material(
              child: Container(
                height: 80,
                color: Colors.white,
                child: TabBar(
                    isScrollable: true,
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                  unselectedLabelColor: const Color(0xFFee7b64),
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color(0xFFee7b64)
                  ),
                  tabs: [
                    Tab(
                      child: Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: const Color(0xFFee7b64), width: 1),
                        ),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text("All"),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: const Color(0xFFee7b64), width: 1),
                        ),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text("UBA"),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: const Color(0xFFee7b64), width: 1),
                        ),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text("BICEC"),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: const Color(0xFFee7b64), width: 1),
                        ),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text("BEAC"),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: const Color(0xFFee7b64), width: 1),
                        ),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text("Afriland"),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('atms').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if ((snapshot.connectionState == ConnectionState.waiting) || userLocation==null) {
                    return const Center(
                      child: CircularProgressIndicator(color: Color(0xFFee7b64),),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  if (snapshot.data == null) {
                    return const Center(
                      child: Text('No data found'),
                    );
                  }

                  // Re-fetching the list of nearby ATMs when new data is available
                  if (_atms.isEmpty) {
                    _fetchNearbyAtms();
                  }


                  return ListView.builder(
                    itemCount: _atms.length,
                    itemBuilder: (BuildContext context, int index) {

                      return ListTile(
                        onTap: (){
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ItineraryPage(name :_atms[index].bank , atm: _atms[index].position, position : userLocation ?? Position(latitude: 0, longitude: 0, timestamp: null, accuracy: double.nan, altitude:double.nan, heading: double.nan, speed: double.nan, speedAccuracy:double.nan),
                          ),
                        ),);
                          },
                        // selectedColor: Color(0xFFee7b64),
                        // selected: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                        leading: const Text("Test"),
                        title: Text(
                          _atms[index].bank,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${_atms[index].distance.toStringAsFixed(1)} km',
                          style: const TextStyle(fontSize: 16),
                        ),
                        trailing: Icon(
                          _atms[index].isFunctioning
                              ? Icons.check_circle
                              : Icons.error,
                          color: _atms[index].isFunctioning ? Colors.green : Colors.red,
                        ),
                      );
                    },
                  );
                },
                  ),
                  const Center(),
                  const Center(),
                  const Center(),
                  const Center(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

