import 'dart:async';
import 'package:grab/presentations/widget/confirm_button.dart';
import 'package:grab/presentations/widget/dashed_line_vertical_painter.dart';
import 'package:grab/utils/constants/themes.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grab/presentations/screens/search_destination_screen.dart';
import 'package:grab/presentations/widget/profile_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
final GlobalKey<ScaffoldState> jcbHomekey = GlobalKey();

class EndRideScreen extends StatefulWidget {
  const EndRideScreen({Key? key}) : super(key: key);

  @override
  State<EndRideScreen> createState() => _EndRideScreen();
}

class _EndRideScreen extends State<EndRideScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  final FirebaseAuth auth = FirebaseAuth.instance;

  bool isContainerVisible = true;
  
  Position? currentPosition;
  Set<Marker> markers = {};
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
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
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      currentPosition!.latitude,
                      currentPosition!.longitude,
                    ),
                    zoom: 15,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  markers: markers,
                ),
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
                        isContainerVisible ? Icons.arrow_downward : Icons.arrow_upward,
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
                  visible: isContainerVisible, // Control visibility based on the state variable
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
                        padding: EdgeInsets.all(10), // This adds 10 pixels of padding on all sides
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Customer name aligned to the left
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Customer Name", // Replace with your dynamic customer name
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                    ),
                              ),
                            ),
                            
        
      
                            
                            // Spacing between the text and the icons
                            Expanded(
                              child: Container(),
                            ),

                            // Icons aligned to the right
                            Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min, // To keep the icons together
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle, // Circular shape
                                      border: Border.all(
                                        color: Colors.grey, // Black border color
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
                                  SizedBox(width: 8), // Space between the icons
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle, // Circular shape
                                      border: Border.all(
                                        color: Colors.grey, // Black border color
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
                                  image:
                                      AssetImage('assets/icons/location1.png'),
                                  width: 25,
                                  height: 25,
                                ),
                                CustomPaint(
                                  size: const Size(1, 60),
                                  painter: DashedLineVerticalPainter(),
                                ),
                                const Image(
                                  image:
                                      AssetImage('assets/icons/location2.png'),
                                  width: 25,
                                  height: 25,
                                ),
                              ],
                            ),
                            SizedBox(width: 10),
                            const Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Vị trí bắt đầu",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text("168 Âu Dương Lân, P3, Q8, HCM"),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Vị trí kết thúc",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("5km",
                                              style: TextStyle(
                                                fontSize: 20,
                                              )),
                                        ],
                                      ),
                                      Text("168 Âu Dương Lân, P3, Q8, HCM"),
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
                          border: Border.all(color: Colors.grey),
                        ),
                        child: ConfirmButton(
                              onPressed: () => {},
                              text: "Đã đến nơi, kết thúc chuyến đi"),
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
