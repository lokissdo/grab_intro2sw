import 'package:grab/controller/map_controller.dart';
import 'package:grab/controller/ride_booking_controller.dart';
import 'package:grab/data/model/payment_method_model.dart';
import 'package:grab/presentations/screens/find_driver_screen.dart';
import 'package:grab/data/repository/payment_method_repository.dart';
import 'package:grab/presentations/screens/promotions_screen.dart';
import 'package:grab/presentations/widget/confirm_button.dart';
import 'package:grab/presentations/widget/dashed_line_vertical_painter.dart';
import 'package:flutter/material.dart';
import 'package:grab/presentations/widget/nav_bar.dart';
import 'package:grab/presentations/widget/vehicle_card.dart';
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
  double discountPercent = 0.0;
  List<PaymentMethodModel> paymentMethods = [];
  Map<String, dynamic> distance = {};
  String selectedCard = "Grab Bike";
  int fullCost = 50000;
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
Future<void> _showCardSelectionDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose a card'),
          content: Column(
            children: [
              InkWell(
                onTap: () {
                  _updateSelectedCard("Grab Bike");
                  Navigator.of(context).pop();
                },
                child: VehicleCard(
                  title: "Grab Bike",
                  imagePath: 'assets/icons/grab_bike.png',
                ),
              ),
              InkWell(
                onTap: () {
                  _updateSelectedCard("Uber");
                  Navigator.of(context).pop();
                },
                child: VehicleCard(
                  title: "Uber",
                  imagePath: 'assets/icons/grab_bike.png',
                ),
              ),
              // Add more cards as needed
            ],
          ),
        );
      },
    );
  }

  void _updateSelectedCard(String newCard) {
    setState(() {
      selectedCard = newCard;
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
                                      Text(
                                        appState.pickupAddress.stringName,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Vị trí kết thúc",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        appState.destinationAddress.stringName,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                     Padding(
                      padding: EdgeInsets.only(right: 30, left: 0, top: 20, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Khoảng cách:",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          FutureBuilder(
                            future: MapController().getDistance(
                              appState.pickupAddress.placeId,
                              appState.destinationAddress.placeId,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Text(
                                  "Đang tính ...",
                                  style: TextStyle(fontSize: 20),
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                  "Error: ${snapshot.error}",
                                  style: TextStyle(fontSize: 20),
                                );
                              } else {
                                String distanceText = "${snapshot.data?['distance']}"; // Use the correct key for distance
                                return Text(
                                  distanceText,
                                  style: TextStyle(fontSize: 20),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 270, // Adjust the width as needed
                            child: VehicleCard(
                              title: selectedCard,
                              imagePath: 'assets/icons/grab_bike.png',
                            ),
                          ),
                          IconButton(
                            onPressed: () => _showCardSelectionDialog(context),
                            icon: Icon(
                              Icons.arrow_forward,
                              size: 24,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),

                      
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Áp dụng giảm giá!"),
                          IconButton(
                            onPressed: () async {
                              // Navigate to PromotionsScreen and wait for result
                              final selectedPromotionPercent =
                                  await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PromotionsScreen(),
                                ),
                              );

                              // Handle the returned promotion percent
                              if (selectedPromotionPercent != null) {
                                // Use the selected promotion percent in your logic here
                                discountPercent = selectedPromotionPercent;
                              } else {
                                discountPercent = 0.0;
                              }
                              setState(() {
                                discountPercent = selectedPromotionPercent;
                              });
                            },
                            icon: Icon(
                              Icons
                                  .arrow_forward, // Replace with your desired icon
                              size: 24,
                              color: Colors.black, // Adjust color as needed
                            ),
                          ),
                        ],
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 0,
                            ),
                              Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Khuyến mãi"),
                                // Display discount amount based on discountPercent
                                Text(discountPercent > 0
                                    ? "${(fullCost * discountPercent / 100).toStringAsFixed(2)} \đ"
                                    : "\0đ"),
                              ],
                            ),
                              SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Tổng",
                                  style: TextStyle(fontSize: 25),
                                ),
                                Text(
                                  "${(fullCost * (100 - discountPercent) / 100).toStringAsFixed(2)} \đ",
                                  style: TextStyle(fontSize: 25),
                                )
                              ],
                            ),
                            
                          ]),
                      const SizedBox(
                        height: 20,
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
                              onPressed: selectedPaymentMethodIndex == -1
                                  ? null // Disable the button if no payment method is selected
                                  : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FindDriverScreen(),
                                        ),
                                      );
                                    },
                              text: "Xác nhận chuyến đi",
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ))),
    );
  }
}
