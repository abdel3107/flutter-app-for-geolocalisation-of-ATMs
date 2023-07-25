import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gab/pages/principal2.dart';
import 'package:gab/widgets/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';



class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds:4), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 40),
                Image.asset("assets/image3.png"),
                const SizedBox(height: 60),
                const Text("ATM KAP", style: TextStyle(fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFee7b64)),),
                const SizedBox(height: 50),
                const Text("The closest ATMs at the click of a button",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFee7b64), fontStyle: FontStyle.italic),),
                const SizedBox(height: 50,),


              ],
            ),
          ),
        ),
      ),
    );
  }
}



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          child :Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // const Text("ATM KAP", style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold, color: Colors.grey),),
                // const SizedBox(height: 10),
                // const Text("Closest ATMs with a click",
                //   style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),),
                const SizedBox(height: 100),
                Image.asset("assets/image11.png"),
                const SizedBox(height: 60),
                const Text.rich(
                  TextSpan(
                    text: "Let us help you find an ATM",
                    style: TextStyle(color: Color(0xFFee7b64), fontSize: 16, fontWeight: FontWeight.bold)
                  )
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFee7b64),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))
                    ),
                    child: const Text("FIND",
                      style: TextStyle(color: Colors.white, fontSize: 16),),
                    onPressed: (){
                      //nextScreen(context, const Principal());
                      nextScreen(context, AtmListWidget());
                    },
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

