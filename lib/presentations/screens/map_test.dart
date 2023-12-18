import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grab/data/service/location_service.dart';
import 'package:location/location.dart';

class MyMap extends StatefulWidget {
  const MyMap({super.key});

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  static const LatLng _destination =
      const LatLng(10.762844436118629, 106.6824853320835);
  Location _locationController = new Location();
  LatLng? _currentP = null;

  TextEditingController _searchController = TextEditingController();
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google map'),
      ),
      body: _currentP == null
          ? const Center(child: Text('Loading...'))
          : Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      controller: _searchController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(hintText: 'Search location'),
                      onChanged: (value) {
                        print(value);
                      },
                    )),
                    IconButton(
                        onPressed: () {
                          LocationService().getPlaceId(_searchController.text);
                        },
                        icon: Icon(Icons.search))
                  ],
                ),
                Expanded(
                  child: GoogleMap(
                    onMapCreated: ((GoogleMapController controller) {
                      _mapController.complete(controller);
                    }),
                    initialCameraPosition:
                        CameraPosition(target: _currentP!, zoom: 15),
                    markers: {
                      Marker(
                          markerId: MarkerId('_currentLocation'),
                          icon: BitmapDescriptor.defaultMarker,
                          position: _currentP!),
                      Marker(
                          markerId: MarkerId('_destinationLocation'),
                          icon: BitmapDescriptor.defaultMarker,
                          position: _destination),
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _cameraToPosition(LatLng position) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newPosition = CameraPosition(target: position, zoom: 15);
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(_newPosition));
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();

    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    _permissionGranted = await _locationController.hasPermission();

    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentP =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _cameraToPosition(_currentP!);
          print(_currentP);
        });
      }
    });
  }
}
