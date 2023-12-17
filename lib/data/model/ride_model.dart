import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grab/data/model/feedback_model.dart';

enum RideStatus { init, wait, move, finish }

class RideModel {
  static String collectionName = 'rides';
  RideModel({
    required this.id,
    required this.customerId,
    required this.driverId,
    required this.serviceId,
    required this.startLocation,
    required this.endLocation,
    required this.startTime,
    required this.endTime,
    required this.fare,
    required this.status,
    this.feedback,
  });
  String id;
  String customerId;
  String driverId;
  String serviceId;
  GeoPoint startLocation;
  GeoPoint endLocation;
  Timestamp startTime;
  Timestamp endTime;
  double fare;
  RideStatus status;
  FeedbackModel? feedback;

  static RideModel fromJson(Map<String, dynamic> map) {
    return RideModel(
      id: map["id"],
      driverId: map["driverId"],
      customerId: map["customerId"],
      serviceId: map["serviceId"],
      fare: map["fare"] as double,
      startLocation: map["startLocation"] as GeoPoint,
      endLocation: map["endLocation"] as GeoPoint,
      startTime: map["startTime"] as Timestamp,
      endTime: map["endTime"] as Timestamp,
      status: RideStatus.values.byName(map["status"]),
      feedback: map["feedback"] != null
          ? FeedbackModel.fromJson(map["feedback"])
          : null, // Use Address.fromJson()
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "driverId": driverId,
      "customerId": customerId,
      "fare": fare,
      "startLocation": startLocation,
      "endLocation": endLocation,
      "startTime": startTime,
      "endTime": endTime,
      "status":status.name,
      "feedback": feedback?.toJson(),
    };
  }
}
