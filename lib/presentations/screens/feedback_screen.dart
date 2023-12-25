import 'dart:async';
import 'package:grab/presentations/widget/confirm_button.dart';
import 'package:grab/presentations/widget/dashed_line_vertical_painter.dart';
import 'package:flutter/material.dart';
import 'package:grab/presentations/widget/progress_bar.dart';
import 'package:nb_utils/nb_utils.dart';

class FeedBackScreen extends StatefulWidget {
  const FeedBackScreen({Key? key}) : super(key: key);

  @override
  State<FeedBackScreen> createState() => _BookingRideScreenState();
}

class _BookingRideScreenState extends State<FeedBackScreen> {
  int selectedStar = 0;
  final commentController = TextEditingController();
  String getFeedbackText() {
    switch (selectedStar) {
      case 1:
        return "Tệ";
      case 2:
        return "Tạm được";
      case 3:
        return "Tốt";
      case 4:
        return "Rất tốt";
      case 5:
        return "Tuyệt vời";
      default:
        return "Hãy đánh giá";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
      child: Stack(children: [
        Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (context) => Positioned(
                top: 0,
                left: 0,
                bottom: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Color.fromARGB(95, 128, 128, 144),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: 200,
          left: -4,
          right: -4,
          bottom: -30,
          child: Container(
              child: DefaultTextStyle(
                  style: const TextStyle(
                      fontSize: 16, color: Color.fromARGB(255, 66, 66, 66)),
                  child: Card(
                    color: white, // Make card background transparent
                    elevation: 0, // Remove card shadow
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          18.0), // Optional: Add border radius
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 50,
                            ),
                            Expanded(child: ProgressBar()),
                            SizedBox(
                              width: 50,
                            ),
                            IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  // Add your close icon onPressed logic here
                                  print('Close icon pressed');
                                }),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(width: 20.0),
                            ...List.generate(5, (index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedStar = index + 1;
                                  });
                                },
                                child: Icon(
                                  Icons.star,
                                  size: 40,
                                  color: index < selectedStar
                                      ? Colors.yellow
                                      : Colors.grey,
                                ),
                              );
                            }),
                            SizedBox(width: 20.0),
                          ],
                        ),
                        Text(
                          getFeedbackText(),
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          selectedStar > 0
                              ? "Bạn đã đánh giá $selectedStar sao"
                              : "Hãy cho chúng tôi biêt độ hài lòng của bạn",
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                8.0), // Adjust the radius as needed
                            border: Border.all(color: Colors.grey),
                          ),
                          child: TextFormField(
                            controller: commentController,
                            decoration: InputDecoration(
                              hintText: "Nhận xét...",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ConfirmButton(onPressed: () => {}, text: "Gửi")
                          ],
                        )),
                        SizedBox(
                          height: 30,
                        )
                      ]),
                    ),
                  ))),
        )
      ]),
    ));
  }
}
