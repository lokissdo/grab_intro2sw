import 'dart:async';
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

  void updateProgressBar() {
    const interval =
        Duration(milliseconds: 100); // Adjust the interval as needed
    progressBarTimer = Timer.periodic(interval, (timer) {
      setState(() {
        currentProgress = (currentProgress + 1) %
            101; // Increment progress from 0 to 100 and repeat
      });
    });
  }

  @override
  void initState() {
    super.initState();
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
          child: Stack(
            children: [
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
                  isSwitchedOn
                      ? Column(
                          children: [
                            Center(child: ProgressBar(width: 30, height: 5)),
                            Row(
                              children: [
                                const Image(
                                  image:
                                      AssetImage('assets/icons/grab_bike.png'),
                                  width: 30,
                                  height: 30,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: Text(
                                  "Đang tìm chuyến đi...",
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
                      : Container()
                ]),
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
        ));
  }
}
