import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grab/controller/map_controller.dart';
import 'package:grab/controller/socket_controller.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Location _locationController = new Location();
  LatLng? _currentP = null;
  PolylineId? _selectedPolylineId = null;
  SocketController sc = new SocketController();
  // Hard code for destination because of the API limit

  LatLng _destinationP = LatLng(10.762812503875347, 106.68248372541431);

  TextEditingController _searchController = TextEditingController();

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  Map<PolylineId, Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
    sc.initSocket();
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
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          controller: _searchController,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                              hintText: 'Enter pickup location'),
                        ),
                      ),
                    ),
                    IconButton(onPressed: () async {}, icon: Icon(Icons.search))
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          controller: _searchController,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                              hintText: 'Where you want to go ?'),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          MapController()
                              .getPolylinePoints(_currentP!, _destinationP)
                              .then((value) {
                            MapController()
                                .generatePolylineFromPoint(value)
                                .then((polyline) => {
                                      polyline.points.forEach((element) {
                                        setState(() {
                                          _currentP = element;
                                          _cameraToPosition(_currentP!);
                                          sc.sendPosition(element);
                                        });
                                      })
                                    });
                          });
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
                          position: _destinationP),
                    },
                    polylines: Set<Polyline>.of(_polylines.values),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_selectedPolylineId != null) {
                        _polylines[_selectedPolylineId]!.points.forEach((p) {
                          _currentP = p;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      alignment: Alignment.center,
                      child: Text(
                        'Start Route',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // Change the button color as needed
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
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

    _locationController.getLocation().then((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentP =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _cameraToPosition(_currentP!);
        });
      }
    });
  }
}
