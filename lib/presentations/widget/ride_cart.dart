import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grab/data/model/ride_model.dart';


class RideCard extends StatelessWidget {
  final RideModel rideModel;

  const RideCard({Key? key, required this.rideModel}) : super(key: key);

  String formatTime(Timestamp time) {
    int hour = time.toDate().hour;
    int minute = time.toDate().minute;
    String formattedMinute = minute < 10 ? '0$minute' : '$minute';
    String formattedTime = '$hour:$formattedMinute';
    return formattedTime;
  }

  String returnMessgae(RideModel rideModel) {
    String message = "";
    if (rideModel.status == RideStatus.waiting) {
      message = "Driver is on the way";
    } else if (rideModel.status == RideStatus.moving) {
      message = "Drive picked you up";  
    }
    return message;
  }
 @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);

    String formattedTime = formatTime(rideModel.startTime);
    String message = returnMessgae(rideModel);
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Card(
        elevation: 0.0,
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${formattedTime}  ${message}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                ),
              ),
              SizedBox(height: 10.0), // Add some space between time and image
              SizedBox(
                height: 170.0,
                child: Placeholder(), // Replace with your image or UI representation
              ),
              ListTile(
                contentPadding: EdgeInsets.only(left: 0.0),
                title: Text(
                  rideModel.serviceId,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.pin_drop,
                      color: _theme.primaryColor,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Expanded(
                      child: Text(
                        "${rideModel.startLocation.stringName} - ${rideModel.endLocation.stringName}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "Price",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      "\$${rideModel.fare.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 24.0,
                        color: _theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}