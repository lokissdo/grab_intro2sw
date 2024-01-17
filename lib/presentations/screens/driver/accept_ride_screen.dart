import 'package:flutter/material.dart';
import 'package:grab/data/model/customer_model.dart';
import 'package:grab/data/model/socket_msg_model.dart';
import 'package:grab/presentations/screens/driver/start_pickup_screen.dart';
import 'package:grab/presentations/widget/confirm_button.dart';
import 'package:grab/presentations/widget/dashed_line_vertical_painter.dart';
import 'package:grab/presentations/widget/nav_bar.dart';
import 'package:grab/presentations/widget/navbar_accept_ride.dart';
import 'package:grab/utils/constants/styles.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class AcceptRideScreen extends StatefulWidget {
  IO.Socket? socket;
  SocketMsgModel? socketMsg;

  AcceptRideScreen({Key? key, required this.socket, required this.socketMsg})
      : super(key: key);

  @override
  State<AcceptRideScreen> createState() => _FinishRideScreenState();
}

class _FinishRideScreenState extends State<AcceptRideScreen> {
  int selectedPaymentMethodIndex = -1;
  final String CASH_PAYMENT_NAME = 'cash';
  CustomerModel? fakerCustomerData;


  @override
  void initState() {
    super.initState();
  }

  void acceptRide() {
    widget.socket?.emit('accept_ride', {widget.socketMsg?.toJson()});
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return StartPickupScreen(
        socket: widget.socket,
        socketMsg: widget.socketMsg,
      );
    }));
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
                      NavBar(title: "Có chuyến xe mới", backText: "",),
                      const SizedBox(height: 30),
                      const Text(
                        "Thông tin chuyến đi",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                                        widget.socketMsg?.pickupAddress ?? "",
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
                                        widget.socketMsg?.destinationAddress ?? "",
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
                      


                      const SizedBox(
                        height: 200,
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
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Hình thức thanh toán",
                                      style: MyStyles.boldTextStyle,
                                    ),
                                    Text(
                                      "Tiền mặt",
                                      style: MyStyles.boldTextStyle,
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Giá tiền",
                                      style: MyStyles.boldTextStyle,
                                    ),
                                    Text(
                                      "100.000đ",
                                      style: MyStyles.boldTextStyle,
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Khoảng cách",
                                      style: MyStyles.boldTextStyle,
                                    ),
                                    Text(
                                      "10km",
                                      style: MyStyles.boldTextStyle,
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Thời gian",
                                      style: MyStyles.boldTextStyle,
                                    ),
                                    Text(
                                      "20 phút",
                                      style: MyStyles.boldTextStyle,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )),
                      Expanded(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ConfirmButton(
              onPressed: () => {acceptRide()},
              text: "Từ chối",
              color: Colors.red,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: ConfirmButton(
              onPressed: () => {acceptRide()},
              text: "Đồng ý",
            ),
          ),
        ],
      ),
      SizedBox(
        height: 10,
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
