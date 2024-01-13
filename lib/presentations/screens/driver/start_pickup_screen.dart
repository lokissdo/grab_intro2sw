import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grab/controller/map_controller.dart';
import 'package:grab/data/model/socket_msg_model.dart';
import 'package:grab/presentations/screens/driver/start_ride_screen.dart';
import 'package:grab/presentations/widget/confirm_button.dart';
import 'package:grab/presentations/widget/dashed_line_vertical_painter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grab/presentations/widget/profile_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final GlobalKey<ScaffoldState> jcbHomekey = GlobalKey();

class StartPickupScreen extends StatefulWidget {
  IO.Socket? socket;
  SocketMsgModel? socketMsg;
  StartPickupScreen({Key? key, required this.socket, required this.socketMsg})
      : super(key: key);

  @override
  State<StartPickupScreen> createState() => _StartPickupScreen();
}

class _StartPickupScreen extends State<StartPickupScreen> {
  final Completer<GoogleMapController> _mapController = Completer();
  final FirebaseAuth auth = FirebaseAuth.instance;
  late Future<Object>? _fetchData;
  bool isContainerVisible = true;
  Polyline _polyline = Polyline(polylineId: const PolylineId(''));
  late Timer timer;
  Position? currentPosition;
  Set<Marker> markers = {};

  void _addEventSocket() {
    widget.socket?.on('accept_ride', (msg) {
      widget.socketMsg = SocketMsgModel.fromJson(msg);
    });
  }

  @override
  void initState() {
    super.initState();
    _addEventSocket();
    _fetchData = _fetchPolyline();
    _getCurrentLocation();
  }

  Future<Object>? _fetchPolyline() async {
    try {
      List<LatLng> polylinePoints = await MapController().getPolylinePoints(
          GeoPoint(widget.socketMsg!.driverPosition!.latitude,
              widget.socketMsg!.driverPosition!.longitude),
          GeoPoint(widget.socketMsg!.customerPosition!.latitude,
              widget.socketMsg!.customerPosition!.longitude));
      Polyline polyline =
          await MapController().generatePolylineFromPoint(polylinePoints);

      return polyline;
    } catch (error) {
      print("Error: $error");
      return error;
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      currentPosition = position;
      markers.add(Marker(
        markerId: const MarkerId('currentLocation'),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: const InfoWindow(title: 'Current Location'),
      ));
    });
  }

  void startRoute(Polyline polyline) async {
    GoogleMapController controller = await _mapController.future;
    List<LatLng> points = polyline.points;

    int index = 0;

    void updateStateWithDelay() {
      if (index < points.length) {
        widget.socketMsg?.driverPosition = points[index];
        print('send location ${widget.socketMsg?.driverPosition}');
        widget.socket?.emit('send_location', widget.socketMsg?.toJson());

        controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: points[index], zoom: 15)));
        setState(() {
          markers.add(Marker(
            markerId: const MarkerId('currentLocation'),
            position: points[index],
            infoWindow: const InfoWindow(title: 'Current Location'),
          ));
        });

        timer = Timer(Duration(seconds: 5), () {
          index++;
          updateStateWithDelay();
        });
      }
    }

    updateStateWithDelay();
  }

  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: jcbHomekey,
      drawer: ProfileHomeScreen(),
      body: currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              alignment: Alignment.bottomCenter,
              children: [
                FutureBuilder(
                    future: _fetchData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Calculating distance...",
                            style: TextStyle(fontSize: 20));
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}",
                            style: TextStyle(fontSize: 20));
                      } else {
                        Polyline polyline = snapshot.data as Polyline;
                        return GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              widget.socketMsg!.pickupPoint!.latitude,
                              widget.socketMsg!.pickupPoint!.longitude,
                            ),
                            zoom: 15,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            _mapController.complete(controller);
                            startRoute(polyline);
                          },
                          polylines: Set<Polyline>.from([polyline]),
                          markers: markers,
                        );
                      }
                    }),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // IconButton to toggle visibility
                    Container(
                      decoration: BoxDecoration(
                        color: context.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: Icon(
                          isContainerVisible
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            isContainerVisible = !isContainerVisible;
                          });
                        },
                      ),
                    ),

                    // Visibility widget containing the container
                    Visibility(
                      visible:
                          isContainerVisible, // Control visibility based on the state variable
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(20))),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.all(
                                  10), // This adds 10 pixels of padding on all sides
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(),
                                  ),

                                  // Icons aligned to the right
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Row(
                                      mainAxisSize: MainAxisSize
                                          .min, // To keep the icons together
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape
                                                .circle, // Circular shape
                                            border: Border.all(
                                              color: Colors
                                                  .grey, // Black border color
                                              width: 2, // Border width
                                            ),
                                          ),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.message,
                                              color: Colors.yellow,
                                            ),
                                            onPressed: () {
                                              // Define the action when the button is pressed
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                            width:
                                                8), // Space between the icons
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape
                                                .circle, // Circular shape
                                            border: Border.all(
                                              color: Colors
                                                  .grey, // Black border color
                                              width: 2, // Border width
                                            ),
                                          ),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.local_phone,
                                              color: Colors.yellow,
                                            ),
                                            onPressed: () {
                                              // Define the action when the button is pressed
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 130, // Set the desired height for the Row
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      const Image(
                                        image: AssetImage(
                                            'assets/icons/location1.png'),
                                        width: 25,
                                        height: 25,
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Vị trí đón khách",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            Text(widget
                                                    .socketMsg?.pickupAddress ??
                                                ""),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.yellow),
                              ),
                              child: ConfirmButton(
                                  onPressed: () => {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    StartRideScreen(
                                                      socket: widget.socket,
                                                      socketMsg:
                                                          widget.socketMsg,
                                                    )))
                                      },
                                  text: "Xác nhận đón khách"),
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 16,
                  bottom: 400,
                  child: Container(
                      decoration: BoxDecoration(
                        color: context.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.near_me,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          // Định nghĩa hành động khi nút được nhấn
                        },
                      )),
                ),
                Positioned(
                  left: 16,
                  top: context.statusBarHeight + 16,
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: radius(100),
                        border: Border.all(
                            color: context.scaffoldBackgroundColor, width: 2),
                      ),
                      child: Image.asset(
                        'assets/profile.jpg',
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      ).cornerRadiusWithClipRRect(100).onTap(() {
                        jcbHomekey.currentState!.openDrawer();
                      }, borderRadius: radius(100))),
                )
              ],
            ),
    );
  }
}
