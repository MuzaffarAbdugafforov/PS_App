// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class ClubInfo {
  final String name;
  final LatLng coordinates;
  final String workingHours;
  final String imageUrl;
  final String phoneNumber;

  ClubInfo({
    required this.name,
    required this.coordinates,
    required this.workingHours,
    required this.imageUrl,
    required this.phoneNumber,
  });
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  late GoogleMapController mapController;
  Set<Marker> markers = {};
  List<ClubInfo> clubs = [
    ClubInfo(
      name: 'Monkey Gaming Club & Loft Cinema',
      coordinates: LatLng(41.274264, 69.285121),
      workingHours: '10 AM - 10 PM',
      imageUrl: 'lib/images_png/PS_image_1.jpg',
      phoneNumber: '+998990111101',
    ),
    ClubInfo(
      name: 'PLAYSTATION PS',
      coordinates: LatLng(41.276333, 69.338078),
      workingHours: '12 PM - 3 AM',
      imageUrl: 'lib/images_png/PS_image_1.jpg',
      phoneNumber: '+998951993303',
    ),
    ClubInfo(
      name: 'PlayStation RELAX-TIME',
      coordinates: LatLng(41.272526, 69.245208),
      workingHours: '12 PM - 3 AM',
      imageUrl: 'lib/images_png/PS_image_1.jpg',
      phoneNumber: '+998998789393',
    ),


  ];

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    requestPermission();
    addPlayStationLocations();
    setState(() {});
  }

  Future<void> requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 16,
          ),
        ),
      );
    } else {
      // Handle the case when permission is denied.
      print("Location permission is denied");
    }
  }

  void addPlayStationLocations() {
    for (var club in clubs) {
      markers.add(
        Marker(
          markerId: MarkerId(club.name),
          position: club.coordinates,
          onTap: () => showDetailsBottomSheet(context, club),
        ),
      );
    }
    setState(() {});
  }

  void showDetailsBottomSheet(BuildContext context, ClubInfo club) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SizedBox(
          height: 400, // Fixed height
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Image container with fixed height and proper scaling
                  Container(
                    height: 150, // Fixed height for image container
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(club.imageUrl),
                        fit: BoxFit.cover, // Ensures the image covers the container without distorting aspect ratio
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    club.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Working Hours: ${club.workingHours}",
                    style: TextStyle(fontSize: 18),
                  ),
                  GestureDetector(
                    onTap: () => _launchPhoneApp(club.phoneNumber),
                    child: Text(
                      "Phone: ${club.phoneNumber}",
                      style: TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[400],  // 'backgroundColor' instead of 'primary'
                      foregroundColor: Colors.black,  // 'foregroundColor' instead of 'onPrimary'
                    ),
                    child: Text("Close"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      isScrollControlled: true, // Allows the Bottom Sheet to expand to the size of the content up to full screen
    );
  }

  Future<void> _launchPhoneApp(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[400],
        title: Text("Google Maps"),
        actions: [
          IconButton(onPressed: signUserOut, icon: Icon(Icons.logout))
        ],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(0.0, 0.0),
          zoom: 10.0,
        ),
        markers: markers,
        myLocationEnabled: true, // Enable the 'My Location' button on the map
        zoomControlsEnabled: true, // Disable the default zoom controls
      ),
    );
  }
}

