import 'package:google_maps_flutter/google_maps_flutter.dart';

class SocketMsgModel {
  String? customerId;
  String? driverId;
  String? rideId;
  String? customerSocketId;
  String? driverSocketId;
  LatLng? pickupPoint;
  LatLng? destinationPoint;
  String? pickupAddress;
  String? destinationAddress;
  LatLng? customerPosition;
  LatLng? driverPosition;

  SocketMsgModel({
    this.rideId,
    this.customerId,
    this.driverId,
    this.customerSocketId,
    this.driverSocketId,
    this.pickupPoint,
    this.destinationPoint,
    this.pickupAddress,
    this.destinationAddress,
    this.customerPosition,
    this.driverPosition,
  });

  static SocketMsgModel fromJson(Map<String, dynamic> json) {
    return SocketMsgModel(
      rideId: json['rideId'] ?? '',
      customerId: json['customerId'] ?? '',
      driverId: json['driverId'] ?? '',
      customerSocketId: json['customerSocketId'] ?? '',
      driverSocketId: json['driverSocketId'] ?? '',
      pickupPoint: json['pickupPoint'] != null
          ? LatLng(
              json['pickupPoint']['latitude'], json['pickupPoint']['longitude'])
          : null,
      destinationPoint: json['destinationPoint'] != null
          ? LatLng(json['destinationPoint']['latitude'],
              json['destinationPoint']['longitude'])
          : null,
      pickupAddress: json['pickupAddress'] ?? '',
      destinationAddress: json['destinationAddress'] ?? '',
      customerPosition: json['customerPosition'] != null
          ? LatLng(json['customerPosition']['latitude'],
              json['customerPosition']['longitude'])
          : null,
      driverPosition: json['driverPosition'] != null
          ? LatLng(json['driverPosition']['latitude'],
              json['driverPosition']['longitude'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rideId': rideId,
      'customerId': customerId,
      'driverId': driverId,
      'customerSocketId': customerSocketId,
      'driverSocketId': driverSocketId,
      'pickupPoint': pickupPoint != null
          ? {
              'latitude': pickupPoint!.latitude,
              'longitude': pickupPoint!.longitude
            }
          : null,
      'destinationPoint': destinationPoint != null
          ? {
              'latitude': destinationPoint!.latitude,
              'longitude': destinationPoint!.longitude
            }
          : null,
      'pickupAddress': pickupAddress,
      'destinationAddress': destinationAddress,
      'customerPosition': customerPosition != null
          ? {
              'latitude': customerPosition!.latitude,
              'longitude': customerPosition!.longitude
            }
          : null,
      'driverPosition': driverPosition != null
          ? {
              'latitude': driverPosition!.latitude,
              'longitude': driverPosition!.longitude
            }
          : null,
    };
  }
}
