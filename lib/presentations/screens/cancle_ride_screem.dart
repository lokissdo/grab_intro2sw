import 'dart:async';
import 'package:grab/presentations/widget/confirm_button.dart';
import 'package:grab/presentations/widget/dashed_line_vertical_painter.dart';
import 'package:flutter/material.dart';
import 'package:grab/presentations/widget/nav_bar.dart';
import 'package:grab/utils/constants/styles.dart';

class CancleRideScreen extends StatefulWidget {
  const CancleRideScreen({Key? key}) : super(key: key);

  @override
  State<CancleRideScreen> createState() => _CancleRideScreenState();
}

class _CancleRideScreenState extends State<CancleRideScreen> {
  int? selectedReasonIndex;
  TextEditingController differentReasonController = new TextEditingController();
  List<String> cancellationReasons = [
    "Thời gian chờ quá lâu",
    "Tôi không liên lạc được tài xế",
    "Tôi đã đặt một chuyến khác",
    "Tôi đặt sai địa điểm",
    "Giá cả không hợp lý"
  ];

  Widget buildCheckbox(int index) {
    bool isSelected = selectedReasonIndex == index;
    return GestureDetector(
        onTap: () {
          setState(() {
            selectedReasonIndex = index;
          });
        },
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Card(
                elevation: 0,
                color: Color.fromARGB(255, 255, 255, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: BorderSide(
                    width: 2.5,
                    color: isSelected
                        ? Color.fromARGB(255, 243, 233, 33)
                        : Color.fromARGB(255, 211, 211, 211),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        isSelected
                            ? Icons.check_box
                            : Icons.square_outlined,
                        color: isSelected ? Colors.green : Colors.grey,
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Text(
                        cancellationReasons[index],
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                )),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        body: SafeArea(
      child: Container(
          margin: const EdgeInsets.all(20.0),
          alignment: const Alignment(0.6, 0.6),
          child: DefaultTextStyle(
              style: MyStyles.myDefaultTextStyle,
              child: Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NavBar(title: "Hủy chuyến"),
                      const SizedBox(height: 30),
                      Center(
                          child: Text(
                        "Vui lòng chọn lý do để hủy",
                        style: MyStyles.tinyTextStyle,
                      )),
                      for (int i = 0; i < cancellationReasons.length; i++)
                        buildCheckbox(i),
                        SizedBox(height: 20,),
                      Container(
                          padding: EdgeInsets.all(8.0),
                          margin: EdgeInsets.all(2.5),
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                8.0), // Adjust the radius as needed
                            border: Border.all(color: Colors.grey,width: 1.5),
                          ),
                            child: TextFormField(
                              controller: differentReasonController,
                              decoration: InputDecoration(
                                hintText: " Khác...",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                            SizedBox(height: 20,),
                            ConfirmButton(onPressed: ()=>{}, text: "Gửi")
                    ]),
              ))),
    ));
  }
}
