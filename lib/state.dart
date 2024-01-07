import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grab/data/model/search_place_model.dart';

class AppState extends ChangeNotifier {
  late SearchPlaceModel _pickupAddress;
  late SearchPlaceModel _destinationAddress;
  late GeoPoint _pickupPoint;
  late GeoPoint _destinationPoint;
  AppState() {}

  SearchPlaceModel get pickupAddress => _pickupAddress;
  SearchPlaceModel get destinationAddress => _destinationAddress;
  GeoPoint get pickupPoint => _pickupPoint;
  GeoPoint get destinationPoint => _destinationPoint;

  void setPickupAddress(SearchPlaceModel address) {
    _pickupAddress = address;
    notifyListeners();
  }

  void setDestinationAddress(SearchPlaceModel address) {
    _destinationAddress = address;
    notifyListeners();
  }

  void setPickupPoint(GeoPoint point) {
    _pickupPoint = point;
//    notifyListeners();
  }

  void setDestinationPoint(GeoPoint point) {
    _destinationPoint = point;
    // notifyListeners();
  }
}
