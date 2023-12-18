import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
      body: _currentP == null
          ? const Center(child: Text('Loading...'))
          : GoogleMap(
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
