import 'package:flutter/material.dart';
import 'package:grab/data/model/customer_model.dart';
import 'package:grab/presentations/widget/confirm_button.dart';
import 'package:grab/presentations/widget/dashed_line_vertical_painter.dart';
import 'package:grab/presentations/widget/nav_bar.dart';
import 'package:grab/presentations/widget/navbar_accept_ride.dart';
import 'package:grab/utils/constants/styles.dart';
import 'package:grab/utils/constants/themes.dart';

class AcceptRideScreen extends StatefulWidget {
  const AcceptRideScreen({Key? key}) : super(key: key);

  @override
  State<AcceptRideScreen> createState() => _FinishRideScreenState();
}

class _FinishRideScreenState extends State<AcceptRideScreen> {
  int selectedPayemntMethodIndex = -1;
  final String CASH_PAYMENT_NAME = 'cash';

    CustomerModel? fakerCustomerData ;
  @override
  void initState() {
    super.initState();
  }

  Widget buildCard(String imagePath, String text) {
    return Card(
      elevation: 0,
      color: Color.fromARGB(255, 252, 251, 236),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
        side: BorderSide(
            width: 2.0,
            color: Color.fromARGB(
                255, 243, 233, 33) // Border color when the card is selected
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
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      NavBarAcceptRide(title: "Khách hàng đang tìm bạn"),
                       const SizedBox(height: 30),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            fakerCustomerData?.name ?? "",
                            style: MyStyles.boldTextStyle,
                          ),
                          Text(
                            fakerCustomerData?.phoneNumber ?? "",
                            style:MyStyles.boldTextStyle,
                          )
                        ],
                      ),
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
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ConfirmButton(
                              onPressed: () => {},
                              text: "Đồng ý nhận chuyến đi"),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ))
                    ],
                  ),
                ),
              ))),
    );
  }
}
