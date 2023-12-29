
import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  final String stringName;
  final GeoPoint coordinates;

  AddressModel({
    required this.stringName,
    required this.coordinates,
  });
  Map<String, dynamic> toJson() {
    return {
      "stringName": stringName,
      "coordinates": {
        "latitude": coordinates.latitude,
        "longitude": coordinates.longitude,
      }
    };
  }

  static AddressModel fromJson(Map<String, dynamic> map) {
    return AddressModel(
      stringName: map["stringName"],
      coordinates: GeoPoint(
        map["coordinates"]["latitude"],
        map["coordinates"]["longitude"],
      ),
    );
  }
}
