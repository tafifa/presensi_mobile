import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:presensi_mobile/utils/haversine.dart';

class PresensiMap extends StatefulWidget {
  final LatLng definedLocation;
  final LatLng currentLocation;
  final Function(bool) onStatusChange;
  final Function(LatLng) onUpdateCurrentLocation;
  const PresensiMap({
    super.key,
    required this.definedLocation,
    required this.currentLocation,
    required this.onStatusChange,
    required this.onUpdateCurrentLocation
  });

  @override
  State<PresensiMap> createState() => _PresensiMapState();
}

class _PresensiMapState extends State<PresensiMap> {
  late GoogleMapController mapController;
  bool _isLocationLoaded = false;
  Set<Circle> _circles = {};
  String _distanceText = '';
  String _presenceText = '';
  Color _presenceColor = Colors.green;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _getCurrentLocation();
  }

  void _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Prompt the user to enable location services
      bool enableService = await Geolocator.openLocationSettings();
      if (!enableService) {
        // Handle if the user doesn't enable location services
        return Future.error('Location services are disabled.');
      }
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request location permissions
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Handle if location permissions are denied
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Handle if location permissions are permanently denied
      return Future.error('Location permissions are permanently denied');
    }
  }


  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    widget.onUpdateCurrentLocation(LatLng(position.latitude, position.longitude));
    setState(() {
      // _currentLocation = ;
      _isLocationLoaded = true;
      _updateDistanceAndPresence();
      _circles = {
        Circle(
          circleId: const CircleId('currentLocation'),
          center: widget.definedLocation,
          radius: 20, // Radius in meters
          fillColor: Colors.blue.withOpacity(0.2),
          strokeColor: Colors.blue,
          strokeWidth: 1,
        ),
      };
    });
  }

  void _updateDistanceAndPresence() {
    double distance = HaversineFormula.distance(
      widget.currentLocation.latitude,
      widget.currentLocation.longitude,
      widget.definedLocation.latitude,
      widget.definedLocation.longitude,
    );
    bool isInRange = distance <= 20;
    setState(() {
      _distanceText = 'Jarak Anda dengan lokasi: ${distance.toStringAsFixed(1)} meter';
      if (isInRange) {
        _presenceText = 'Anda dapat melakukan presensi';
        _presenceColor = Colors.green;
      } else {
        _presenceText = 'Anda diluar jangkauan';
        _presenceColor = Colors.red;
      }
    });
    widget.onStatusChange(isInRange);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_isLocationLoaded) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: widget.currentLocation,
            zoom: 19.0, // Adjust the zoom level as needed
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: Colors.blue[900],
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Align text to the left
            children: [
              Text(
                _distanceText, // Display distance dynamically
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  _getCurrentLocation(); // Refresh location data on button press
                },
                style: ElevatedButton.styleFrom(
                  elevation: 4,
                  backgroundColor: Colors.white,
                ),
                child: FaIcon(
                  FontAwesomeIcons.arrowsRotate,
                  color: Colors.blue[900],
                  size: 18,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width, // Set the width to the screen width
          height: 300, // Set a custom height for the map
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: widget.currentLocation,
              zoom: 19.0, // Adjust the zoom level as needed
            ),
            myLocationEnabled: true, // Show user location
            circles: _circles,
          ),
        ),
        Container(
          color: _presenceColor,
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _presenceText, // Display presence status dynamically
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
