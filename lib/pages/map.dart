import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoogleMapsScreen extends StatefulWidget {
  const GoogleMapsScreen({super.key});

  @override
  State<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  LatLng? _currentPosition;
  final Set<Marker> _markers = {};
  GoogleMapController? _mapController;

  String _selectedDisease = "All";
  List<String> _diseaseList = ["All"];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _getCurrentLocation();
    await _loadMarkers();
  }

  
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    LatLng pos = LatLng(position.latitude, position.longitude);

    setState(() {
      _currentPosition = pos;
      
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(pos, 16),
      );
    });
  }

  
  Future<void> _loadMarkers() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('scans').get();

    final Set<Marker> newMarkers = {};
    final Set<String> diseases = {"All"};

    for (var doc in snapshot.docs) {
      final data = doc.data();

      final String disease = data['disease'] ?? 'Unknown';
      final double lat = (data['latitude'] as num).toDouble();
      final double lng = (data['longitude'] as num).toDouble();
      final double confidence =
          (data['confidence'] as num?)?.toDouble() ?? 0;

      diseases.add(disease);

      
      if (_selectedDisease != "All" &&
          disease.toLowerCase() != _selectedDisease.toLowerCase()) {
        continue;
      }

      
      BitmapDescriptor color;
      if (disease.toLowerCase().contains("healthy")) {
        color = BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen);
      } else if (confidence < 0.5) {
        color = BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueYellow);
      } else {
        color = BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed);
      }

      newMarkers.add(
        Marker(
          markerId: MarkerId(doc.id),
          position: LatLng(lat, lng),
          icon: color,
          infoWindow: InfoWindow(
            title: disease,
            snippet:
                "Confidence: ${(confidence * 100).toStringAsFixed(1)}%",
          ),
        ),
      );
    }

    setState(() {
      _markers.clear(); 
      _markers.addAll(newMarkers);
      _diseaseList = diseases.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // 🗺️ MAP
                Positioned.fill(
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition!,
                      zoom: 16,
                    ),
                    markers: _markers,

                    
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,

                    zoomControlsEnabled: true,
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                  ),
                ),

               
                Positioned(
                  top: MediaQuery.of(context).padding.top + 15,
                  left: 15,
                  right: 15,
                  child: Material(
                    elevation: 20,
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedDisease,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          items: _diseaseList.map((disease) {
                            return DropdownMenuItem(
                              value: disease,
                              child: Text(disease),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedDisease = value!;
                            });
                            _loadMarkers();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}