import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grab/controller/map_controller.dart';
import 'package:grab/data/model/socket_msg_model.dart';
import 'package:grab/presentations/widget/progress_bar.dart';
import 'package:grab/state.dart';
import 'package:grab/utils/constants/themes.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class FindDriverScreen extends StatefulWidget {
  const FindDriverScreen({Key? key});

  @override
  State<FindDriverScreen> createState() => _FindDriverScreenState();
}

class _FindDriverScreenState extends State<FindDriverScreen> {
  late Map<PolylineId, Polyline> _polylines;
  Completer<GoogleMapController> _mapController = Completer();
  double currentProgress = 0.0;
  Timer? progressBarTimer;
  IO.Socket? socket;
  bool confirmRide = false;
  late Future<List<Object>?> _fetchData;
  bool haveDriver = false;
  LatLng? driverPosition;
  FirebaseAuth auth = FirebaseAuth.instance;
  SocketMsgModel? socketMsg = SocketMsgModel();

  @override
  void initState() {
    super.initState();
    _fetchData = _fetchPolylineAndGeoPoints();
    _initializeSocket();
  }

  @override
  void dispose() {
    super.dispose();
    progressBarTimer?.cancel();
  }

  void updateProgressBar() {
    const interval = Duration(milliseconds: 10);
    progressBarTimer = Timer.periodic(interval, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (haveDriver) {
          timer.cancel();
        } else {
          currentProgress = (currentProgress + 1) % 101;
        }
      });
    });
  }

  void _initializeSocket() {
    socket = IO.io(
      'http://192.168.1.2:3000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket?.connect();

    socket?.onConnect((_) {
      print('Connected to server');
    });

    socket?.on('accept_ride', (msg) {
      socketMsg = SocketMsgModel.fromJson(msg);
      socket?.emit('accept_ride', msg);
      setState(() {
        haveDriver = true;
      });
    });

    GoogleMapController? _controller;
    socket?.on('send_location', (msg) async {
      _controller ??= await _mapController.future;
      socketMsg = SocketMsgModel.fromJson(msg);
      _controller!.moveCamera(CameraUpdate.newLatLng(LatLng(
          socketMsg!.driverPosition!.latitude,
          socketMsg!.driverPosition!.longitude)));
      setState(() {
        driverPosition = LatLng(socketMsg!.driverPosition!.latitude,
            socketMsg!.driverPosition!.longitude);
      });
    });

    socket?.onDisconnect((_) => {
          print('Disconnected from server'),
          socket?.emit('user_disconnect', socketMsg)
        });
  }

  Future<List<Object>?> _fetchPolylineAndGeoPoints() async {
    print('re fetch');
    try {
      var appState = Provider.of<AppState>(context, listen: false);
      List<GeoPoint> geoPoints = await MapController().getGeoPoints(
        appState.pickupAddress.placeId,
        appState.destinationAddress.placeId,
      );
      List<LatLng> polylinePoints = await MapController().getPolylinePoints(
        geoPoints[0],
        geoPoints[1],
      );
      Polyline polyline =
          await MapController().generatePolylineFromPoint(polylinePoints);

      return [geoPoints, polyline];
    } catch (error) {
      print("Error: $error");
      return null;
    }
  }

  Future<void> fitPolylineBounds(List<GeoPoint> geoPoints) async {
    final GoogleMapController controller = await _mapController.future;
    var bounds;
    GeoPoint start = geoPoints[0];
    GeoPoint end = geoPoints[1];

    if (start.latitude > end.latitude) {
      bounds = LatLngBounds(
          northeast: LatLng(start.latitude, start.longitude),
          southwest: LatLng(end.latitude, end.longitude));
    } else {
      bounds = LatLngBounds(
          southwest: LatLng(start.latitude, start.longitude),
          northeast: LatLng(end.latitude, end.longitude));
    }

    LatLng centerBounds = LatLng(
        (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
        (bounds.northeast.longitude + bounds.southwest.longitude) / 2);

    controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: centerBounds,
      zoom: 17,
    )));
    bool keepZoomingOut = true;

    while (keepZoomingOut) {
      final LatLngBounds screenBounds = await controller.getVisibleRegion();
      if (fits(bounds, screenBounds)) {
        keepZoomingOut = false;
        final double zoomLevel = await controller.getZoomLevel() - 0.5;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
        break;
      } else {
        final double zoomLevel = await controller.getZoomLevel() - 0.1;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _fetchData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text("Calculating distance...",
                  style: TextStyle(fontSize: 20)),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}",
                  style: const TextStyle(fontSize: 20)),
            );
          } else {
            List<Object>? data = snapshot.data;
            List<GeoPoint> geoPoints = data?[0] as List<GeoPoint>;
            Polyline polyline = data?[1] as Polyline;

            _polylines = Map<PolylineId, Polyline>();
            _polylines[polyline.polylineId] = polyline;

            GeoPoint pickup = geoPoints[0];
            GeoPoint destination = geoPoints[1];

            var appState = Provider.of<AppState>(context);

            appState.setDestinationPoint(destination);
            appState.setPickupPoint(pickup);

            Set<Marker> markers = {};
            markers.add(Marker(
              markerId: const MarkerId('currentLocation'),
              position: LatLng(pickup.latitude, pickup.longitude),
              infoWindow: const InfoWindow(title: 'Current Location'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen),
            ));

            if (driverPosition != null) {
              markers.add(Marker(
                markerId: const MarkerId('driver'),
                position: driverPosition!,
                infoWindow: const InfoWindow(title: 'Driver'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue),
              ));
            } else {
              markers.add(Marker(
                markerId: const MarkerId('destination'),
                position: LatLng(destination.latitude, destination.longitude),
                infoWindow: const InfoWindow(title: 'Destination'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed),
              ));
            }

            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(pickup.latitude, pickup.longitude),
                    zoom: 15,
                  ),
                  polylines: _polylines.values
                      .where((polyline) => driverPosition == null)
                      .toSet(),
                  markers: markers,
                  onMapCreated: (GoogleMapController controller) {
                    _mapController.complete(controller);
                    fitPolylineBounds(geoPoints);
                  },
                ),
                Positioned(
                  top: 20,
                  left: 10,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.yellow,
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      'Back',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                if (haveDriver == true)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: Colors.yellow,
                      ),
                      onPressed: () => {},
                      child: const Text(
                        'Tài xế đang đón bạn',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  )
                else if (confirmRide == true && haveDriver == false)
                  Container(
                    height: 110,
                    alignment: Alignment.bottomCenter,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
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
                    ),
                  )
                else
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: Colors.yellow,
                      ),
                      child: const Text(
                        'Confirm ride',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      onPressed: () {
                        setState(() {
                          confirmRide = true;
                          FirebaseAuth auth = FirebaseAuth.instance;
                          User? user = auth.currentUser;

                          socketMsg?.customerId = user?.uid;
                          socketMsg?.customerPosition =
                              LatLng(pickup.latitude, pickup.longitude);
                          socketMsg?.destinationAddress =
                              appState.destinationAddress.stringName;
                          socketMsg?.pickupAddress =
                              appState.pickupAddress.stringName;
                          socketMsg?.pickupPoint =
                              LatLng(pickup.latitude, pickup.longitude);
                          socketMsg?.destinationPoint = LatLng(
                              destination.latitude, destination.longitude);
                          socketMsg?.distance = appState.distance;
                          socket?.emit('request_ride', socketMsg?.toJson());
                        });
                        updateProgressBar();
                      },
                    ),
                  ),
              ],
            );
          }
        },
      ),
    );
  }
}

bool fits(LatLngBounds fitBounds, LatLngBounds screenBounds) {
  final bool northEastLatitudeCheck =
      screenBounds.northeast.latitude >= fitBounds.northeast.latitude;
  final bool northEastLongitudeCheck =
      screenBounds.northeast.longitude >= fitBounds.northeast.longitude;

  final bool southWestLatitudeCheck =
      screenBounds.southwest.latitude <= fitBounds.southwest.latitude;
  final bool southWestLongitudeCheck =
      screenBounds.southwest.longitude <= fitBounds.southwest.longitude;

  return northEastLatitudeCheck &&
      northEastLongitudeCheck &&
      southWestLatitudeCheck &&
      southWestLongitudeCheck;
}
