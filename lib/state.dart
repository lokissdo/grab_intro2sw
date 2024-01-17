import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grab/data/model/customer_model.dart';
import 'package:grab/data/model/driver_model.dart';
import 'package:grab/data/model/search_place_model.dart';

class AppState extends ChangeNotifier {
  late SearchPlaceModel _pickupAddress;
  late SearchPlaceModel _destinationAddress;
  late GeoPoint _pickupPoint;
  late GeoPoint _destinationPoint;
  late String distance;
  late CustomerModel customer;
  late DriverModel driver;

  AppState();

  SearchPlaceModel get pickupAddress => _pickupAddress;
  SearchPlaceModel get destinationAddress => _destinationAddress;
  GeoPoint get pickupPoint => _pickupPoint;
  GeoPoint get destinationPoint => _destinationPoint;
  String get getDistance => distance;
  CustomerModel get getCustomer => customer;
  DriverModel get getDriver => driver;

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

  void setDistance(String distance) {
    this.distance = distance;
    // notifyListeners();
  }

  void setCustomer(CustomerModel customer) {
    this.customer = customer;
    // notifyListeners();
  }

  void setDriver(DriverModel driver) {
    this.driver = driver;
    // notifyListeners();
  }
}
