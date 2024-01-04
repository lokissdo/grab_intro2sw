import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grab/controller/map_controller.dart';
import 'package:grab/state.dart';
import 'package:provider/provider.dart';

class FindDriverScreen extends StatefulWidget {
  const FindDriverScreen({super.key});

  @override
  State<FindDriverScreen> createState() => _FindDriverScreenState();
}

class _FindDriverScreenState extends State<FindDriverScreen> {
  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);

    return Scaffold(
      body: Row(
        children: [
          FutureBuilder(
            future: MapController().getGeoPoints(
              appState.pickupAddress.placeId,
              appState.destinationAddress.placeId,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Calculating distance...",
                    style: TextStyle(fontSize: 20));
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}",
                    style: TextStyle(fontSize: 20));
              } else {
                GeoPoint? pickup = snapshot.data?[0];
                GeoPoint? destination = snapshot.data?[1];
                appState.setDestinationPoint(destination!);
                appState.setPickupPoint(pickup!);

                CameraPosition initialCameraPosition = CameraPosition(
                  target: LatLng(pickup.latitude, pickup.longitude),
                  zoom: 14.4746,
                );
                return GoogleMap(
                  initialCameraPosition: initialCameraPosition,
                );
              }
            },
          ),
          // GoogleMap(initialCameraPosition: ),
        ],
      ),
    );
  }
}
