import 'package:grab/controller/map_controller.dart';
import 'package:grab/controller/ride_booking_controller.dart';
import 'package:grab/data/model/payment_method_model.dart';
import 'package:grab/presentations/widget/confirm_button.dart';
import 'package:grab/presentations/widget/dashed_line_vertical_painter.dart';
import 'package:flutter/material.dart';
import 'package:grab/presentations/widget/nav_bar.dart';
import 'package:grab/state.dart';
import 'package:grab/utils/constants/icons.dart';
import 'package:provider/provider.dart';

class BookingRideScreen extends StatefulWidget {
  const BookingRideScreen({Key? key}) : super(key: key);

  @override
  State<BookingRideScreen> createState() => _BookingRideScreenState();
}

class _BookingRideScreenState extends State<BookingRideScreen> {
  int selectedPaymentMethodIndex = -1;
  List<PaymentMethodModel> paymentMethods = [];
  Map<String, dynamic> distance = {};

  @override
  void initState() {
    super.initState();
    // Use initState to fetch data when the widget is created
    _loadPaymentMethods();
  }

  // Asynchronous function to fetch payment methods
  _loadPaymentMethods() async {
    RideBookingController rideBookingController = RideBookingController();
    List<PaymentMethodModel> methods =
        await rideBookingController.getAllPaymentMethods();

    // Update the state with the fetched payment methods
    setState(() {
      paymentMethods = methods;
    });
  }

  Widget buildCard(int index, String imagePath, String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethodIndex = index;
        });
      },
      child: Card(
        elevation: 0,
        color: Color.fromARGB(255, 252, 251, 236),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: BorderSide(
            width: 2.0,
            color: selectedPaymentMethodIndex == index
                ? Color.fromARGB(
                    255, 243, 233, 33) // Border color when the card is selected
                : Color.fromARGB(255, 252, 251, 236),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 20),
            Image(
              image: AssetImage(imagePath),
              width: 70,
              height: 70,
            ),
            SizedBox(width: 20),
            Text(
              text,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);

    return Scaffold(
      body: SafeArea(
          child: Container(
              margin: const EdgeInsets.all(20.0),
              alignment: const Alignment(0.6, 0.6),
              child: DefaultTextStyle(
                style: const TextStyle(
                    fontSize: 16, color: Color.fromARGB(255, 66, 66, 66)),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NavBar(title: "Đặt xe"),
                      const SizedBox(height: 30),
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
                            Expanded(
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
                                      Text(appState.pickupAddress.stringName),
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
                                          FutureBuilder(
                                            future: MapController().getDistance(
                                              appState.pickupAddress.placeId,
                                              appState
                                                  .destinationAddress.placeId,
                                            ),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Text(
                                                    "Calculating distance...",
                                                    style: TextStyle(
                                                        fontSize: 20));
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    "Error: ${snapshot.error}",
                                                    style: TextStyle(
                                                        fontSize: 20));
                                              } else {
                                                String distanceText =
                                                    "${snapshot.data?['distance']}"; // Use the correct key for distance
                                                return Text(
                                                  distanceText,
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      Text(appState
                                          .destinationAddress.stringName),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Card(
                          elevation: 0,
                          color: const Color.fromARGB(255, 252, 251, 236),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Set the border radius
                            side: const BorderSide(
                                width: 2.0,
                                color: Color.fromARGB(
                                    255, 255, 255, 47)), // Set the border color
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(
                                right: 30, left: 30, top: 10, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Grab Bike",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Image(
                                  image:
                                      AssetImage('assets/icons/grab_bike.png'),
                                  width: 70,
                                  height: 70,
                                )
                              ],
                            ),
                          )),
                      const Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Tổng",
                                  style: TextStyle(fontSize: 25),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Giá cước"),
                                Text("\$200"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Khuyến mãi"),
                                Text("-\$5"),
                              ],
                            )
                          ]),
                      const SizedBox(
                        height: 30,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Hình thức thanh toán",
                            style: TextStyle(fontSize: 25),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          for (int i = 0; i < paymentMethods.length; i++)
                            buildCard(
                                i,
                                IconPath.payment[paymentMethods[i].name]!,
                                paymentMethods[i].description),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ConfirmButton(
                              onPressed: () => {}, text: "Xác nhận chuyến đi")
                        ],
                      ))
                    ],
                  ),
                ),
              ))),
    );
  }
}
