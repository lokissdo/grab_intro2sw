import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grab/controller/map_controller.dart';
import 'package:grab/controller/socket/socket_customer_controller.dart';
import 'package:grab/presentations/widget/progress_bar.dart';
import 'package:grab/state.dart';
import 'package:grab/utils/constants/themes.dart';
import 'package:provider/provider.dart';

class FindDriverScreen extends StatefulWidget {
  const FindDriverScreen({super.key});

  @override
  State<FindDriverScreen> createState() => _FindDriverScreenState();
}

class _FindDriverScreenState extends State<FindDriverScreen> {
  late SocketCustomerController socketCustomerController;
  late Map<PolylineId, Polyline> _polylines;
  double currentProgress = 0.0;
  Timer? progressBarTimer;

  @override
  void initState() {
    print('Call init state');
    super.initState();
    socketCustomerController = SocketCustomerController();
    socketCustomerController.initSocket();
  }

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);

    return Scaffold(
      body: Row(
        children: [
          FutureBuilder(
            future: MapController()
                .getGeoPoints(
                  appState.pickupAddress.placeId,
                  appState.destinationAddress.placeId,
                )
                .then((geoPoints) => MapController()
                    .getPolylinePoints(geoPoints[0], geoPoints[1])
                    .then((polylinePoints) => MapController()
                        .generatePolylineFromPoint(polylinePoints)
                        .then((polyline) => [geoPoints, polyline]))),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Calculating distance...",
                    style: TextStyle(fontSize: 20));
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}",
                    style: TextStyle(fontSize: 20));
              } else {
                List<Object>? geoPoints = snapshot.data?[0] as List<Object>?;
                Polyline? polyline = snapshot.data?[1] as Polyline;

                _polylines = Map<PolylineId, Polyline>();
                _polylines[polyline.polylineId] = polyline;

                GeoPoint? pickup = geoPoints?[0] as GeoPoint?;
                GeoPoint? destination = geoPoints?[1] as GeoPoint?;

                appState.setDestinationPoint(destination!);
                appState.setPickupPoint(pickup!);

                Set<Marker> markers = {};
                markers.add(Marker(
                  markerId: MarkerId('currentLocation'),
                  position: LatLng(pickup.latitude, pickup.longitude),
                  infoWindow: InfoWindow(title: 'Current Location'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueGreen),
                ));

                markers.add(Marker(
                  markerId: MarkerId('destination'),
                  position: LatLng(destination.latitude, destination.longitude),
                  infoWindow: InfoWindow(title: 'Destination'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
                ));
                return Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                          target: LatLng(
                            pickup.latitude,
                            pickup.longitude,
                          ),
                          zoom: 15),
                      polylines: Set<Polyline>.of(_polylines.values),
                      markers: markers,
                      // onMapCreated: (GoogleMapController controller) {
                      //   _controller.complete(controller);
                      // },
                    ),
                    Column(
                      children: [
                        Center(child: ProgressBar(width: 30, height: 5)),
                        Row(
                          children: [
                            const Image(
                              image: AssetImage('assets/icons/grab_bike.png'),
                              width: 30,
                              height: 30,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: Text(
                              "Đang tìm tài xế...",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                          ],
                        ),
                        ProgressBar(
                          width: double.infinity,
                          height: 5,
                          color: MyTheme.splash,
                          value: currentProgress / 100,
                        )
                      ],
                    )
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
