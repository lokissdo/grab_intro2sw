import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grab/config/injection.dart';
import 'package:grab/data/model/address_model.dart';
import 'package:grab/data/model/ride_model.dart';
import 'package:grab/data/model/socket_msg_model.dart';
import 'package:grab/data/repository/ride_repository.dart';

class RideController {
  final RideRepository rideRepo = getIt.get<RideRepository>();

  Future<String> createRide(SocketMsgModel msg) async {
    RideModel ride = RideModel(
      id: "1",
      customerId: msg.customerId as String,
      driverId: msg.driverId as String,
      serviceId: "1",
      startLocation: AddressModel(
          coordinates:
              GeoPoint(msg.pickupPoint!.latitude, msg.pickupPoint!.longitude),
          stringName: msg.pickupAddress as String),
      endLocation: AddressModel(
          coordinates: GeoPoint(
              msg.destinationPoint!.latitude, msg.destinationPoint!.longitude),
          stringName: msg.destinationAddress as String),
      startTime: Timestamp.fromMicrosecondsSinceEpoch(
          DateTime.now().millisecondsSinceEpoch),
      endTime: Timestamp.fromMicrosecondsSinceEpoch(
          DateTime.now().millisecondsSinceEpoch),
      fare: 0,
      status: RideStatus.waiting,
      feedback: null,
    );
    return rideRepo.createRide(ride);
  }

  Future<void> updateStatusById(String id, RideStatus status) async {
    rideRepo.updateStatusById(id, status);
  }
}
