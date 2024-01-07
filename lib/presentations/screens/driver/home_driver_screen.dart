import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grab/controller/map_controller.dart';
import 'package:grab/utils/constants/styles.dart';
import 'package:grab/utils/constants/themes.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:grab/presentations/screens/search_destination_screen.dart';
import 'package:grab/presentations/widget/profile_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grab/presentations/widget/progress_bar.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final GlobalKey<ScaffoldState> jcbHomekey = GlobalKey();

class HomeDriverScreen extends StatefulWidget {
  const HomeDriverScreen({Key? key}) : super(key: key);

  @override
  State<HomeDriverScreen> createState() => _HomeDriverScreenState();
}

class _HomeDriverScreenState extends State<HomeDriverScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isSwitchedOn = false; // Initial state is "on"
  double currentProgress = 0.0;
  Timer? progressBarTimer;
  IO.Socket? socket;
  bool haveRide = false;
  Position? currentPosition;
  Set<Marker> markers = {};
  String? customerId;
  String? customerSocketId;
  LatLng? customerPosition;
  bool acceptRide = false;
  Polyline _polylines = Polyline(polylineId: const PolylineId(''));
  Completer<GoogleMapController> _mapController = Completer();

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

  void _initializeSocket() {
    socket = IO.io(
      'http://192.168.1.6:3000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket?.connect();
    socket?.onConnect((_) {
      print('Connected to server');
    });
    socket?.on('request_ride', (msg) {
      setState(() {
        haveRide = true;
        customerId = msg['customerId'];
        customerSocketId = msg['id'];
        customerPosition =
            LatLng(msg['position']['lat'], msg['position']['lng']);
      });
      print(msg);
    });
    socket?.onDisconnect((_) => {
          print('Disconnected from server'),
          socket?.emit('user_disconnect', {
            'id': auth.currentUser?.uid,
          })
        });
  }

  void _startRoute(Polyline polyline) async {
    GoogleMapController controller = await _mapController.future;
    List<LatLng> points = polyline!.points;

    int index = 0;

    void updateStateWithDelay() {
      if (index < points.length) {
        socket?.emit('send_location', {
          'customerId': customerId,
          'driverId': auth.currentUser!.uid,
          'position': {
            'lat': points[index].latitude,
            'lng': points[index].longitude
          }
        });
        controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: points[index], zoom: 15)));
        setState(() {
          markers.add(Marker(
            markerId: const MarkerId('currentLocation'),
            position: points[index],
            infoWindow: const InfoWindow(title: 'Current Location'),
          ));
        });

        Timer(Duration(seconds: 5), () {
          index++;
          updateStateWithDelay();
        });
      }
    }

    updateStateWithDelay();
  }

  void updateProgressBar() {
    const interval = Duration(milliseconds: 10);
    progressBarTimer = Timer.periodic(interval, (timer) {
      if (this.mounted) {
        setState(() {
          currentProgress = (currentProgress + 1) % 101;
        });
      } else {
        timer.cancel();
        return;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _initializeSocket();
    if (isSwitchedOn) {
      updateProgressBar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: jcbHomekey,
        drawer: ProfileHomeScreen(),
        body: SafeArea(
          child: currentPosition == null
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          currentPosition!.latitude,
                          currentPosition!.longitude,
                        ),
                        zoom: 15,
                      ),
                      onMapCreated: (controller) =>
                          _mapController.complete(controller),
                      markers: markers,
                      polylines: {
                        if (_polylines.polylineId != '') _polylines,
                      },
                    ),
                    Positioned(
                      right: 50,
                      top: MediaQuery.of(context).size.height / 2 - 50,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                              20), // You can adjust the radius as needed
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(8),
                        child: Observer(
                          builder: (_) => GestureDetector(
                            onTap: () {
                              setState(() {
                                isSwitchedOn = !isSwitchedOn;

                                if (isSwitchedOn) {
                                  updateProgressBar();
                                } else {
                                  progressBarTimer?.cancel();
                                }
                              });
                            },
                            child: Image.asset(
                              isSwitchedOn
                                  ? 'assets/icons/on.png'
                                  : 'assets/icons/off.png',
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 50,
                      right: 20,
                      left: 20,
                      child: Column(children: [
                        Center(
                            child: Text(
                          isSwitchedOn
                              ? 'Chế độ nhận chuyến đã được bật'
                              : 'Chế độ nhận chuyến đã tắt',
                          style: MyStyles.boldTextStyle,
                        )),
                        SizedBox(height: 30),
                        isSwitchedOn && !haveRide && !acceptRide
                            ? Column(
                                children: [
                                  Center(
                                      child: ProgressBar(width: 30, height: 5)),
                                  Row(
                                    children: [
                                      const Image(
                                        image: AssetImage(
                                            'assets/icons/grab_bike.png'),
                                        width: 30,
                                        height: 30,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                          child: Text(
                                        "Đang tìm chuyến đi...",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
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
                            : isSwitchedOn && haveRide && !acceptRide
                                ? AlertDialog(
                                    title: Text('Have new ride request'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('You have a ride request.'),
                                        SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                socket?.emit('accept_ride', {
                                                  'customerId': customerId,
                                                  'driverId':
                                                      auth.currentUser!.uid,
                                                  'customerSocketId':
                                                      customerSocketId
                                                });

                                                setState(() {
                                                  acceptRide = true;
                                                  MapController()
                                                      .getPolylinePoints(
                                                          GeoPoint(
                                                              currentPosition!
                                                                  .latitude,
                                                              currentPosition!
                                                                  .longitude),
                                                          GeoPoint(
                                                              customerPosition!
                                                                  .latitude,
                                                              customerPosition!
                                                                  .longitude))
                                                      .then((polylinePoints) =>
                                                          MapController()
                                                              .generatePolylineFromPoint(
                                                                  polylinePoints)
                                                              .then(
                                                                  (polyline) =>
                                                                      {
                                                                        _startRoute(
                                                                            polyline),
                                                                        _polylines =
                                                                            polyline
                                                                      }));

                                                  markers.add(Marker(
                                                    markerId: const MarkerId(
                                                        'customerLocation'),
                                                    position: LatLng(
                                                        customerPosition!
                                                            .latitude,
                                                        customerPosition!
                                                            .longitude),
                                                    infoWindow: const InfoWindow(
                                                        title:
                                                            'Customer Location'),
                                                  ));
                                                });
                                              },
                                              child: Text('Accept'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {},
                                              child: Text('Decline'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                      ]),
                    ),
                    Positioned(
                      left: 16,
                      top: context.statusBarHeight + 16,
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: radius(100),
                            border: Border.all(
                                color: context.scaffoldBackgroundColor,
                                width: 2),
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
        ));
  }
}
