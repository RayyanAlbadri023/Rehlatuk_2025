
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
  final String? placeName;

  const MapPage({super.key, this.placeName});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  bool _loading = true;

  // Sample hardcoded coordinates for some famous places (you can expand later)
  final Map<String, LatLng> placeLocations = {
    "Muttrah Fort": const LatLng(23.6195, 58.5683),
    "Muttrah Souq": const LatLng(23.6162, 58.5638),
    "Corniche Walk": const LatLng(23.6170, 58.5630),
    "Qurum Beach": const LatLng(23.6133, 58.4676),
    "Royal Opera House": const LatLng(23.6116, 58.4543),
    "Wadi Darbat": const LatLng(17.1423, 54.4922),
    "Mughsail Beach": const LatLng(16.8907, 53.7455),
  };

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition();

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final LatLng? placeLocation =
        placeLocations[widget.placeName ?? ""] ?? const LatLng(23.5880, 58.3829);

    return Scaffold(
      backgroundColor: const Color(0xFF160948),
      appBar: AppBar(
        backgroundColor: const Color(0xFF160948),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.placeName ?? "Map View",
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: _loading
          ? const Center(
        child: CircularProgressIndicator(color: Colors.white),
      )
          : Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.antiAlias,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: placeLocation ?? _currentPosition!,
            zoom: 14,
          ),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: true,
          onMapCreated: (controller) => _mapController = controller,
          markers: {
            if (placeLocation != null)
              Marker(
                markerId: const MarkerId("place_marker"),
                position: placeLocation,
                infoWindow: InfoWindow(
                  title: widget.placeName,
                  snippet: "Tap for directions",
                ),
              ),
            if (_currentPosition != null)
              Marker(
                markerId: const MarkerId("current_location"),
                position: _currentPosition!,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue),
                infoWindow: const InfoWindow(title: "You are here"),
              ),
          },
        ),
      ),
    );
  }
}