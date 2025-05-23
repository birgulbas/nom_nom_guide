// yakın mesafe kafe mapi
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:nom_nom_guide/services/location_services.dart';
import 'package:nom_nom_guide/models/place.dart';
import 'package:nom_nom_guide/services/api_services.dart';
import 'package:nom_nom_guide/screens/places_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final LocationService locationService;
  LatLng? userLocation;
  List<Place> nearbyPlaces = [];
  double zoomLevel = 15.0;
  late MapController _mapController;  

  @override
  void initState() {
    super.initState();
    locationService = LocationService();
    _mapController = MapController();  
    loadMapData();
  }

  Future<void> loadMapData() async {
    try {
      final position = await locationService.getCurrentPosition();
      final userLatLng = LatLng(position.latitude, position.longitude);

      final api = ApiServices();
      final allPlaces = await api.getPlaces();

      final validPlaces = allPlaces
          .where((place) => place.latitude != null && place.longitude != null)
          .toList();

      final sortedPlaces = validPlaces..sort((a, b) {
        final aDist = Distance().as(
            LengthUnit.Meter, userLatLng, LatLng(a.latitude!, a.longitude!));
        final bDist = Distance().as(
            LengthUnit.Meter, userLatLng, LatLng(b.latitude!, b.longitude!));
        return aDist.compareTo(bDist);
      });

      setState(() {
        userLocation = userLatLng; // kullanıcı konumu
        nearbyPlaces = sortedPlaces;  // kafeleri al
      });
    } catch (e) {
      print("Hata: $e");
    }
  }

  void _onMarkerTapped(Place place) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaceScreen(place: place),
      ),
    );
  }

  void _zoomToUserLocation() {
    if (userLocation != null) {
      _mapController.move(userLocation!, zoomLevel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
  title: const Text('Near by Places and All'),
  backgroundColor: Colors.pink.shade600, 
),
      body: userLocation == null
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              mapController: _mapController,  
              options: MapOptions(
                center: userLocation,
                zoom: zoomLevel,
                onPositionChanged: (position, hasGesture) {
                  setState(() {
                    zoomLevel = position.zoom ?? zoomLevel;
                  });
                },
                minZoom: 10.0,  // Min zoom 
                maxZoom: 18.0,  // Max zoom 
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName: 'com.example.nom_nom_guide',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: userLocation!,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.person_pin_circle,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                    ...nearbyPlaces.map(
                      (place) => Marker(
                        point: LatLng(place.latitude!, place.longitude!),
                        width: 30,
                        height: 30,
                        child: GestureDetector(
                          onTap: () => _onMarkerTapped(place),
                          child: const Icon(
                            Icons.local_cafe,
                            color: Colors.brown,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // konuma yakınlaşma butonu
          FloatingActionButton(
            onPressed: _zoomToUserLocation,
            backgroundColor: Colors.blue,
            child: const Icon(Icons.my_location),
          ),
        ],
      ),
    );
  }
}
