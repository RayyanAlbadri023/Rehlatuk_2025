import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

class MapPage extends StatefulWidget {
  final List<Map<String, dynamic>>? items; // selected places
  final String? placeName;

  const MapPage({super.key, this.items, this.placeName});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  bool _loading = true;

  // Sample hardcoded coordinates
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
    if (!kIsWeb) {
      _determinePosition();
    } else {
      _loading = false;
    }
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final containerColor = isDark ? const Color(0xFF160948) : Colors.white;
    final buttonTextColor = isDark ? Colors.white : const Color(0xFF160948);

    final places = widget.items ?? [];

    // Mobile markers
    final Set<Marker> markers = {};
    for (var place in places) {
      final name = place['name'] ?? 'Unknown Place';
      final position = placeLocations[name];
      if (position != null) {
        markers.add(Marker(markerId: MarkerId(name), position: position, infoWindow: InfoWindow(title: name)));
      }
    }

    if (_currentPosition != null) {
      markers.add(Marker(
        markerId: const MarkerId("current_location"),
        position: _currentPosition!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: "You are here"),
      ));
    }

    final LatLng initialCamera =
    markers.isNotEmpty ? markers.first.position : const LatLng(23.5880, 58.3829);

    return Scaffold(
      backgroundColor: containerColor,
      appBar: AppBar(
        backgroundColor: containerColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: buttonTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.placeName ?? "Map View", style: TextStyle(color: buttonTextColor)),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            // Selected places list
            if (places.isNotEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: buttonTextColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Selected Places:",
                        style: TextStyle(color: containerColor, fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    ...places.map((place) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Text(
                        place['name'] ?? 'Unknown Place',
                        style: TextStyle(color: containerColor, fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    )),
                  ],
                ),
              ),
            const SizedBox(height: 10),

            // Map or Web link
            if (kIsWeb)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonTextColor,
                    foregroundColor: containerColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () {
                    // Open Google Maps in browser
                    if (places.isNotEmpty) {
                      final place = places.first;
                      final latLng = placeLocations[place['name']] ?? const LatLng(23.5880, 58.3829);
                      final url = Uri.encodeFull(
                          "https://www.google.com/maps/search/?api=1&query=${latLng.latitude},${latLng.longitude}");
                      launchUrl(Uri.parse(url));
                    }
                  },
                  icon: const Icon(Icons.location_on_outlined),
                  label: const Text("Open Map"),
                ),
              )
            else
              Container(
                height: 400,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                clipBehavior: Clip.antiAlias,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(target: initialCamera, zoom: 14),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: true,
                  onMapCreated: (controller) => _mapController = controller,
                  markers: markers,
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
