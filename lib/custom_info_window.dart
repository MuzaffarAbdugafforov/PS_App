import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Location {
  final LatLng latLng;
  final String title;
  final String text;
  final String photoUrl;

  Location({
    required this.latLng,
    required this.title,
    required this.text,
    required this.photoUrl,
  });
}

class CustomInfoWindowMarker extends StatefulWidget {
  const CustomInfoWindowMarker({Key? key}) : super(key: key);

  @override
  State<CustomInfoWindowMarker> createState() =>
      _CustomInfoWindowMarkerState();
}

class _CustomInfoWindowMarkerState extends State<CustomInfoWindowMarker> {
  final CustomInfoWindowController _customInfoWindow =
  CustomInfoWindowController();
  final List<Marker> myMarker = [];
  final List<Location> locations = [
    Location(
      latLng: const LatLng(41.2963660743825, 69.35085438816506),
      title: 'Chotkiy opa',
      text: 'soati 300 kal',
      photoUrl:
      'https://i.pinimg.com/736x/23/60/c0/2360c073539b13761358392ddd89b71d.jpg',
    ),
    Location(
      latLng: const LatLng(41.29604273472128, 69.3503474207432),
      title: 'Another location',
      text: 'Another location description',
      photoUrl: 'https://example.com/another-photo.jpg',
    ),
    // Add more locations as needed
  ];

  late CameraPosition initialPosition;

  @override
  void initState() {
    super.initState();
    _getLocationAndLoadData();
  }

  void _getLocationAndLoadData() async {
    // Fetch the current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Set the initial camera position to the current location
    LatLng currentLocation = LatLng(position.latitude, position.longitude);
    initialPosition = CameraPosition(
      target: currentLocation,
      zoom: 14,
    );

    // Load data and update markers
    _loadData(initialPosition);
  }

  void _loadData(CameraPosition initialPosition) {
    for (int i = 0; i < locations.length; i++) {
      final location = locations[i];
      myMarker.add(
        Marker(
          markerId: MarkerId(i.toString()),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueViolet),
          position: location.latLng,
          onTap: () {
            _customInfoWindow.addInfoWindow!(
              Container(
                width: 250, // Adjust the width as needed
                height: 250, // Adjust the height as needed
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 250,
                      height: 120,
                      child: Image.network(
                        location.photoUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Text(
                              'Image Loading Failed',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        location.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        location.text,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              location.latLng,
            );
          },
        ),
      );
    }
    setState(() {}); // Update the UI after adding markers
  }

  @override
  Widget build(BuildContext context) {
    // Check if initialPosition is null, return a loading indicator or empty container
    if (initialPosition == null) {
      return CircularProgressIndicator(); // Or any other loading widget
    }

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialPosition, // Set initial camera position here
            markers: Set<Marker>.of(myMarker),
            onTap: (position) {
              _customInfoWindow.hideInfoWindow!();
            },
            onCameraMove: (position) {
              _customInfoWindow.onCameraMove!();
            },
            onMapCreated: (GoogleMapController controller) {
              _customInfoWindow.googleMapController = controller;
            },
          ),
          CustomInfoWindow(
            controller: _customInfoWindow,
            height: 250, // Adjust the height as needed
            width: 250, // Adjust the width as needed
            offset: 50,
          )
        ],
      ),
    );
  }
}
